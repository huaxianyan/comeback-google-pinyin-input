package com.google.android.inputmethod.pinyin;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.widget.Toast;

import com.google.android.apps.inputmethod.libs.framework.core.TaskListener;

import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.util.List;

/** Explicit manual import entry for fixed-path backups and file-manager VIEW/SEND. */
public final class LocalBackupImportActivity extends Activity {
    @Override protected void onCreate(Bundle state) {
        super.onCreate(state);
        Uri incoming = incomingUri(getIntent());
        if (incoming != null) confirm(incoming, "所选本地备份");
        else showBackups();
    }

    private Uri incomingUri(Intent intent) {
        if (intent == null) return null;
        if (Intent.ACTION_VIEW.equals(intent.getAction())) return intent.getData();
        if (Intent.ACTION_SEND.equals(intent.getAction())) {
            Object value = intent.getParcelableExtra(Intent.EXTRA_STREAM);
            return value instanceof Uri ? (Uri) value : null;
        }
        return null;
    }

    private void showBackups() {
        final List<DictionaryAutoBackupCompat.BackupEntry> entries =
                DictionaryAutoBackupCompat.listBackups(this);
        if (entries.isEmpty()) {
            new AlertDialog.Builder(this).setTitle("没有可访问的本地备份")
                    .setMessage("固定目录中没有当前安装可列出的备份。卸载重装后，可在文件管理器中打开 Documents/GooglePinyinBackup 下的 .txt，并选择 Google 拼音导入。")
                    .setPositiveButton(android.R.string.ok, new DialogInterface.OnClickListener() {
                        @Override public void onClick(DialogInterface d, int w) { finish(); }
                    }).setOnCancelListener(new DialogInterface.OnCancelListener() {
                        @Override public void onCancel(DialogInterface d) { finish(); }
                    }).show();
            return;
        }
        String[] names = new String[entries.size()];
        for (int i = 0; i < names.length; i++) names[i] = entries.get(i).name;
        new AlertDialog.Builder(this).setTitle("导入本地备份")
                .setItems(names, new DialogInterface.OnClickListener() {
                    @Override public void onClick(DialogInterface d, int which) {
                        confirm(entries.get(which).uri, entries.get(which).name);
                    }
                }).setNegativeButton(android.R.string.cancel, new DialogInterface.OnClickListener() {
                    @Override public void onClick(DialogInterface d, int w) { finish(); }
                }).setOnCancelListener(new DialogInterface.OnCancelListener() {
                    @Override public void onCancel(DialogInterface d) { finish(); }
                }).show();
    }

    private void confirm(final Uri uri, String name) {
        new AlertDialog.Builder(this).setTitle("导入用户词典备份")
                .setMessage("将“" + name + "”合并到当前用户词典？")
                .setPositiveButton(android.R.string.ok, new DialogInterface.OnClickListener() {
                    @Override public void onClick(DialogInterface d, int w) { startImport(uri); }
                }).setNegativeButton(android.R.string.cancel, new DialogInterface.OnClickListener() {
                    @Override public void onClick(DialogInterface d, int w) { finish(); }
                }).setOnCancelListener(new DialogInterface.OnCancelListener() {
                    @Override public void onCancel(DialogInterface d) { finish(); }
                }).show();
    }

    private void startImport(Uri uri) {
        final Context app = getApplicationContext();
        try {
            Class<?> managerClass = Class.forName("aib");
            Object manager = managerClass.getMethod("a").invoke(null);
            Class<?> factoryType = Class.forName(
                    "com.google.android.apps.inputmethod.libs.framework.core.TaskFactory");
            Constructor<?> ctor = Class.forName("beh").getConstructor(Context.class,
                    TaskListener.class, Uri.class);
            Object factory = ctor.newInstance(app, new ImportListener(app), uri);
            Method schedule = managerClass.getMethod("a", String.class, factoryType, Long.TYPE);
            schedule.invoke(manager, "user_dict_import", factory, 0L);
            Toast.makeText(app, "正在导入本地用户词典备份", Toast.LENGTH_SHORT).show();
        } catch (Throwable t) {
            Toast.makeText(app, "无法启动原生用户词典导入", Toast.LENGTH_LONG).show();
        }
        finish();
    }

    private static final class ImportListener implements TaskListener {
        final Context context;
        ImportListener(Context c) { context = c; }
        @Override public void onTaskStart() {}
        @Override public void onTaskProgress(int p) {}
        @Override public void onTaskError(int e) {}
        @Override public void onTaskFinished(boolean success, Object result) {
            Toast.makeText(context, success ? "本地用户词典备份导入成功" : "本地用户词典备份导入失败",
                    Toast.LENGTH_LONG).show();
        }
    }
}
