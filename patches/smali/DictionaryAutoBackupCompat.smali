.class public final Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupCompat.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;,
        Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;
    }
.end annotation


# static fields
.field private static final DAY_MS:J = 0x5265c00L

.field static final DISPLAY_PATH:Ljava/lang/String; = "\u5185\u90e8\u5b58\u50a8/Documents/GooglePinyinBackup"

.field private static final HOUR_MS:J = 0x36ee80L

.field private static final IO:Ljava/util/concurrent/ExecutorService;

.field static final KEY_BACKUP_NOW:Ljava/lang/String; = "dictionary_auto_backup_now"

.field static final KEY_ENABLED:Ljava/lang/String; = "dictionary_auto_backup_enabled"

.field static final KEY_FAILURES:Ljava/lang/String; = "dictionary_auto_backup_consecutive_failures"

.field static final KEY_IMPORT_BACKUP:Ljava/lang/String; = "dictionary_auto_backup_import"

.field static final KEY_INTERVAL:Ljava/lang/String; = "dictionary_auto_backup_interval_days"

.field static final KEY_LAST_ATTEMPT:Ljava/lang/String; = "dictionary_auto_backup_last_attempt_time"

.field static final KEY_LAST_SHA256:Ljava/lang/String; = "dictionary_auto_backup_last_sha256"

.field static final KEY_LAST_STATUS:Ljava/lang/String; = "dictionary_auto_backup_last_status"

.field static final KEY_LAST_SUCCESS:Ljava/lang/String; = "dictionary_auto_backup_last_success_time"

.field static final KEY_LAST_URI:Ljava/lang/String; = "dictionary_auto_backup_last_document_uri"

.field static final KEY_RETENTION:Ljava/lang/String; = "dictionary_auto_backup_retention_count"

.field private static final MAIN:Landroid/os/Handler;

.field static final PREFIX:Ljava/lang/String; = "google-pinyin-user-dictionary-"

.field static final PREFS:Ljava/lang/String; = "dictionary_local_backup_preferences"

.field static final RELATIVE_PATH:Ljava/lang/String; = "Documents/GooglePinyinBackup/"

.field static final SUFFIX:Ljava/lang/String; = ".txt"

.field private static inProgress:Z


# direct methods
.method static constructor <clinit>()V
    .registers 2

    .line 53
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->MAIN:Landroid/os/Handler;

    .line 54
    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->IO:Ljava/util/concurrent/ExecutorService;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 57
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(Landroid/content/Context;Z)V
    .registers 2

    .line 33
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->createAndExport(Landroid/content/Context;Z)V

    return-void
.end method

