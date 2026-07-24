package com.google.android.inputmethod.pinyin;

import android.Manifest;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.os.Build;
import android.preference.ListPreference;
import android.preference.Preference;
import android.preference.PreferenceFragment;
import android.preference.TwoStatePreference;
import android.text.format.DateFormat;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.WeakHashMap;

/** Binds fixed-path local backup controls. */
public final class DictionaryAutoBackupSettingsCompat {
    private static final String KEY_LOCATION = "dictionary_auto_backup_location";
    private static final int REQUEST_STORAGE = 0x6b02;
    private static final Map<PreferenceFragment, Controller> CONTROLLERS =
            new WeakHashMap<PreferenceFragment, Controller>();
    private DictionaryAutoBackupSettingsCompat() {}

    public static void bind(PreferenceFragment f) {
        if (f == null || f.getActivity() == null) return;
        synchronized (CONTROLLERS) {
            Controller old = CONTROLLERS.remove(f); if (old != null) old.destroy();
            Controller c = new Controller(f); CONTROLLERS.put(f, c); c.bind();
        }
    }
    public static boolean handleActivityResult(PreferenceFragment f, int r, int c, Intent d) { return false; }
    public static boolean handleRequestPermissionsResult(PreferenceFragment f, int requestCode,
            String[] permissions, int[] results) {
        if (requestCode != REQUEST_STORAGE) return false;
        Controller c; synchronized (CONTROLLERS) { c = CONTROLLERS.get(f); }
        if (c != null) c.onStoragePermissionResult(results);
        return true;
    }
    public static void refresh(PreferenceFragment f) {
        Controller c; synchronized (CONTROLLERS) { c = CONTROLLERS.get(f); }
        if (c != null) c.refresh();
    }
    public static void unbind(PreferenceFragment f) {
        synchronized (CONTROLLERS) { Controller c = CONTROLLERS.remove(f); if (c != null) c.destroy(); }
    }
    static void refreshAll() {
        List<Controller> list; synchronized (CONTROLLERS) { list = new ArrayList<Controller>(CONTROLLERS.values()); }
        for (Controller c : list) c.refresh();
    }

