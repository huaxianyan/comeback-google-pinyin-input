package com.google.android.inputmethod.pinyin;

import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.provider.MediaStore;
import android.widget.Toast;

import com.google.android.apps.inputmethod.libs.framework.core.TaskListener;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.security.MessageDigest;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/** Local MediaStore backups for manual recovery after clear-data/uninstall. */
public final class DictionaryAutoBackupCompat {
    static final String PREFS = "dictionary_local_backup_preferences";
    static final String KEY_ENABLED = "dictionary_auto_backup_enabled";
    static final String KEY_INTERVAL = "dictionary_auto_backup_interval_days";
    static final String KEY_RETENTION = "dictionary_auto_backup_retention_count";
    static final String KEY_LAST_SUCCESS = "dictionary_auto_backup_last_success_time";
    static final String KEY_LAST_ATTEMPT = "dictionary_auto_backup_last_attempt_time";
    static final String KEY_LAST_STATUS = "dictionary_auto_backup_last_status";
    static final String KEY_LAST_URI = "dictionary_auto_backup_last_document_uri";
    static final String KEY_LAST_SHA256 = "dictionary_auto_backup_last_sha256";
    static final String KEY_FAILURES = "dictionary_auto_backup_consecutive_failures";
    static final String KEY_BACKUP_NOW = "dictionary_auto_backup_now";
    static final String KEY_IMPORT_BACKUP = "dictionary_auto_backup_import";

    static final String RELATIVE_PATH = "Documents/GooglePinyinBackup/";
    static final String DISPLAY_PATH = "内部存储/Documents/GooglePinyinBackup";
    static final String PREFIX = "google-pinyin-user-dictionary-";
    static final String SUFFIX = ".txt";
    private static final long HOUR_MS = 3600000L;
    private static final long DAY_MS = 86400000L;
    private static final Handler MAIN = new Handler(Looper.getMainLooper());
    private static final ExecutorService IO = Executors.newSingleThreadExecutor();
    private static boolean inProgress;

    private DictionaryAutoBackupCompat() {}

    static SharedPreferences prefs(Context c) {
        return c.getApplicationContext().getSharedPreferences(PREFS, Context.MODE_PRIVATE);
    }

    public static boolean isInProgress() {
        synchronized (DictionaryAutoBackupCompat.class) { return inProgress; }
    }

