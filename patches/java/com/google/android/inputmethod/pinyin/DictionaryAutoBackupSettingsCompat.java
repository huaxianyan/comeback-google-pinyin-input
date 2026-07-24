package com.google.android.inputmethod.pinyin;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.preference.CheckBoxPreference;
import android.preference.ListPreference;
import android.preference.Preference;
import android.preference.PreferenceFragment;
import android.provider.OpenableColumns;
import android.text.format.DateFormat;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.WeakHashMap;

/** Binds the local-backup controls on Pinyin's dictionary settings screen. */
public final class DictionaryAutoBackupSettingsCompat {
    private static final int REQUEST_TREE = 0x6b01;
    private static final String KEY_LOCATION = "dictionary_auto_backup_location";
    private static final String KEY_BACKUP_NOW = "dictionary_auto_backup_now";
    private static final Map<PreferenceFragment, Controller> CONTROLLERS =
            new WeakHashMap<PreferenceFragment, Controller>();

    private DictionaryAutoBackupSettingsCompat() {}

    public static void bind(PreferenceFragment fragment) {
        if (fragment == null || fragment.getActivity() == null) return;
        synchronized (CONTROLLERS) {
            Controller old = CONTROLLERS.remove(fragment);
            if (old != null) old.destroy();
            Controller controller = new Controller(fragment);
            CONTROLLERS.put(fragment, controller);
            controller.bind();
        }
    }

    public static boolean handleActivityResult(PreferenceFragment fragment, int requestCode,
            int resultCode, Intent data) {
        if (requestCode != REQUEST_TREE) return false;
        Controller controller;
        synchronized (CONTROLLERS) { controller = CONTROLLERS.get(fragment); }
        if (controller != null) controller.onTreeResult(resultCode, data);
        return true;
    }

    public static void refresh(PreferenceFragment fragment) {
        Controller controller;
        synchronized (CONTROLLERS) { controller = CONTROLLERS.get(fragment); }
        if (controller != null) controller.refresh();
    }

    public static void unbind(PreferenceFragment fragment) {
        synchronized (CONTROLLERS) {
            Controller controller = CONTROLLERS.remove(fragment);
            if (controller != null) controller.destroy();
        }
    }

    static void refreshAll() {
        final List<Controller> snapshot;
        synchronized (CONTROLLERS) {
            snapshot = new ArrayList<Controller>(CONTROLLERS.values());
        }
        for (Controller controller : snapshot) controller.refresh();
    }