    private static final class Controller implements Preference.OnPreferenceClickListener,
            Preference.OnPreferenceChangeListener {
        PreferenceFragment fragment; TwoStatePreference enabled; Preference location;
        ListPreference interval; ListPreference retention; Preference now; Preference importBackup;
        Controller(PreferenceFragment f) { fragment = f; }
        void bind() {
            enabled = (TwoStatePreference) fragment.findPreference(DictionaryAutoBackupCompat.KEY_ENABLED);
            location = fragment.findPreference(KEY_LOCATION);
            interval = (ListPreference) fragment.findPreference(DictionaryAutoBackupCompat.KEY_INTERVAL);
            retention = (ListPreference) fragment.findPreference(DictionaryAutoBackupCompat.KEY_RETENTION);
            now = fragment.findPreference(DictionaryAutoBackupCompat.KEY_BACKUP_NOW);
            importBackup = fragment.findPreference(DictionaryAutoBackupCompat.KEY_IMPORT_BACKUP);
            if (enabled != null) enabled.setOnPreferenceChangeListener(this);
            if (interval != null) interval.setOnPreferenceChangeListener(this);
            if (retention != null) retention.setOnPreferenceChangeListener(this);
            if (now != null) now.setOnPreferenceClickListener(this);
            if (importBackup != null) importBackup.setOnPreferenceClickListener(this);
            refresh();
        }
        void destroy() { fragment = null; enabled = null; location = null; interval = null;
            retention = null; now = null; importBackup = null; }
        Context context() { return fragment == null || fragment.getActivity() == null ? null
                : fragment.getActivity().getApplicationContext(); }

        @Override public boolean onPreferenceClick(Preference p) {
            Context c = context(); if (c == null) return true;
            if (p == now) DictionaryAutoBackupCompat.request(c, true);
            else if (p == importBackup) openImportList(false);
            return true;
        }
        @Override public boolean onPreferenceChange(Preference p, Object value) {
            Context c = context(); if (c == null) return false;
            SharedPreferences sp = DictionaryAutoBackupCompat.prefs(c);
            if (p == enabled) {
                boolean on = Boolean.TRUE.equals(value);
                sp.edit().putBoolean(DictionaryAutoBackupCompat.KEY_ENABLED, on).apply();
                if (on) DictionaryAutoBackupCompat.request(c, true);
                refreshSoon(); return true;
            }
            if (p == interval) {
                sp.edit().putInt(DictionaryAutoBackupCompat.KEY_INTERVAL, parse(value, 7)).apply();
                refreshSoon(); return true;
            }
            if (p == retention) {
                sp.edit().putInt(DictionaryAutoBackupCompat.KEY_RETENTION, parse(value, 10)).apply();
                refreshSoon(); return true;
            }
            return false;
        }
        void openImportList(boolean permissionRetried) {
            final Context c = context(); if (c == null || fragment == null) return;
            final List<DictionaryAutoBackupCompat.BackupEntry> entries =
                    DictionaryAutoBackupCompat.listBackups(c);
            if (entries.isEmpty() && !permissionRetried && Build.VERSION.SDK_INT >= 23
                    && fragment.getActivity().checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE)
                    != PackageManager.PERMISSION_GRANTED) {
                fragment.requestPermissions(new String[] { Manifest.permission.WRITE_EXTERNAL_STORAGE },
                        REQUEST_STORAGE);
                return;
            }
            if (entries.isEmpty()) {
                new AlertDialog.Builder(fragment.getActivity()).setTitle("没有可访问的本地备份")
                        .setMessage("Documents/GooglePinyinBackup 中没有可列出的备份。卸载重装后也可以在 File Geek 中打开或分享 .txt 到 Google 拼音。")
                        .setPositiveButton(android.R.string.ok, null).show();
                return;
            }
            String[] names = new String[entries.size()];
            for (int i = 0; i < names.length; i++) names[i] = entries.get(i).name;
            new AlertDialog.Builder(fragment.getActivity()).setTitle("导入本地备份")
                    .setItems(names, new DialogInterface.OnClickListener() {
                        @Override public void onClick(DialogInterface dialog, int which) {
                            confirmImport(entries.get(which));
                        }
                    }).setNegativeButton(android.R.string.cancel, null).show();
        }
        void confirmImport(final DictionaryAutoBackupCompat.BackupEntry entry) {
            if (fragment == null || fragment.getActivity() == null) return;
            new AlertDialog.Builder(fragment.getActivity()).setTitle("导入用户词典备份")
                    .setMessage("将“" + entry.name + "”合并到当前用户词典？")
                    .setPositiveButton(android.R.string.ok, new DialogInterface.OnClickListener() {
                        @Override public void onClick(DialogInterface dialog, int which) {
                            LocalBackupImportActivity.startNativeImport(fragment.getActivity(), entry.uri);
                        }
                    }).setNegativeButton(android.R.string.cancel, null).show();
        }
        void onStoragePermissionResult(int[] results) {
            if (results != null && results.length > 0
                    && results[0] == PackageManager.PERMISSION_GRANTED) openImportList(true);
            else { Context c = context(); if (c != null) Toast.makeText(c,
                    "需要文件权限读取卸载前保留的本地备份", Toast.LENGTH_LONG).show(); }
        }
        void refresh() {
            Context c = context(); if (c == null) return;
            SharedPreferences sp = DictionaryAutoBackupCompat.prefs(c);
            boolean supported = Build.VERSION.SDK_INT >= 29;
            boolean on = sp.getBoolean(DictionaryAutoBackupCompat.KEY_ENABLED, false);
            if (enabled != null) {
                enabled.setChecked(on); enabled.setEnabled(supported);
                String status = sp.getString(DictionaryAutoBackupCompat.KEY_LAST_STATUS, null);
                long last = sp.getLong(DictionaryAutoBackupCompat.KEY_LAST_SUCCESS, 0L);
                if (DictionaryAutoBackupCompat.isInProgress()) enabled.setSummary("正在生成本地备份…");
                else if (status != null && !"备份成功".equals(status)) enabled.setSummary(status);
                else if (last > 0L) enabled.setSummary("上次备份："
                        + DateFormat.getDateFormat(c).format(last) + " "
                        + DateFormat.getTimeFormat(c).format(last));
                else enabled.setSummary("备份文件在清除数据或卸载后仍会保留");
            }
            if (location != null) { location.setSummary(DictionaryAutoBackupCompat.DISPLAY_PATH); location.setEnabled(false); }
            if (interval != null) { interval.setValue(Integer.toString(sp.getInt(DictionaryAutoBackupCompat.KEY_INTERVAL, 7))); interval.setEnabled(on && supported); }
            if (retention != null) { retention.setValue(Integer.toString(sp.getInt(DictionaryAutoBackupCompat.KEY_RETENTION, 10))); retention.setEnabled(on && supported); }
            if (now != null) { now.setEnabled(supported && !DictionaryAutoBackupCompat.isInProgress()); now.setSummary("立即导出到固定本地目录"); }
            if (importBackup != null) importBackup.setSummary("列出固定目录中的本地备份；也可从文件管理器打开备份");
        }
        void refreshSoon() { if (fragment != null && fragment.getActivity() != null)
            fragment.getActivity().getWindow().getDecorView().post(new Runnable() {
                @Override public void run() { refresh(); }
            }); }
        static int parse(Object value, int fallback) { try { return Integer.parseInt(String.valueOf(value)); }
            catch (RuntimeException e) { return fallback; } }
    }
}