    static Uri collection() {
        return MediaStore.Files.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY);
    }

    public static void request(Context source, boolean force) {
        if (source == null) return;
        final Context context = source.getApplicationContext();
        final SharedPreferences p = prefs(context);
        final long now = System.currentTimeMillis();
        synchronized (DictionaryAutoBackupCompat.class) {
            if (inProgress) {
                if (force) toast(context, "本地词典备份正在进行");
                return;
            }
            if (Build.VERSION.SDK_INT < 29) {
                failIdle(context, force, "固定 Documents 备份需要 Android 10 或更高版本");
                return;
            }
            if (!force && !p.getBoolean(KEY_ENABLED, false)) return;
            if (!force) {
                int days = clamp(p.getInt(KEY_INTERVAL, 7), 1, 365, 7);
                long last = p.getLong(KEY_LAST_SUCCESS, 0L);
                if (last > 0L && now >= last && now - last < days * DAY_MS) return;
                long attempt = p.getLong(KEY_LAST_ATTEMPT, 0L);
                if (p.getInt(KEY_FAILURES, 0) > 0 && attempt > 0L && now >= attempt
                        && now - attempt < HOUR_MS) return;
            }
            inProgress = true;
            p.edit().putLong(KEY_LAST_ATTEMPT, now).putString(KEY_LAST_STATUS, "正在备份").apply();
        }
        DictionaryAutoBackupSettingsCompat.refreshAll();
        IO.execute(new Runnable() { @Override public void run() { createAndExport(context, force); } });
    }

    private static void createAndExport(final Context context, final boolean force) {
        Uri uri = null;
        try {
            cleanupPending(context);
            final String name = PREFIX + new SimpleDateFormat("yyyy-MM-dd_HH-mm-ss-SSS", Locale.US)
                    .format(new Date()) + SUFFIX;
            ContentValues values = new ContentValues();
            values.put(MediaStore.MediaColumns.DISPLAY_NAME, name);
            values.put(MediaStore.MediaColumns.MIME_TYPE, "text/plain");
            values.put(MediaStore.MediaColumns.RELATIVE_PATH, RELATIVE_PATH);
            values.put(MediaStore.MediaColumns.IS_PENDING, 1);
            uri = context.getContentResolver().insert(collection(), values);
            if (uri == null) throw new IllegalStateException("MediaStore insert returned null");
            final Uri output = uri;
            MAIN.post(new Runnable() { @Override public void run() {
                enqueueNativeExport(context, output, name, force);
            }});
        } catch (Throwable t) {
            if (uri != null) delete(context, uri);
            finishFailure(context, force, "无法在 Documents 创建本地备份");
        }
    }

    private static void enqueueNativeExport(Context context, Uri output, String name, boolean force) {
        try {
            Class<?> managerClass = Class.forName("aib");
            Object manager = managerClass.getMethod("a").invoke(null);
            Class<?> factoryType = Class.forName(
                    "com.google.android.apps.inputmethod.libs.framework.core.TaskFactory");
            Constructor<?> ctor = Class.forName("beg").getConstructor(Context.class,
                    TaskListener.class, Uri.class);
            Object factory = ctor.newInstance(context,
                    new ExportListener(context, output, name, force), output);
            Method schedule = managerClass.getMethod("a", String.class, factoryType, Long.TYPE);
            schedule.invoke(manager, "user_dict_auto_backup", factory, 0L);
        } catch (Throwable t) {
            delete(context, output);
            finishFailure(context, force, "无法启动原生用户词典导出");
        }
    }

    private static final class ExportListener implements TaskListener {
        final Context context; final Uri uri; final String name; final boolean force;
        ExportListener(Context c, Uri u, String n, boolean f) {
            context = c.getApplicationContext(); uri = u; name = n; force = f;
        }
        @Override public void onTaskStart() {}
        @Override public void onTaskProgress(int p) {}
        @Override public void onTaskError(int e) {}
        @Override public void onTaskFinished(final boolean success, Object result) {
            IO.execute(new Runnable() { @Override public void run() {
                if (!success) { delete(context, uri); finishFailure(context, force, "原生用户词典导出失败"); }
                else publish(context, uri, force);
            }});
        }
    }

    private static void publish(Context context, Uri uri, boolean force) {
        try {
            String hash = validateAndHash(context, uri);
            ContentValues values = new ContentValues();
            values.put(MediaStore.MediaColumns.IS_PENDING, 0);
            if (context.getContentResolver().update(uri, values, null, null) <= 0)
                throw new IllegalStateException("MediaStore publish failed");
            SharedPreferences p = prefs(context);
            p.edit().putLong(KEY_LAST_SUCCESS, System.currentTimeMillis())
                    .putString(KEY_LAST_STATUS, "备份成功")
                    .putString(KEY_LAST_URI, uri.toString()).putString(KEY_LAST_SHA256, hash)
                    .putInt(KEY_FAILURES, 0).apply();
            boolean rotated = rotate(context, clamp(p.getInt(KEY_RETENTION, 10), 1, 100, 10));
            if (!rotated) p.edit().putString(KEY_LAST_STATUS, "备份成功，但旧版本清理失败").apply();
            finishSuccess(context, force);
        } catch (Throwable t) {
            delete(context, uri);
            finishFailure(context, force, "本地备份校验或发布失败");
        }
    }

    private static String validateAndHash(Context context, Uri uri) throws Exception {
        InputStream in = null; ByteArrayOutputStream out = new ByteArrayOutputStream();
        try {
            in = context.getContentResolver().openInputStream(uri);
            if (in == null) throw new IllegalStateException("null input");
            byte[] buffer = new byte[8192]; int count;
            while ((count = in.read(buffer)) != -1) out.write(buffer, 0, count);
        } finally { if (in != null) in.close(); }
        byte[] data = out.toByteArray();
        byte[] header = ("\ufeff# User dictionary for Google Pinyin Input\n").getBytes("UTF-16LE");
        if (data.length < header.length) throw new IllegalStateException("short backup");
        for (int i = 0; i < header.length; i++) if (data[i] != header[i])
            throw new IllegalStateException("bad header");
        byte[] hash = MessageDigest.getInstance("SHA-256").digest(data);
        StringBuilder text = new StringBuilder();
        for (byte b : hash) text.append(String.format(Locale.US, "%02x", b & 255));
        return text.toString();
    }

    static List<BackupEntry> listBackups(Context context) {
        List<BackupEntry> result = new ArrayList<BackupEntry>(); Cursor c = null;
        try {
            String[] projection = { MediaStore.MediaColumns._ID, MediaStore.MediaColumns.DISPLAY_NAME };
            String selection = MediaStore.MediaColumns.RELATIVE_PATH + "=? AND "
                    + MediaStore.MediaColumns.IS_PENDING + "=0";
            c = context.getContentResolver().query(collection(), projection, selection,
                    new String[] { RELATIVE_PATH }, MediaStore.MediaColumns.DISPLAY_NAME + " DESC");
            if (c != null) while (c.moveToNext()) {
                String name = c.getString(1);
                if (name != null && name.startsWith(PREFIX) && name.endsWith(SUFFIX))
                    result.add(new BackupEntry(name, Uri.withAppendedPath(collection(), c.getString(0))));
            }
        } catch (Throwable ignored) {} finally { if (c != null) c.close(); }
        return result;
    }

    static final class BackupEntry {
        final String name; final Uri uri;
        BackupEntry(String n, Uri u) { name = n; uri = u; }
    }

    private static boolean rotate(Context context, int keep) {
        try {
            List<BackupEntry> list = listBackups(context);
            Collections.sort(list, new Comparator<BackupEntry>() {
                @Override public int compare(BackupEntry a, BackupEntry b) { return b.name.compareTo(a.name); }
            });
            boolean ok = true;
            for (int i = keep; i < list.size(); i++) if (!delete(context, list.get(i).uri)) ok = false;
            return ok;
        } catch (Throwable t) { return false; }
    }

    private static void cleanupPending(Context context) {
        Cursor c = null;
        try {
            String[] projection = { MediaStore.MediaColumns._ID };
            String selection = MediaStore.MediaColumns.RELATIVE_PATH + "=? AND "
                    + MediaStore.MediaColumns.IS_PENDING + "=1";
            c = context.getContentResolver().query(collection(), projection, selection,
                    new String[] { RELATIVE_PATH }, null);
            if (c != null) while (c.moveToNext()) delete(context,
                    Uri.withAppendedPath(collection(), c.getString(0)));
        } catch (Throwable ignored) {} finally { if (c != null) c.close(); }
    }

    private static boolean delete(Context context, Uri uri) {
        try { return context.getContentResolver().delete(uri, null, null) > 0; }
        catch (Throwable ignored) { return false; }
    }

    private static void failIdle(Context c, boolean force, String message) {
        SharedPreferences p = prefs(c);
        p.edit().putString(KEY_LAST_STATUS, message)
                .putInt(KEY_FAILURES, p.getInt(KEY_FAILURES, 0) + 1).apply();
        if (force) toast(c, message);
        DictionaryAutoBackupSettingsCompat.refreshAll();
    }

    private static void finishSuccess(final Context c, final boolean force) {
        synchronized (DictionaryAutoBackupCompat.class) { inProgress = false; }
        MAIN.post(new Runnable() { @Override public void run() {
            DictionaryAutoBackupSettingsCompat.refreshAll();
            if (force) toast(c, "本地用户词典备份成功");
        }});
    }

    private static void finishFailure(final Context c, final boolean force, final String message) {
        SharedPreferences p = prefs(c);
        p.edit().putString(KEY_LAST_STATUS, message)
                .putInt(KEY_FAILURES, p.getInt(KEY_FAILURES, 0) + 1).apply();
        synchronized (DictionaryAutoBackupCompat.class) { inProgress = false; }
        MAIN.post(new Runnable() { @Override public void run() {
            DictionaryAutoBackupSettingsCompat.refreshAll(); if (force) toast(c, message);
        }});
    }

    private static void toast(final Context c, final String text) {
        if (Looper.myLooper() == Looper.getMainLooper()) Toast.makeText(c, text, Toast.LENGTH_SHORT).show();
        else MAIN.post(new Runnable() { @Override public void run() {
            Toast.makeText(c, text, Toast.LENGTH_SHORT).show();
        }});
    }

    private static int clamp(int value, int min, int max, int fallback) {
        return value < min || value > max ? fallback : value;
    }
}