    private static final class Controller implements Preference.OnPreferenceClickListener,
            Preference.OnPreferenceChangeListener,
            DictionaryAutoBackupCompat.ValidationCallback {
        private PreferenceFragment fragment;
        private CheckBoxPreference enabledPreference;
        private Preference locationPreference;
        private ListPreference intervalPreference;
        private ListPreference retentionPreference;
        private Preference backupNowPreference;
        private boolean enableAfterPick;
        private boolean validating;
        private Uri pendingTree;

        Controller(PreferenceFragment fragment) { this.fragment = fragment; }

        void bind() {
            enabledPreference = (CheckBoxPreference) fragment.findPreference(
                    DictionaryAutoBackupCompat.KEY_ENABLED);
            locationPreference = fragment.findPreference(KEY_LOCATION);
            intervalPreference = (ListPreference) fragment.findPreference(
                    DictionaryAutoBackupCompat.KEY_INTERVAL);
            retentionPreference = (ListPreference) fragment.findPreference(
                    DictionaryAutoBackupCompat.KEY_RETENTION);
            backupNowPreference = fragment.findPreference(KEY_BACKUP_NOW);

            if (enabledPreference != null) enabledPreference.setOnPreferenceChangeListener(this);
            if (locationPreference != null) locationPreference.setOnPreferenceClickListener(this);
            if (intervalPreference != null) intervalPreference.setOnPreferenceChangeListener(this);
            if (retentionPreference != null) retentionPreference.setOnPreferenceChangeListener(this);
            if (backupNowPreference != null) backupNowPreference.setOnPreferenceClickListener(this);
            refresh();
        }

        void destroy() {
            fragment = null;
            enabledPreference = null;
            locationPreference = null;
            intervalPreference = null;
            retentionPreference = null;
            backupNowPreference = null;
        }

        private Context context() {
            return fragment == null || fragment.getActivity() == null ? null
                    : fragment.getActivity().getApplicationContext();
        }

        @Override public boolean onPreferenceClick(Preference preference) {
            Context context = context();
            if (context == null) return true;
            if (preference == locationPreference) {
                openTreePicker(false);
                return true;
            }
            if (preference == backupNowPreference) {
                DictionaryAutoBackupCompat.request(context, true);
                return true;
            }
            return false;
        }

        @Override public boolean onPreferenceChange(Preference preference, Object newValue) {
            Context context = context();
            if (context == null) return false;
            SharedPreferences p = DictionaryAutoBackupCompat.prefs(context);
            if (preference == enabledPreference) {
                boolean enabled = Boolean.TRUE.equals(newValue);
                if (!enabled) {
                    p.edit().putBoolean(DictionaryAutoBackupCompat.KEY_ENABLED, false).apply();
                    refreshSoon();
                    return true;
                }
                Uri tree = configuredTree(p);
                if (tree == null || !DictionaryAutoBackupCompat.hasPersistedAccess(context, tree)) {
                    openTreePicker(true);
                    return false;
                }
                p.edit().putBoolean(DictionaryAutoBackupCompat.KEY_ENABLED, true).apply();
                DictionaryAutoBackupCompat.request(context, true);
                refreshSoon();
                return true;
            }
            if (preference == intervalPreference) {
                int value = parseInt(newValue, 7);
                if (value < 1 || value > 365) value = 7;
                p.edit().putInt(DictionaryAutoBackupCompat.KEY_INTERVAL, value).apply();
                refreshSoon();
                return true;
            }
            if (preference == retentionPreference) {
                int value = parseInt(newValue, 10);
                if (value < 1 || value > 100) value = 10;
                p.edit().putInt(DictionaryAutoBackupCompat.KEY_RETENTION, value).apply();
                refreshSoon();
                return true;
            }
            return false;
        }

        private void openTreePicker(boolean enableAfterSelection) {
            if (fragment == null || validating) return;
            if (Build.VERSION.SDK_INT < 21) {
                Toast.makeText(fragment.getActivity(), "本地自动备份需要 Android 5.0 或更高版本",
                        Toast.LENGTH_SHORT).show();
                return;
            }
            enableAfterPick = enableAfterSelection;
            Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT_TREE);
            intent.putExtra(Intent.EXTRA_LOCAL_ONLY, true);
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION
                    | Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                    | Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION
                    | Intent.FLAG_GRANT_PREFIX_URI_PERMISSION);
            try {
                fragment.startActivityForResult(intent, REQUEST_TREE);
            } catch (RuntimeException e) {
                Toast.makeText(fragment.getActivity(), "无法打开本地目录选择器",
                        Toast.LENGTH_SHORT).show();
            }
        }

        void onTreeResult(int resultCode, Intent data) {
            if (fragment == null) return;
            if (resultCode != Activity.RESULT_OK || data == null || data.getData() == null) {
                enableAfterPick = false;
                refresh();
                return;
            }
            final Context context = context();
            if (context == null) return;
            Uri tree = data.getData();
            if (!DictionaryAutoBackupCompat.isLocalTree(tree)) {
                Toast.makeText(context, "请选择设备内部存储或本机 SD 卡目录，不支持云端位置",
                        Toast.LENGTH_LONG).show();
                enableAfterPick = false;
                refresh();
                return;
            }
            int flags = data.getFlags()
                    & (Intent.FLAG_GRANT_READ_URI_PERMISSION
                    | Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
            try {
                context.getContentResolver().takePersistableUriPermission(tree, flags);
            } catch (RuntimeException e) {
                Toast.makeText(context, "无法保存本地目录访问权限", Toast.LENGTH_LONG).show();
                enableAfterPick = false;
                refresh();
                return;
            }
            pendingTree = tree;
            validating = true;
            setControlsEnabled(false);
            Toast.makeText(context, "正在验证本地备份目录…", Toast.LENGTH_SHORT).show();
            DictionaryAutoBackupCompat.validateTreeAsync(context, tree, this);
        }

        @Override public void onValidationFinished(Uri tree, String error) {
            Context context = context();
            if (context == null) return;
            validating = false;
            if (pendingTree == null || !pendingTree.equals(tree)) {
                refresh();
                return;
            }
            pendingTree = null;
            if (error != null) {
                try {
                    context.getContentResolver().releasePersistableUriPermission(tree,
                            Intent.FLAG_GRANT_READ_URI_PERMISSION
                                    | Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
                } catch (RuntimeException ignored) {}
                Toast.makeText(context, error, Toast.LENGTH_LONG).show();
                enableAfterPick = false;
                refresh();
                return;
            }

            SharedPreferences p = DictionaryAutoBackupCompat.prefs(context);
            String oldValue = p.getString(DictionaryAutoBackupCompat.KEY_TREE_URI, null);
            boolean wasEnabled = p.getBoolean(DictionaryAutoBackupCompat.KEY_ENABLED, false);
            boolean shouldEnable = enableAfterPick || wasEnabled;
            enableAfterPick = false;
            String label = queryDisplayName(context.getContentResolver(), tree);
            p.edit().putString(DictionaryAutoBackupCompat.KEY_TREE_URI, tree.toString())
                    .putString(DictionaryAutoBackupCompat.KEY_TREE_LABEL, label)
                    .putBoolean(DictionaryAutoBackupCompat.KEY_ENABLED, shouldEnable)
                    .putString(DictionaryAutoBackupCompat.KEY_LAST_STATUS, "本地目录验证成功")
                    .apply();

            if (oldValue != null && !oldValue.equals(tree.toString())) {
                try {
                    context.getContentResolver().releasePersistableUriPermission(Uri.parse(oldValue),
                            Intent.FLAG_GRANT_READ_URI_PERMISSION
                                    | Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
                } catch (RuntimeException ignored) {}
            }
            Toast.makeText(context, "本地备份目录已设置", Toast.LENGTH_SHORT).show();
            refresh();
            if (shouldEnable) DictionaryAutoBackupCompat.request(context, true);
        }

        void refresh() {
            Context context = context();
            if (context == null) return;
            SharedPreferences p = DictionaryAutoBackupCompat.prefs(context);
            boolean enabled = p.getBoolean(DictionaryAutoBackupCompat.KEY_ENABLED, false);
            Uri tree = configuredTree(p);
            boolean accessible = tree != null
                    && DictionaryAutoBackupCompat.hasPersistedAccess(context, tree);

            if (enabledPreference != null) {
                enabledPreference.setChecked(enabled);
                String status = p.getString(DictionaryAutoBackupCompat.KEY_LAST_STATUS, null);
                long last = p.getLong(DictionaryAutoBackupCompat.KEY_LAST_SUCCESS, 0L);
                if (DictionaryAutoBackupCompat.isInProgress()) {
                    enabledPreference.setSummary("正在生成本地备份…");
                } else if (status != null && status.length() > 0 && !"备份成功".equals(status)) {
                    enabledPreference.setSummary(status);
                } else if (last > 0L) {
                    java.text.DateFormat date = DateFormat.getDateFormat(context);
                    java.text.DateFormat time = DateFormat.getTimeFormat(context);
                    enabledPreference.setSummary("上次备份：" + date.format(last) + " "
                            + time.format(last));
                } else {
                    enabledPreference.setSummary("尚未生成本地备份");
                }
                enabledPreference.setEnabled(!validating);
            }
            if (locationPreference != null) {
                String label = p.getString(DictionaryAutoBackupCompat.KEY_TREE_LABEL, null);
                if (tree == null) locationPreference.setSummary("未选择（仅设备本地）");
                else if (!accessible) locationPreference.setSummary("位置不可访问，请重新选择");
                else locationPreference.setSummary(label == null || label.length() == 0
                        ? "已选择设备本地目录" : label);
                locationPreference.setEnabled(!validating);
            }
            int interval = p.getInt(DictionaryAutoBackupCompat.KEY_INTERVAL, 7);
            int retention = p.getInt(DictionaryAutoBackupCompat.KEY_RETENTION, 10);
            if (intervalPreference != null) {
                intervalPreference.setValue(Integer.toString(interval));
                intervalPreference.setEnabled(enabled && accessible && !validating);
            }
            if (retentionPreference != null) {
                retentionPreference.setValue(Integer.toString(retention));
                retentionPreference.setEnabled(enabled && accessible && !validating);
            }
            if (backupNowPreference != null) {
                backupNowPreference.setEnabled(accessible && !validating
                        && !DictionaryAutoBackupCompat.isInProgress());
                backupNowPreference.setSummary(accessible
                        ? "立即导出到所选本地目录" : "请先选择本地备份位置");
            }
        }

        private void setControlsEnabled(boolean enabled) {
            if (enabledPreference != null) enabledPreference.setEnabled(enabled);
            if (locationPreference != null) locationPreference.setEnabled(enabled);
            if (intervalPreference != null) intervalPreference.setEnabled(enabled);
            if (retentionPreference != null) retentionPreference.setEnabled(enabled);
            if (backupNowPreference != null) backupNowPreference.setEnabled(enabled);
        }

        private void refreshSoon() {
            if (fragment != null && fragment.getActivity() != null) {
                fragment.getActivity().getWindow().getDecorView().post(new Runnable() {
                    @Override public void run() { refresh(); }
                });
            }
        }

        private static Uri configuredTree(SharedPreferences p) {
            String value = p.getString(DictionaryAutoBackupCompat.KEY_TREE_URI, null);
            if (value == null || value.length() == 0) return null;
            try { return Uri.parse(value); }
            catch (RuntimeException e) { return null; }
        }

        private static int parseInt(Object value, int fallback) {
            try { return Integer.parseInt(String.valueOf(value)); }
            catch (RuntimeException e) { return fallback; }
        }

        private static String queryDisplayName(ContentResolver resolver, Uri tree) {
            Cursor cursor = null;
            try {
                cursor = resolver.query(tree, new String[] {OpenableColumns.DISPLAY_NAME},
                        null, null, null);
                if (cursor != null && cursor.moveToFirst()) {
                    String name = cursor.getString(0);
                    if (name != null && name.length() > 0) return name;
                }
            } catch (RuntimeException ignored) {
            } finally {
                if (cursor != null) cursor.close();
            }
            return "设备本地备份目录";
        }
    }
}