.method static synthetic access$100(Landroid/content/Context;Landroid/net/Uri;Ljava/lang/String;Z)V
    .registers 4

    .line 33
    invoke-static {p0, p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->enqueueNativeExport(Landroid/content/Context;Landroid/net/Uri;Ljava/lang/String;Z)V

    return-void
.end method

.method static synthetic access$200(Landroid/content/Context;Landroid/net/Uri;)Z
    .registers 2

    .line 33
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->delete(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result p0

    return p0
.end method

.method static synthetic access$300(Landroid/content/Context;ZLjava/lang/String;)V
    .registers 3

    .line 33
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishFailure(Landroid/content/Context;ZLjava/lang/String;)V

    return-void
.end method

.method static synthetic access$400(Landroid/content/Context;Landroid/net/Uri;Z)V
    .registers 3

    .line 33
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->publish(Landroid/content/Context;Landroid/net/Uri;Z)V

    return-void
.end method

.method static synthetic access$500()Ljava/util/concurrent/ExecutorService;
    .registers 1

    .line 33
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->IO:Ljava/util/concurrent/ExecutorService;

    return-object v0
.end method

.method static synthetic access$600(Landroid/content/Context;Ljava/lang/String;)V
    .registers 2

    .line 33
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method

.method private static clamp(IIII)I
    .registers 4

    .line 284
    if-lt p0, p1, :cond_4

    if-le p0, p2, :cond_5

    :cond_4
    move p0, p3

    :cond_5
    return p0
.end method

.method private static cleanupPending(Landroid/content/Context;)V
    .registers 10

    .line 233
    nop

    .line 235
    const/4 v1, 0x0

    const/4 v0, 0x1

    :try_start_3
    new-array v4, v0, [Ljava/lang/String;

    const-string v2, "_id"

    const/4 v8, 0x0

    aput-object v2, v4, v8

    .line 236
    const-string v5, "relative_path=? AND is_pending=1"

    .line 238
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->collection()Landroid/net/Uri;

    move-result-object v3

    new-array v6, v0, [Ljava/lang/String;

    const-string v0, "Documents/GooglePinyinBackup/"

    aput-object v0, v6, v8

    const/4 v7, 0x0

    invoke-virtual/range {v2 .. v7}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v1

    .line 240
    if-eqz v1, :cond_37

    :goto_21
    invoke-interface {v1}, Landroid/database/Cursor;->moveToNext()Z

    move-result v0

    if-eqz v0, :cond_37

    .line 241
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->collection()Landroid/net/Uri;

    move-result-object v0

    invoke-interface {v1, v8}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Landroid/net/Uri;->withAppendedPath(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    .line 240
    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->delete(Landroid/content/Context;Landroid/net/Uri;)Z
    :try_end_36
    .catchall {:try_start_3 .. :try_end_36} :catchall_3a

    goto :goto_21

    .line 242
    :cond_37
    if-eqz v1, :cond_40

    goto :goto_3d

    :catchall_3a
    move-exception v0

    if-eqz v1, :cond_40

    :goto_3d
    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 243
    :cond_40
    return-void
.end method

.method static collection()Landroid/net/Uri;
    .registers 1

    .line 68
    const-string v0, "external_primary"

    invoke-static {v0}, Landroid/provider/MediaStore$Files;->getContentUri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    return-object v0
.end method

.method private static createAndExport(Landroid/content/Context;Z)V
    .registers 7

    .line 102
    nop

    .line 104
    const/4 v0, 0x0

    :try_start_2
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->cleanupPending(Landroid/content/Context;)V

    .line 105
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "google-pinyin-user-dictionary-"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    new-instance v2, Ljava/text/SimpleDateFormat;

    const-string v3, "yyyy-MM-dd_HH-mm-ss-SSS"

    sget-object v4, Ljava/util/Locale;->US:Ljava/util/Locale;

    invoke-direct {v2, v3, v4}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    new-instance v3, Ljava/util/Date;

    invoke-direct {v3}, Ljava/util/Date;-><init>()V

    .line 106
    invoke-virtual {v2, v3}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, ".txt"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 107
    new-instance v2, Landroid/content/ContentValues;

    invoke-direct {v2}, Landroid/content/ContentValues;-><init>()V

    .line 108
    const-string v3, "_display_name"

    invoke-virtual {v2, v3, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 109
    const-string v3, "mime_type"

    const-string v4, "text/plain"

    invoke-virtual {v2, v3, v4}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 110
    const-string v3, "relative_path"

    const-string v4, "Documents/GooglePinyinBackup/"

    invoke-virtual {v2, v3, v4}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 111
    const-string v3, "is_pending"

    const/4 v4, 0x1

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-virtual {v2, v3, v4}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 112
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v3

    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->collection()Landroid/net/Uri;

    move-result-object v4

    invoke-virtual {v3, v4, v2}, Landroid/content/ContentResolver;->insert(Landroid/net/Uri;Landroid/content/ContentValues;)Landroid/net/Uri;

    move-result-object v0

    .line 113
    if-eqz v0, :cond_6c

    .line 114
    nop

    .line 115
    sget-object v2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->MAIN:Landroid/os/Handler;

    new-instance v3, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;

    invoke-direct {v3, p0, v0, v1, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;-><init>(Landroid/content/Context;Landroid/net/Uri;Ljava/lang/String;Z)V

    invoke-virtual {v2, v3}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 121
    goto :goto_7f

    .line 113
    :cond_6c
    new-instance v1, Ljava/lang/IllegalStateException;

    const-string v2, "MediaStore insert returned null"

    invoke-direct {v1, v2}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v1
    :try_end_74
    .catchall {:try_start_2 .. :try_end_74} :catchall_74

    .line 118
    :catchall_74
    move-exception v1

    .line 119
    if-eqz v0, :cond_7a

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->delete(Landroid/content/Context;Landroid/net/Uri;)Z

    .line 120
    :cond_7a
    const-string v0, "\u65e0\u6cd5\u5728 Documents \u521b\u5efa\u672c\u5730\u5907\u4efd"

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishFailure(Landroid/content/Context;ZLjava/lang/String;)V

    .line 122
    :goto_7f
    return-void
.end method

.method private static delete(Landroid/content/Context;Landroid/net/Uri;)Z
    .registers 4

    .line 246
    const/4 v0, 0x0

    :try_start_1
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    const/4 v1, 0x0

    invoke-virtual {p0, p1, v1, v1}, Landroid/content/ContentResolver;->delete(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)I

    move-result p0
    :try_end_a
    .catchall {:try_start_1 .. :try_end_a} :catchall_e

    if-lez p0, :cond_d

    const/4 v0, 0x1

    :cond_d
    return v0

    .line 247
    :catchall_e
    move-exception p0

    return v0
.end method

.method private static enqueueNativeExport(Landroid/content/Context;Landroid/net/Uri;Ljava/lang/String;Z)V
    .registers 15

    .line 126
    const-string v0, "a"

    :try_start_2
    const-string v1, "aib"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    .line 127
    const/4 v2, 0x0

    new-array v3, v2, [Ljava/lang/Class;

    invoke-virtual {v1, v0, v3}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v3

    new-array v4, v2, [Ljava/lang/Object;

    const/4 v5, 0x0

    invoke-virtual {v3, v5, v4}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    .line 128
    const-string v4, "com.google.android.apps.inputmethod.libs.framework.core.TaskFactory"

    invoke-static {v4}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v4

    .line 130
    const-string v5, "beg"

    invoke-static {v5}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v5

    const/4 v6, 0x3

    new-array v7, v6, [Ljava/lang/Class;

    const-class v8, Landroid/content/Context;

    aput-object v8, v7, v2

    const-class v8, Lcom/google/android/apps/inputmethod/libs/framework/core/TaskListener;

    const/4 v9, 0x1

    aput-object v8, v7, v9

    const-class v8, Landroid/net/Uri;

    const/4 v10, 0x2

    aput-object v8, v7, v10

    invoke-virtual {v5, v7}, Ljava/lang/Class;->getConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v5

    .line 132
    new-instance v7, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    invoke-direct {v7, p0, p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;-><init>(Landroid/content/Context;Landroid/net/Uri;Ljava/lang/String;Z)V

    new-array p2, v6, [Ljava/lang/Object;

    aput-object p0, p2, v2

    aput-object v7, p2, v9

    aput-object p1, p2, v10

    invoke-virtual {v5, p2}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p2

    .line 134
    new-array v5, v6, [Ljava/lang/Class;

    const-class v7, Ljava/lang/String;

    aput-object v7, v5, v2

    aput-object v4, v5, v9

    sget-object v4, Ljava/lang/Long;->TYPE:Ljava/lang/Class;

    aput-object v4, v5, v10

    invoke-virtual {v1, v0, v5}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    .line 135
    const-wide/16 v4, 0x0

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    new-array v4, v6, [Ljava/lang/Object;

    const-string v5, "user_dict_auto_backup"

    aput-object v5, v4, v2

    aput-object p2, v4, v9

    aput-object v1, v4, v10

    invoke-virtual {v0, v3, v4}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_6b
    .catchall {:try_start_2 .. :try_end_6b} :catchall_6c

    .line 139
    goto :goto_75

    .line 136
    :catchall_6c
    move-exception p2

    .line 137
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->delete(Landroid/content/Context;Landroid/net/Uri;)Z

    .line 138
    const-string p1, "\u65e0\u6cd5\u542f\u52a8\u539f\u751f\u7528\u6237\u8bcd\u5178\u5bfc\u51fa"

    invoke-static {p0, p3, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishFailure(Landroid/content/Context;ZLjava/lang/String;)V

    .line 140
    :goto_75
    return-void
.end method

.method private static failIdle(Landroid/content/Context;ZLjava/lang/String;)V
    .registers 7

    .line 251
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 252
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v2, "dictionary_auto_backup_last_status"

    invoke-interface {v1, v2, p2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 253
    const-string v2, "dictionary_auto_backup_consecutive_failures"

    const/4 v3, 0x0

    invoke-interface {v0, v2, v3}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    add-int/lit8 v0, v0, 0x1

    invoke-interface {v1, v2, v0}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 254
    if-eqz p1, :cond_23

    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->toast(Landroid/content/Context;Ljava/lang/String;)V

    .line 255
    :cond_23
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->refreshAll()V

    .line 256
    return-void
.end method

.method private static finishFailure(Landroid/content/Context;ZLjava/lang/String;)V
    .registers 8

    .line 267
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 268
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v2, "dictionary_auto_backup_last_status"

    invoke-interface {v1, v2, p2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v2, "dictionary_auto_backup_consecutive_failures"

    const-string v3, "dictionary_auto_backup_consecutive_failures"

    .line 269
    const/4 v4, 0x0

    invoke-interface {v0, v3, v4}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    add-int/lit8 v0, v0, 0x1

    invoke-interface {v1, v2, v0}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 270
    const-class v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;

    monitor-enter v0

    :try_start_23
    sput-boolean v4, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->inProgress:Z

    monitor-exit v0
    :try_end_26
    .catchall {:try_start_23 .. :try_end_26} :catchall_31

    .line 271
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->MAIN:Landroid/os/Handler;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$5;

    invoke-direct {v1, p1, p0, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$5;-><init>(ZLandroid/content/Context;Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 274
    return-void

    .line 270
    :catchall_31
    move-exception p0

    :try_start_32
    monitor-exit v0
    :try_end_33
    .catchall {:try_start_32 .. :try_end_33} :catchall_31

    throw p0
.end method

.method private static finishSuccess(Landroid/content/Context;Z)V
    .registers 4

    .line 259
    const-class v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;

    monitor-enter v0

    const/4 v1, 0x0

    :try_start_4
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->inProgress:Z

    monitor-exit v0
    :try_end_7
    .catchall {:try_start_4 .. :try_end_7} :catchall_12

    .line 260
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->MAIN:Landroid/os/Handler;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4;

    invoke-direct {v1, p1, p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4;-><init>(ZLandroid/content/Context;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 264
    return-void

    .line 259
    :catchall_12
    move-exception p0

    :try_start_13
    monitor-exit v0
    :try_end_14
    .catchall {:try_start_13 .. :try_end_14} :catchall_12

    throw p0
.end method

.method public static isInProgress()Z
    .registers 2

    .line 64
    const-class v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;

    monitor-enter v0

    :try_start_3
    sget-boolean v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->inProgress:Z

    monitor-exit v0

    return v1

    :catchall_7
    move-exception v1

    monitor-exit v0
    :try_end_9
    .catchall {:try_start_3 .. :try_end_9} :catchall_7

    throw v1
.end method

.method static listBackups(Landroid/content/Context;)Ljava/util/List;
    .registers 12
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            ")",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;",
            ">;"
        }
    .end annotation

    .line 199
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 201
    const/4 v2, 0x0

    const/4 v0, 0x2

    :try_start_7
    new-array v5, v0, [Ljava/lang/String;

    const-string v0, "_id"

    const/4 v9, 0x0

    aput-object v0, v5, v9

    const-string v0, "_display_name"

    const/4 v10, 0x1

    aput-object v0, v5, v10

    .line 202
    const-string v6, "relative_path=? AND is_pending=0"

    .line 204
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v3

    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->collection()Landroid/net/Uri;

    move-result-object v4

    new-array v7, v10, [Ljava/lang/String;

    const-string p0, "Documents/GooglePinyinBackup/"

    aput-object p0, v7, v9

    const-string v8, "_display_name DESC"

    invoke-virtual/range {v3 .. v8}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v2

    .line 206
    if-eqz v2, :cond_5c

    :goto_2b
    invoke-interface {v2}, Landroid/database/Cursor;->moveToNext()Z

    move-result p0

    if-eqz p0, :cond_5c

    .line 207
    invoke-interface {v2, v10}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object p0

    .line 208
    if-eqz p0, :cond_5b

    const-string v0, "google-pinyin-user-dictionary-"

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_5b

    const-string v0, ".txt"

    invoke-virtual {p0, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_5b

    .line 209
    new-instance v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;

    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->collection()Landroid/net/Uri;

    move-result-object v3

    invoke-interface {v2, v9}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v4

    invoke-static {v3, v4}, Landroid/net/Uri;->withAppendedPath(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v3

    invoke-direct {v0, p0, v3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    invoke-interface {v1, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_5b
    .catchall {:try_start_7 .. :try_end_5b} :catchall_5f

    .line 210
    :cond_5b
    goto :goto_2b

    .line 211
    :cond_5c
    if-eqz v2, :cond_65

    goto :goto_62

    :catchall_5f
    move-exception v0

    if-eqz v2, :cond_65

    :goto_62
    invoke-interface {v2}, Landroid/database/Cursor;->close()V

    .line 212
    :cond_65
    return-object v1
.end method

.method static prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .registers 3

    .line 60
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "dictionary_local_backup_preferences"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

.method private static publish(Landroid/content/Context;Landroid/net/Uri;Z)V
    .registers 11

    .line 160
    const-string v0, "dictionary_auto_backup_last_status"

    :try_start_2
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->validateAndHash(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;

    move-result-object v1

    .line 161
    new-instance v2, Landroid/content/ContentValues;

    invoke-direct {v2}, Landroid/content/ContentValues;-><init>()V

    .line 162
    const-string v3, "is_pending"

    const/4 v4, 0x0

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-virtual {v2, v3, v5}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 163
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v3

    const/4 v5, 0x0

    invoke-virtual {v3, p1, v2, v5, v5}, Landroid/content/ContentResolver;->update(Landroid/net/Uri;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I

    move-result v2

    if-lez v2, :cond_77

    .line 165
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v2

    .line 166
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    const-string v5, "dictionary_auto_backup_last_success_time"

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v6

    invoke-interface {v3, v5, v6, v7}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    const-string v5, "\u5907\u4efd\u6210\u529f"

    .line 167
    invoke-interface {v3, v0, v5}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    const-string v5, "dictionary_auto_backup_last_document_uri"

    .line 168
    invoke-virtual {p1}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-interface {v3, v5, v6}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    const-string v5, "dictionary_auto_backup_last_sha256"

    invoke-interface {v3, v5, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v3, "dictionary_auto_backup_consecutive_failures"

    .line 169
    invoke-interface {v1, v3, v4}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 170
    const-string v1, "dictionary_auto_backup_retention_count"

    const/16 v3, 0xa

    invoke-interface {v2, v1, v3}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v1

    const/4 v4, 0x1

    const/16 v5, 0x64

    invoke-static {v1, v4, v5, v3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->clamp(IIII)I

    move-result v1

    invoke-static {p0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->rotate(Landroid/content/Context;I)Z

    move-result v1

    .line 171
    if-nez v1, :cond_73

    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v2, "\u5907\u4efd\u6210\u529f\uff0c\u4f46\u65e7\u7248\u672c\u6e05\u7406\u5931\u8d25"

    invoke-interface {v1, v0, v2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 172
    :cond_73
    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishSuccess(Landroid/content/Context;Z)V

    .line 176
    goto :goto_88

    .line 164
    :cond_77
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "MediaStore publish failed"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0
    :try_end_7f
    .catchall {:try_start_2 .. :try_end_7f} :catchall_7f

    .line 173
    :catchall_7f
    move-exception v0

    .line 174
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->delete(Landroid/content/Context;Landroid/net/Uri;)Z

    .line 175
    const-string p1, "\u672c\u5730\u5907\u4efd\u6821\u9a8c\u6216\u53d1\u5e03\u5931\u8d25"

    invoke-static {p0, p2, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishFailure(Landroid/content/Context;ZLjava/lang/String;)V

    .line 177
    :goto_88
    return-void
.end method

.method public static request(Landroid/content/Context;Z)V
    .registers 16

    .line 72
    if-nez p0, :cond_3

    return-void

    .line 73
    :cond_3
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    .line 74
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 75
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    .line 76
    const-class v3, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;

    monitor-enter v3

    .line 77
    :try_start_12
    sget-boolean v4, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->inProgress:Z

    if-eqz v4, :cond_1f

    .line 78
    if-eqz p1, :cond_1d

    const-string p1, "\u672c\u5730\u8bcd\u5178\u5907\u4efd\u6b63\u5728\u8fdb\u884c"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->toast(Landroid/content/Context;Ljava/lang/String;)V

    .line 79
    :cond_1d
    monitor-exit v3

    return-void

    .line 81
    :cond_1f
    sget v4, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v5, 0x1d

    if-ge v4, v5, :cond_2c

    .line 82
    const-string v0, "\u56fa\u5b9a Documents \u5907\u4efd\u9700\u8981 Android 10 \u6216\u66f4\u9ad8\u7248\u672c"

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->failIdle(Landroid/content/Context;ZLjava/lang/String;)V

    .line 83
    monitor-exit v3

    return-void

    .line 85
    :cond_2c
    const/4 v4, 0x0

    if-nez p1, :cond_39

    const-string v5, "dictionary_auto_backup_enabled"

    invoke-interface {v0, v5, v4}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v5

    if-nez v5, :cond_39

    monitor-exit v3

    return-void

    .line 86
    :cond_39
    const/4 v5, 0x1

    if-nez p1, :cond_88

    .line 87
    const-string v6, "dictionary_auto_backup_interval_days"

    const/4 v7, 0x7

    invoke-interface {v0, v6, v7}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v6

    const/16 v8, 0x16d

    invoke-static {v6, v5, v8, v7}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->clamp(IIII)I

    move-result v6

    .line 88
    const-string v7, "dictionary_auto_backup_last_success_time"

    const-wide/16 v8, 0x0

    invoke-interface {v0, v7, v8, v9}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v10

    .line 89
    cmp-long v7, v10, v8

    if-lez v7, :cond_67

    cmp-long v7, v1, v10

    if-ltz v7, :cond_67

    sub-long v10, v1, v10

    int-to-long v6, v6

    const-wide/32 v12, 0x5265c00

    mul-long v6, v6, v12

    cmp-long v12, v10, v6

    if-gez v12, :cond_67

    monitor-exit v3

    return-void

    .line 90
    :cond_67
    const-string v6, "dictionary_auto_backup_last_attempt_time"

    invoke-interface {v0, v6, v8, v9}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v6

    .line 91
    const-string v10, "dictionary_auto_backup_consecutive_failures"

    invoke-interface {v0, v10, v4}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v4

    if-lez v4, :cond_88

    cmp-long v4, v6, v8

    if-lez v4, :cond_88

    cmp-long v4, v1, v6

    if-ltz v4, :cond_88

    sub-long v6, v1, v6

    const-wide/32 v8, 0x36ee80

    cmp-long v4, v6, v8

    if-gez v4, :cond_88

    .line 92
    monitor-exit v3

    return-void

    .line 94
    :cond_88
    sput-boolean v5, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->inProgress:Z

    .line 95
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v4, "dictionary_auto_backup_last_attempt_time"

    invoke-interface {v0, v4, v1, v2}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "dictionary_auto_backup_last_status"

    const-string v2, "\u6b63\u5728\u5907\u4efd"

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 96
    monitor-exit v3
    :try_end_a0
    .catchall {:try_start_12 .. :try_end_a0} :catchall_ae

    .line 97
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->refreshAll()V

    .line 98
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->IO:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$1;

    invoke-direct {v1, p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$1;-><init>(Landroid/content/Context;Z)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 99
    return-void

    .line 96
    :catchall_ae
    move-exception p0

    :try_start_af
    monitor-exit v3
    :try_end_b0
    .catchall {:try_start_af .. :try_end_b0} :catchall_ae

    throw p0
.end method

.method private static rotate(Landroid/content/Context;I)Z
    .registers 6

    .line 222
    const/4 v0, 0x0

    :try_start_1
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->listBackups(Landroid/content/Context;)Ljava/util/List;

    move-result-object v1

    .line 223
    new-instance v2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3;

    invoke-direct {v2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3;-><init>()V

    invoke-static {v1, v2}, Ljava/util/Collections;->sort(Ljava/util/List;Ljava/util/Comparator;)V

    .line 226
    nop

    .line 227
    const/4 v2, 0x1

    :goto_f
    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v3

    if-ge p1, v3, :cond_27

    invoke-interface {v1, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;

    iget-object v3, v3, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;->uri:Landroid/net/Uri;

    invoke-static {p0, v3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->delete(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result v3
    :try_end_21
    .catchall {:try_start_1 .. :try_end_21} :catchall_28

    if-nez v3, :cond_24

    const/4 v2, 0x0

    :cond_24
    add-int/lit8 p1, p1, 0x1

    goto :goto_f

    .line 228
    :cond_27
    return v2

    .line 229
    :catchall_28
    move-exception p0

    return v0
.end method

.method private static toast(Landroid/content/Context;Ljava/lang/String;)V
    .registers 4

    .line 277
    invoke-static {}, Landroid/os/Looper;->myLooper()Landroid/os/Looper;

    move-result-object v0

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    if-ne v0, v1, :cond_13

    const/4 v0, 0x0

    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    goto :goto_1d

    .line 278
    :cond_13
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->MAIN:Landroid/os/Handler;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$6;

    invoke-direct {v1, p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$6;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 281
    :goto_1d
    return-void
.end method

.method private static validateAndHash(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;
    .registers 8
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 180
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 182
    const/4 v1, 0x0

    :try_start_6
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    invoke-virtual {p0, p1}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object v1

    .line 183
    if-eqz v1, :cond_85

    .line 184
    const/16 p0, 0x2000

    new-array p0, p0, [B

    .line 185
    :goto_14
    invoke-virtual {v1, p0}, Ljava/io/InputStream;->read([B)I

    move-result p1

    const/4 v2, -0x1

    const/4 v3, 0x0

    if-eq p1, v2, :cond_20

    invoke-virtual {v0, p0, v3, p1}, Ljava/io/ByteArrayOutputStream;->write([BII)V
    :try_end_1f
    .catchall {:try_start_6 .. :try_end_1f} :catchall_8d

    goto :goto_14

    .line 186
    :cond_20
    if-eqz v1, :cond_25

    invoke-virtual {v1}, Ljava/io/InputStream;->close()V

    .line 187
    :cond_25
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p0

    .line 188
    const-string p1, "\ufeff# User dictionary for Google Pinyin Input\n"

    const-string v0, "UTF-16LE"

    invoke-virtual {p1, v0}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object p1

    .line 189
    array-length v0, p0

    array-length v1, p1

    if-lt v0, v1, :cond_7d

    .line 190
    const/4 v0, 0x0

    :goto_36
    array-length v1, p1

    if-ge v0, v1, :cond_4a

    aget-byte v1, p0, v0

    aget-byte v2, p1, v0

    if-ne v1, v2, :cond_42

    add-int/lit8 v0, v0, 0x1

    goto :goto_36

    .line 191
    :cond_42
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "bad header"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 192
    :cond_4a
    const-string p1, "SHA-256"

    invoke-static {p1}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object p1

    invoke-virtual {p1, p0}, Ljava/security/MessageDigest;->digest([B)[B

    move-result-object p0

    .line 193
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    .line 194
    array-length v0, p0

    const/4 v1, 0x0

    :goto_5b
    if-ge v1, v0, :cond_78

    aget-byte v2, p0, v1

    sget-object v4, Ljava/util/Locale;->US:Ljava/util/Locale;

    and-int/lit16 v2, v2, 0xff

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    const/4 v5, 0x1

    new-array v5, v5, [Ljava/lang/Object;

    aput-object v2, v5, v3

    const-string v2, "%02x"

    invoke-static {v4, v2, v5}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v1, v1, 0x1

    goto :goto_5b

    .line 195
    :cond_78
    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 189
    :cond_7d
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "short backup"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 183
    :cond_85
    :try_start_85
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "null input"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
    :try_end_8d
    .catchall {:try_start_85 .. :try_end_8d} :catchall_8d

    .line 186
    :catchall_8d
    move-exception p0

    if-eqz v1, :cond_93

    invoke-virtual {v1}, Ljava/io/InputStream;->close()V

    :cond_93
    goto :goto_95

    :goto_94
    throw p0

    :goto_95
    goto :goto_94
.end method
