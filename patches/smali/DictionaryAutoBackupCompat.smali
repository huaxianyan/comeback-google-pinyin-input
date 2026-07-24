.class public final Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupCompat.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ValidationCallback;,
        Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$DocumentInfo;,
        Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;
    }
.end annotation


# static fields
.field private static final DAY_MS:J = 0x5265c00L

.field static final EXTERNAL_STORAGE_AUTHORITY:Ljava/lang/String; = "com.android.externalstorage.documents"

.field private static final FINAL_SUFFIX:Ljava/lang/String; = ".txt"

.field private static final HOUR_MS:J = 0x36ee80L

.field private static final IO:Ljava/util/concurrent/ExecutorService;

.field static final KEY_ENABLED:Ljava/lang/String; = "dictionary_auto_backup_enabled"

.field static final KEY_FAILURES:Ljava/lang/String; = "dictionary_auto_backup_consecutive_failures"

.field static final KEY_INTERVAL:Ljava/lang/String; = "dictionary_auto_backup_interval_days"

.field static final KEY_LAST_ATTEMPT:Ljava/lang/String; = "dictionary_auto_backup_last_attempt_time"

.field static final KEY_LAST_SHA256:Ljava/lang/String; = "dictionary_auto_backup_last_sha256"

.field static final KEY_LAST_STATUS:Ljava/lang/String; = "dictionary_auto_backup_last_status"

.field static final KEY_LAST_SUCCESS:Ljava/lang/String; = "dictionary_auto_backup_last_success_time"

.field static final KEY_LAST_URI:Ljava/lang/String; = "dictionary_auto_backup_last_document_uri"

.field static final KEY_RETENTION:Ljava/lang/String; = "dictionary_auto_backup_retention_count"

.field static final KEY_TREE_LABEL:Ljava/lang/String; = "dictionary_auto_backup_tree_label"

.field static final KEY_TREE_URI:Ljava/lang/String; = "dictionary_auto_backup_tree_uri"

.field private static final MAIN:Landroid/os/Handler;

.field private static final PARTIAL_MAX_AGE_MS:J = 0x5265c00L

.field private static final PARTIAL_SUFFIX:Ljava/lang/String; = ".txt.partial"

.field private static final PREFIX:Ljava/lang/String; = "google-pinyin-user-dictionary-"

.field static final PREFS:Ljava/lang/String; = "dictionary_local_backup_preferences"

.field private static sInProgress:Z


# direct methods
.method static constructor <clinit>()V
    .registers 2

    .line 57
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->MAIN:Landroid/os/Handler;

    .line 58
    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->IO:Ljava/util/concurrent/ExecutorService;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 61
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(Landroid/content/Context;Landroid/net/Uri;Z)V
    .registers 3

    .line 35
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prepareAndStart(Landroid/content/Context;Landroid/net/Uri;Z)V

    return-void
.end method

.method static synthetic access$100(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V
    .registers 5

    .line 35
    invoke-static {p0, p1, p2, p3, p4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->enqueueNativeExport(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V

    return-void
.end method

.method static synthetic access$1000(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V
    .registers 5

    .line 35
    invoke-static {p0, p1, p2, p3, p4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finalizeExport(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V

    return-void
.end method

.method static synthetic access$1100()Ljava/util/concurrent/ExecutorService;
    .registers 1

    .line 35
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->IO:Ljava/util/concurrent/ExecutorService;

    return-object v0
.end method

.method static synthetic access$1200(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;
    .registers 2

    .line 35
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->validateTree(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$1300()Landroid/os/Handler;
    .registers 1

    .line 35
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->MAIN:Landroid/os/Handler;

    return-object v0
.end method

.method static synthetic access$1400(Landroid/content/Context;Ljava/lang/String;)V
    .registers 2

    .line 35
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->showToast(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method

.method static synthetic access$400(Landroid/content/Context;Landroid/net/Uri;)V
    .registers 2

    .line 35
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    return-void
.end method

.method static synthetic access$700(Landroid/content/Context;ZLjava/lang/String;Ljava/lang/Throwable;)V
    .registers 4

    .line 35
    invoke-static {p0, p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishFailure(Landroid/content/Context;ZLjava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method private static clamp(IIII)I
    .registers 4

    .line 478
    if-lt p0, p1, :cond_4

    if-le p0, p2, :cond_5

    :cond_4
    move p0, p3

    :cond_5
    return p0
.end method

.method private static cleanupOldPartials(Landroid/content/Context;Landroid/net/Uri;)V
    .registers 15

    .line 342
    nop

    .line 344
    const/4 v1, 0x0

    :try_start_2
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    .line 345
    nop

    .line 346
    invoke-static {p1}, Landroid/provider/DocumentsContract;->getTreeDocumentId(Landroid/net/Uri;)Ljava/lang/String;

    move-result-object p0

    .line 345
    invoke-static {p1, p0}, Landroid/provider/DocumentsContract;->buildChildDocumentsUriUsingTree(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v3

    .line 347
    const/4 p0, 0x3

    new-array v4, p0, [Ljava/lang/String;

    const-string p0, "document_id"

    const/4 v8, 0x0

    aput-object p0, v4, v8

    const-string p0, "_display_name"

    const/4 v9, 0x1

    aput-object p0, v4, v9

    const-string p0, "last_modified"

    const/4 v10, 0x2

    aput-object p0, v4, v10

    .line 352
    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v5, 0x0

    invoke-virtual/range {v2 .. v7}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v1
    :try_end_28
    .catchall {:try_start_2 .. :try_end_28} :catchall_82

    .line 353
    if-nez v1, :cond_30

    .line 369
    if-eqz v1, :cond_2f

    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 353
    :cond_2f
    return-void

    .line 354
    :cond_30
    :try_start_30
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v3

    .line 355
    :goto_34
    invoke-interface {v1}, Landroid/database/Cursor;->moveToNext()Z

    move-result p0

    if-eqz p0, :cond_7f

    .line 356
    invoke-interface {v1, v9}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object p0

    .line 357
    invoke-interface {v1, v10}, Landroid/database/Cursor;->isNull(I)Z

    move-result v0

    const-wide/16 v5, 0x0

    if-eqz v0, :cond_48

    move-wide v11, v5

    goto :goto_4c

    :cond_48
    invoke-interface {v1, v10}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide v11

    .line 358
    :goto_4c
    if-eqz p0, :cond_7e

    const-string v0, "google-pinyin-user-dictionary-"

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_7e

    const-string v0, ".txt.partial"

    invoke-virtual {p0, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_7e

    cmp-long p0, v11, v5

    if-lez p0, :cond_7e

    cmp-long p0, v3, v11

    if-ltz p0, :cond_7e

    sub-long v5, v3, v11

    const-wide/32 v11, 0x5265c00

    cmp-long p0, v5, v11

    if-ltz p0, :cond_7e

    .line 361
    nop

    .line 362
    invoke-interface {v1, v8}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object p0

    .line 361
    invoke-static {p1, p0}, Landroid/provider/DocumentsContract;->buildDocumentUriUsingTree(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p0
    :try_end_78
    .catchall {:try_start_30 .. :try_end_78} :catchall_82

    .line 363
    :try_start_78
    invoke-static {v2, p0}, Landroid/provider/DocumentsContract;->deleteDocument(Landroid/content/ContentResolver;Landroid/net/Uri;)Z
    :try_end_7b
    .catchall {:try_start_78 .. :try_end_7b} :catchall_7c

    .line 364
    :goto_7b
    goto :goto_7e

    :catchall_7c
    move-exception v0

    goto :goto_7b

    .line 366
    :cond_7e
    :goto_7e
    goto :goto_34

    .line 369
    :cond_7f
    if-eqz v1, :cond_88

    goto :goto_85

    .line 367
    :catchall_82
    move-exception v0

    .line 369
    if-eqz v1, :cond_88

    :goto_85
    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 371
    :cond_88
    return-void
.end method

.method private static deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V
    .registers 2

    .line 461
    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    invoke-static {p0, p1}, Landroid/provider/DocumentsContract;->deleteDocument(Landroid/content/ContentResolver;Landroid/net/Uri;)Z
    :try_end_7
    .catchall {:try_start_0 .. :try_end_7} :catchall_8

    goto :goto_9

    .line 462
    :catchall_8
    move-exception p0

    :goto_9
    nop

    .line 463
    return-void
.end method

.method private static enqueueNativeExport(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V
    .registers 20

    .line 186
    const-string v6, "a"

    :try_start_2
    const-string v0, "aib"

    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v7

    .line 187
    const/4 v8, 0x0

    new-array v0, v8, [Ljava/lang/Class;

    invoke-virtual {v7, v6, v0}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    new-array v1, v8, [Ljava/lang/Object;

    const/4 v2, 0x0

    invoke-virtual {v0, v2, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v9

    .line 188
    const-string v0, "com.google.android.apps.inputmethod.libs.framework.core.TaskFactory"

    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v10

    .line 190
    const-string v0, "beg"

    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v0

    .line 191
    const/4 v11, 0x3

    new-array v1, v11, [Ljava/lang/Class;

    const-class v2, Landroid/content/Context;

    aput-object v2, v1, v8

    const-class v2, Lcom/google/android/apps/inputmethod/libs/framework/core/TaskListener;

    const/4 v12, 0x1

    aput-object v2, v1, v12

    const-class v2, Landroid/net/Uri;

    const/4 v13, 0x2

    aput-object v2, v1, v13

    invoke-virtual {v0, v1}, Ljava/lang/Class;->getConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v14

    .line 193
    new-instance v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;
    :try_end_39
    .catchall {:try_start_2 .. :try_end_39} :catchall_77

    move-object v1, p0

    move-object/from16 v2, p1

    move-object/from16 v3, p2

    move-object/from16 v4, p3

    move/from16 v5, p4

    :try_start_42
    invoke-direct/range {v0 .. v5}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;-><init>(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V

    .line 194
    new-array v2, v11, [Ljava/lang/Object;

    aput-object p0, v2, v8

    aput-object v0, v2, v12

    aput-object v3, v2, v13

    invoke-virtual {v14, v2}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    .line 195
    new-array v2, v11, [Ljava/lang/Class;

    const-class v4, Ljava/lang/String;

    aput-object v4, v2, v8

    aput-object v10, v2, v12

    sget-object v4, Ljava/lang/Long;->TYPE:Ljava/lang/Class;

    aput-object v4, v2, v13

    invoke-virtual {v7, v6, v2}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v2

    .line 197
    const-wide/16 v4, 0x0

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    new-array v5, v11, [Ljava/lang/Object;

    const-string v6, "user_dict_auto_backup"

    aput-object v6, v5, v8

    aput-object v0, v5, v12

    aput-object v4, v5, v13

    invoke-virtual {v2, v9, v5}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_74
    .catchall {:try_start_42 .. :try_end_74} :catchall_75

    .line 201
    goto :goto_84

    .line 198
    :catchall_75
    move-exception v0

    goto :goto_7a

    :catchall_77
    move-exception v0

    move-object/from16 v3, p2

    .line 199
    :goto_7a
    invoke-static {p0, v3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 200
    const-string v2, "\u65e0\u6cd5\u542f\u52a8\u539f\u751f\u7528\u6237\u8bcd\u5178\u5bfc\u51fa"

    move/from16 v5, p4

    invoke-static {p0, v5, v2, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishFailure(Landroid/content/Context;ZLjava/lang/String;Ljava/lang/Throwable;)V

    .line 202
    :goto_84
    return-void
.end method

.method private static failWithoutStarting(Landroid/content/Context;ZLjava/lang/String;)V
    .registers 7

    .line 150
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 151
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v2, "dictionary_auto_backup_last_status"

    invoke-interface {v1, v2, p2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 152
    const-string v2, "dictionary_auto_backup_consecutive_failures"

    const/4 v3, 0x0

    invoke-interface {v0, v2, v3}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    add-int/lit8 v0, v0, 0x1

    invoke-interface {v1, v2, v0}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 153
    if-eqz p1, :cond_23

    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->showToast(Landroid/content/Context;Ljava/lang/String;)V

    .line 154
    :cond_23
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->refreshAll()V

    .line 155
    return-void
.end method

.method private static finalizeExport(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V
    .registers 12

    .line 243
    const-string v0, "dictionary_auto_backup_last_status"

    :try_start_2
    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->validateAndHash(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;

    move-result-object v1

    .line 244
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    invoke-static {v2, p2, p3}, Landroid/provider/DocumentsContract;->renameDocument(Landroid/content/ContentResolver;Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p3

    .line 246
    if-eqz p3, :cond_68

    .line 247
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    .line 248
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v4

    .line 249
    invoke-interface {v4}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v5

    const-string v6, "dictionary_auto_backup_last_success_time"

    invoke-interface {v5, v6, v2, v3}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    const-string v3, "\u5907\u4efd\u6210\u529f"

    .line 250
    invoke-interface {v2, v0, v3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    const-string v3, "dictionary_auto_backup_last_document_uri"

    .line 251
    invoke-virtual {p3}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-interface {v2, v3, p3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p3

    const-string v2, "dictionary_auto_backup_last_sha256"

    .line 252
    invoke-interface {p3, v2, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p3

    const-string v1, "dictionary_auto_backup_consecutive_failures"

    .line 253
    const/4 v2, 0x0

    invoke-interface {p3, v1, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p3

    invoke-interface {p3}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 254
    const-string p3, "dictionary_auto_backup_retention_count"

    .line 255
    const/16 v1, 0xa

    invoke-interface {v4, p3, v1}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result p3

    const/4 v2, 0x1

    const/16 v3, 0x64

    invoke-static {p3, v2, v3, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->clamp(IIII)I

    move-result p3

    .line 254
    invoke-static {p0, p1, p3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->rotate(Landroid/content/Context;Landroid/net/Uri;I)Z

    move-result p1

    .line 256
    if-nez p1, :cond_64

    .line 257
    invoke-interface {v4}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    const-string p3, "\u5907\u4efd\u6210\u529f\uff0c\u4f46\u65e7\u7248\u672c\u6e05\u7406\u5931\u8d25"

    invoke-interface {p1, v0, p3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 259
    :cond_64
    invoke-static {p0, p4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishSuccess(Landroid/content/Context;Z)V

    .line 263
    goto :goto_79

    .line 246
    :cond_68
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string p3, "renameDocument returned null"

    invoke-direct {p1, p3}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_70
    .catchall {:try_start_2 .. :try_end_70} :catchall_70

    .line 260
    :catchall_70
    move-exception p1

    .line 261
    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 262
    const-string p2, "\u672c\u5730\u5907\u4efd\u6821\u9a8c\u6216\u53d1\u5e03\u5931\u8d25"

    invoke-static {p0, p4, p2, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishFailure(Landroid/content/Context;ZLjava/lang/String;Ljava/lang/Throwable;)V

    .line 264
    :goto_79
    return-void
.end method

.method private static finishFailure(Landroid/content/Context;ZLjava/lang/String;Ljava/lang/Throwable;)V
    .registers 8

    .line 448
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p3

    .line 449
    invoke-interface {p3}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "dictionary_auto_backup_last_status"

    invoke-interface {v0, v1, p2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "dictionary_auto_backup_consecutive_failures"

    const-string v2, "dictionary_auto_backup_consecutive_failures"

    .line 450
    const/4 v3, 0x0

    invoke-interface {p3, v2, v3}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result p3

    add-int/lit8 p3, p3, 0x1

    invoke-interface {v0, v1, p3}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p3

    invoke-interface {p3}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 451
    const-class p3, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;

    monitor-enter p3

    :try_start_23
    sput-boolean v3, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->sInProgress:Z

    monitor-exit p3
    :try_end_26
    .catchall {:try_start_23 .. :try_end_26} :catchall_31

    .line 452
    sget-object p3, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->MAIN:Landroid/os/Handler;

    new-instance v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$6;

    invoke-direct {v0, p1, p0, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$6;-><init>(ZLandroid/content/Context;Ljava/lang/String;)V

    invoke-virtual {p3, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 458
    return-void

    .line 451
    :catchall_31
    move-exception p0

    :try_start_32
    monitor-exit p3
    :try_end_33
    .catchall {:try_start_32 .. :try_end_33} :catchall_31

    throw p0
.end method

.method private static finishSuccess(Landroid/content/Context;Z)V
    .registers 4

    .line 437
    const-class v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;

    monitor-enter v0

    const/4 v1, 0x0

    :try_start_4
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->sInProgress:Z

    monitor-exit v0
    :try_end_7
    .catchall {:try_start_4 .. :try_end_7} :catchall_12

    .line 438
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->MAIN:Landroid/os/Handler;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$5;

    invoke-direct {v1, p1, p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$5;-><init>(ZLandroid/content/Context;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 444
    return-void

    .line 437
    :catchall_12
    move-exception p0

    :try_start_13
    monitor-exit v0
    :try_end_14
    .catchall {:try_start_13 .. :try_end_14} :catchall_12

    throw p0
.end method

.method static hasPersistedAccess(Landroid/content/Context;Landroid/net/Uri;)Z
    .registers 5

    .line 78
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    const/4 v2, 0x0

    if-lt v0, v1, :cond_42

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->isLocalTree(Landroid/net/Uri;)Z

    move-result v0

    if-nez v0, :cond_e

    goto :goto_42

    .line 80
    :cond_e
    :try_start_e
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/ContentResolver;->getPersistedUriPermissions()Ljava/util/List;

    move-result-object p0

    .line 81
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_1a
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_3f

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/content/UriPermission;

    .line 82
    invoke-virtual {v0}, Landroid/content/UriPermission;->getUri()Landroid/net/Uri;

    move-result-object v1

    invoke-virtual {p1, v1}, Landroid/net/Uri;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_3e

    invoke-virtual {v0}, Landroid/content/UriPermission;->isReadPermission()Z

    move-result v1

    if-eqz v1, :cond_3e

    .line 83
    invoke-virtual {v0}, Landroid/content/UriPermission;->isWritePermission()Z

    move-result v0
    :try_end_3a
    .catch Ljava/lang/RuntimeException; {:try_start_e .. :try_end_3a} :catch_40

    if-eqz v0, :cond_3e

    .line 84
    const/4 p0, 0x1

    return p0

    .line 86
    :cond_3e
    goto :goto_1a

    .line 88
    :cond_3f
    goto :goto_41

    .line 87
    :catch_40
    move-exception p0

    .line 89
    :goto_41
    return v2

    .line 78
    :cond_42
    :goto_42
    return v2
.end method

.method public static isInProgress()Z
    .registers 2

    .line 68
    const-class v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;

    monitor-enter v0

    .line 69
    :try_start_3
    sget-boolean v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->sInProgress:Z

    monitor-exit v0

    return v1

    .line 70
    :catchall_7
    move-exception v1

    monitor-exit v0
    :try_end_9
    .catchall {:try_start_3 .. :try_end_9} :catchall_7

    throw v1
.end method

.method static isLocalTree(Landroid/net/Uri;)Z
    .registers 2

    .line 74
    if-eqz p0, :cond_10

    const-string v0, "com.android.externalstorage.documents"

    invoke-virtual {p0}, Landroid/net/Uri;->getAuthority()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_10

    const/4 p0, 0x1

    goto :goto_11

    :cond_10
    const/4 p0, 0x0

    :goto_11
    return p0
.end method

.method static prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .registers 3

    .line 64
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "dictionary_local_backup_preferences"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

.method private static prepareAndStart(Landroid/content/Context;Landroid/net/Uri;Z)V
    .registers 11

    .line 159
    nop

    .line 161
    const/4 v1, 0x0

    :try_start_2
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->cleanupOldPartials(Landroid/content/Context;Landroid/net/Uri;)V

    .line 162
    new-instance v0, Ljava/text/SimpleDateFormat;

    const-string v2, "yyyy-MM-dd_HH-mm-ss-SSS"

    sget-object v3, Ljava/util/Locale;->US:Ljava/util/Locale;

    invoke-direct {v0, v2, v3}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    new-instance v2, Ljava/util/Date;

    invoke-direct {v2}, Ljava/util/Date;-><init>()V

    .line 163
    invoke-virtual {v0, v2}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v0

    .line 164
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "google-pinyin-user-dictionary-"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, ".txt"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    .line 165
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, ".partial"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 166
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->treeDocumentUri(Landroid/net/Uri;)Landroid/net/Uri;

    move-result-object v2

    .line 167
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v3

    const-string v4, "text/plain"

    invoke-static {v3, v2, v4, v0}, Landroid/provider/DocumentsContract;->createDocument(Landroid/content/ContentResolver;Landroid/net/Uri;Ljava/lang/String;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v5
    :try_end_51
    .catchall {:try_start_2 .. :try_end_51} :catchall_75

    .line 169
    if-eqz v5, :cond_69

    .line 170
    nop

    .line 171
    nop

    .line 172
    :try_start_55
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->MAIN:Landroid/os/Handler;

    new-instance v2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;
    :try_end_59
    .catchall {:try_start_55 .. :try_end_59} :catchall_63

    move-object v3, p0

    move-object v4, p1

    move v7, p2

    :try_start_5c
    invoke-direct/range {v2 .. v7}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$2;-><init>(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V

    invoke-virtual {v0, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 180
    goto :goto_83

    .line 177
    :catchall_63
    move-exception v0

    move-object v3, p0

    move v7, p2

    :goto_66
    move-object p0, v0

    move-object v1, v5

    goto :goto_79

    .line 169
    :cond_69
    move-object v3, p0

    move v7, p2

    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "createDocument returned null"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
    :try_end_73
    .catchall {:try_start_5c .. :try_end_73} :catchall_73

    .line 177
    :catchall_73
    move-exception v0

    goto :goto_66

    :catchall_75
    move-exception v0

    move-object v3, p0

    move v7, p2

    move-object p0, v0

    .line 178
    :goto_79
    if-eqz v1, :cond_7e

    invoke-static {v3, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 179
    :cond_7e
    const-string p1, "\u65e0\u6cd5\u5728\u672c\u5730\u5907\u4efd\u76ee\u5f55\u521b\u5efa\u6587\u4ef6"

    invoke-static {v3, v7, p1, p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishFailure(Landroid/content/Context;ZLjava/lang/String;Ljava/lang/Throwable;)V

    .line 181
    :goto_83
    return-void
.end method

.method public static request(Landroid/content/Context;Z)V
    .registers 19

    .line 93
    move/from16 v1, p1

    if-nez p0, :cond_5

    return-void

    .line 94
    :cond_5
    invoke-virtual/range {p0 .. p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v2

    .line 95
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 96
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v3

    .line 99
    const-class v5, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;

    monitor-enter v5

    .line 100
    :try_start_14
    sget-boolean v6, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->sInProgress:Z

    if-eqz v6, :cond_21

    .line 101
    if-eqz v1, :cond_1f

    const-string v0, "\u672c\u5730\u8bcd\u5178\u5907\u4efd\u6b63\u5728\u8fdb\u884c"

    invoke-static {v2, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->showToast(Landroid/content/Context;Ljava/lang/String;)V

    .line 102
    :cond_1f
    monitor-exit v5

    return-void

    .line 104
    :cond_21
    sget v6, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v7, 0x15

    if-ge v6, v7, :cond_30

    .line 105
    if-eqz v1, :cond_2e

    const-string v0, "\u672c\u5730\u81ea\u52a8\u5907\u4efd\u9700\u8981 Android 5.0 \u6216\u66f4\u9ad8\u7248\u672c"

    invoke-static {v2, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->showToast(Landroid/content/Context;Ljava/lang/String;)V

    .line 106
    :cond_2e
    monitor-exit v5

    return-void

    .line 108
    :cond_30
    const/4 v6, 0x0

    if-nez v1, :cond_3d

    const-string v7, "dictionary_auto_backup_enabled"

    invoke-interface {v0, v7, v6}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v7

    if-nez v7, :cond_3d

    monitor-exit v5

    return-void

    .line 109
    :cond_3d
    const-string v7, "dictionary_auto_backup_tree_uri"

    const/4 v8, 0x0

    invoke-interface {v0, v7, v8}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    .line 110
    if-eqz v7, :cond_e3

    invoke-virtual {v7}, Ljava/lang/String;->length()I

    move-result v8
    :try_end_4a
    .catchall {:try_start_14 .. :try_end_4a} :catchall_ea

    if-nez v8, :cond_4e

    goto/16 :goto_e3

    .line 115
    :cond_4e
    :try_start_4e
    invoke-static {v7}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v7
    :try_end_52
    .catch Ljava/lang/RuntimeException; {:try_start_4e .. :try_end_52} :catch_db
    .catchall {:try_start_4e .. :try_end_52} :catchall_ea

    .line 119
    nop

    .line 120
    :try_start_53
    invoke-static {v2, v7}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->hasPersistedAccess(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result v8

    if-nez v8, :cond_60

    .line 121
    const-string v0, "\u672c\u5730\u5907\u4efd\u4f4d\u7f6e\u4e0d\u53ef\u8bbf\u95ee\uff0c\u8bf7\u91cd\u65b0\u9009\u62e9"

    invoke-static {v2, v1, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->failWithoutStarting(Landroid/content/Context;ZLjava/lang/String;)V

    .line 122
    monitor-exit v5

    return-void

    .line 124
    :cond_60
    const/4 v8, 0x1

    if-nez v1, :cond_b5

    .line 125
    const-string v9, "dictionary_auto_backup_interval_days"

    const/4 v10, 0x7

    invoke-interface {v0, v9, v10}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v9

    const/16 v11, 0x16d

    invoke-static {v9, v8, v11, v10}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->clamp(IIII)I

    move-result v9

    .line 126
    const-string v10, "dictionary_auto_backup_last_success_time"

    const-wide/16 v11, 0x0

    invoke-interface {v0, v10, v11, v12}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v13

    .line 127
    cmp-long v10, v13, v11

    if-lez v10, :cond_8f

    cmp-long v10, v3, v13

    if-ltz v10, :cond_8f

    sub-long v13, v3, v13

    int-to-long v9, v9

    const-wide/32 v15, 0x5265c00

    mul-long v9, v9, v15

    cmp-long v15, v13, v9

    if-ltz v15, :cond_8d

    goto :goto_8f

    :cond_8d
    const/4 v9, 0x0

    goto :goto_90

    :cond_8f
    :goto_8f
    const/4 v9, 0x1

    .line 129
    :goto_90
    if-nez v9, :cond_94

    monitor-exit v5

    return-void

    .line 130
    :cond_94
    const-string v9, "dictionary_auto_backup_last_attempt_time"

    invoke-interface {v0, v9, v11, v12}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v9

    .line 131
    cmp-long v13, v9, v11

    if-lez v13, :cond_b5

    cmp-long v11, v3, v9

    if-ltz v11, :cond_b5

    sub-long v9, v3, v9

    const-wide/32 v11, 0x36ee80

    cmp-long v13, v9, v11

    if-gez v13, :cond_b5

    const-string v9, "dictionary_auto_backup_consecutive_failures"

    .line 132
    invoke-interface {v0, v9, v6}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v6

    if-lez v6, :cond_b5

    .line 133
    monitor-exit v5

    return-void

    .line 136
    :cond_b5
    sput-boolean v8, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->sInProgress:Z

    .line 137
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v6, "dictionary_auto_backup_last_attempt_time"

    invoke-interface {v0, v6, v3, v4}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v3, "dictionary_auto_backup_last_status"

    const-string v4, "\u6b63\u5728\u5907\u4efd"

    .line 138
    invoke-interface {v0, v3, v4}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 139
    monitor-exit v5
    :try_end_cd
    .catchall {:try_start_53 .. :try_end_cd} :catchall_ea

    .line 141
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->refreshAll()V

    .line 142
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->IO:Ljava/util/concurrent/ExecutorService;

    new-instance v3, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$1;

    invoke-direct {v3, v2, v7, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$1;-><init>(Landroid/content/Context;Landroid/net/Uri;Z)V

    invoke-interface {v0, v3}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 147
    return-void

    .line 116
    :catch_db
    move-exception v0

    .line 117
    :try_start_dc
    const-string v0, "\u672c\u5730\u5907\u4efd\u4f4d\u7f6e\u65e0\u6548"

    invoke-static {v2, v1, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->failWithoutStarting(Landroid/content/Context;ZLjava/lang/String;)V

    .line 118
    monitor-exit v5

    return-void

    .line 111
    :cond_e3
    :goto_e3
    const-string v0, "\u672a\u9009\u62e9\u672c\u5730\u5907\u4efd\u4f4d\u7f6e"

    invoke-static {v2, v1, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->failWithoutStarting(Landroid/content/Context;ZLjava/lang/String;)V

    .line 112
    monitor-exit v5

    return-void

    .line 139
    :catchall_ea
    move-exception v0

    monitor-exit v5
    :try_end_ec
    .catchall {:try_start_dc .. :try_end_ec} :catchall_ea

    throw v0
.end method

.method private static rotate(Landroid/content/Context;Landroid/net/Uri;I)Z
    .registers 12

    .line 293
    nop

    .line 294
    nop

    .line 296
    const/4 v1, 0x0

    const/4 v2, 0x0

    :try_start_4
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v3

    .line 297
    nop

    .line 298
    invoke-static {p1}, Landroid/provider/DocumentsContract;->getTreeDocumentId(Landroid/net/Uri;)Ljava/lang/String;

    move-result-object p0

    .line 297
    invoke-static {p1, p0}, Landroid/provider/DocumentsContract;->buildChildDocumentsUriUsingTree(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v4

    .line 299
    const/4 p0, 0x2

    new-array v5, p0, [Ljava/lang/String;

    const-string p0, "document_id"

    aput-object p0, v5, v1

    const-string p0, "_display_name"

    const/4 v0, 0x1

    aput-object p0, v5, v0

    .line 303
    const/4 v7, 0x0

    const/4 v8, 0x0

    const/4 v6, 0x0

    invoke-virtual/range {v3 .. v8}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v2
    :try_end_24
    .catchall {:try_start_4 .. :try_end_24} :catchall_91

    .line 304
    if-nez v2, :cond_2c

    .line 330
    if-eqz v2, :cond_2b

    invoke-interface {v2}, Landroid/database/Cursor;->close()V

    .line 304
    :cond_2b
    return v1

    .line 305
    :cond_2c
    :try_start_2c
    new-instance p0, Ljava/util/ArrayList;

    invoke-direct {p0}, Ljava/util/ArrayList;-><init>()V

    .line 306
    :goto_31
    invoke-interface {v2}, Landroid/database/Cursor;->moveToNext()Z

    move-result v4

    if-eqz v4, :cond_66

    .line 307
    invoke-interface {v2, v1}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v4

    .line 308
    invoke-interface {v2, v0}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v5

    .line 309
    if-eqz v5, :cond_65

    const-string v6, "google-pinyin-user-dictionary-"

    invoke-virtual {v5, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_65

    const-string v6, ".txt"

    invoke-virtual {v5, v6}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_65

    const-string v6, ".txt.partial"

    .line 310
    invoke-virtual {v5, v6}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_65

    .line 311
    new-instance v6, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$DocumentInfo;

    .line 312
    invoke-static {p1, v4}, Landroid/provider/DocumentsContract;->buildDocumentUriUsingTree(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v4

    invoke-direct {v6, v5, v4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$DocumentInfo;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    .line 311
    invoke-interface {p0, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 314
    :cond_65
    goto :goto_31

    .line 315
    :cond_66
    new-instance p1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3;

    invoke-direct {p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$3;-><init>()V

    invoke-static {p0, p1}, Ljava/util/Collections;->sort(Ljava/util/List;Ljava/util/Comparator;)V

    .line 320
    nop

    :goto_6f
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result p1
    :try_end_73
    .catchall {:try_start_2c .. :try_end_73} :catchall_91

    if-ge p2, p1, :cond_8a

    .line 322
    :try_start_75
    invoke-interface {p0, p2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$DocumentInfo;

    iget-object p1, p1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$DocumentInfo;->uri:Landroid/net/Uri;

    invoke-static {v3, p1}, Landroid/provider/DocumentsContract;->deleteDocument(Landroid/content/ContentResolver;Landroid/net/Uri;)Z

    move-result p1
    :try_end_81
    .catchall {:try_start_75 .. :try_end_81} :catchall_85

    if-nez p1, :cond_84

    const/4 v0, 0x0

    .line 325
    :cond_84
    goto :goto_87

    .line 323
    :catchall_85
    move-exception v0

    .line 324
    const/4 v0, 0x0

    .line 320
    :goto_87
    add-int/lit8 p2, p2, 0x1

    goto :goto_6f

    .line 330
    :cond_8a
    if-eqz v2, :cond_8f

    invoke-interface {v2}, Landroid/database/Cursor;->close()V

    .line 332
    :cond_8f
    move v1, v0

    goto :goto_98

    .line 327
    :catchall_91
    move-exception v0

    .line 328
    nop

    .line 330
    if-eqz v2, :cond_98

    invoke-interface {v2}, Landroid/database/Cursor;->close()V

    .line 332
    :cond_98
    :goto_98
    return v1
.end method

.method private static showToast(Landroid/content/Context;Ljava/lang/String;)V
    .registers 4

    .line 466
    invoke-static {}, Landroid/os/Looper;->myLooper()Landroid/os/Looper;

    move-result-object v0

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    if-ne v0, v1, :cond_13

    .line 467
    const/4 v0, 0x0

    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    goto :goto_1d

    .line 469
    :cond_13
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->MAIN:Landroid/os/Handler;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$7;

    invoke-direct {v1, p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$7;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 475
    :goto_1d
    return-void
.end method

.method private static treeDocumentUri(Landroid/net/Uri;)Landroid/net/Uri;
    .registers 2

    .line 432
    nop

    .line 433
    invoke-static {p0}, Landroid/provider/DocumentsContract;->getTreeDocumentId(Landroid/net/Uri;)Ljava/lang/String;

    move-result-object v0

    .line 432
    invoke-static {p0, v0}, Landroid/provider/DocumentsContract;->buildDocumentUriUsingTree(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p0

    return-object p0
.end method

.method private static validateAndHash(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;
    .registers 8
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 267
    nop

    .line 268
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 270
    const/4 v1, 0x0

    :try_start_7
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    invoke-virtual {p0, p1}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object v1

    .line 271
    if-eqz v1, :cond_8a

    .line 272
    const/16 p0, 0x2000

    new-array p0, p0, [B

    .line 274
    :goto_15
    invoke-virtual {v1, p0}, Ljava/io/InputStream;->read([B)I

    move-result p1

    const/4 v2, -0x1

    const/4 v3, 0x0

    if-eq p1, v2, :cond_21

    invoke-virtual {v0, p0, v3, p1}, Ljava/io/ByteArrayOutputStream;->write([BII)V
    :try_end_20
    .catchall {:try_start_7 .. :try_end_20} :catchall_92

    goto :goto_15

    .line 276
    :cond_21
    if-eqz v1, :cond_26

    invoke-virtual {v1}, Ljava/io/InputStream;->close()V

    .line 278
    :cond_26
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p0

    .line 279
    nop

    .line 280
    const-string p1, "\ufeff# User dictionary for Google Pinyin Input\n"

    const-string v0, "UTF-16LE"

    invoke-virtual {p1, v0}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object p1

    .line 281
    array-length v0, p0

    array-length v1, p1

    if-lt v0, v1, :cond_82

    .line 282
    const/4 v0, 0x0

    :goto_38
    array-length v1, p1

    if-ge v0, v1, :cond_4c

    .line 283
    aget-byte v1, p0, v0

    aget-byte v2, p1, v0

    if-ne v1, v2, :cond_44

    .line 282
    add-int/lit8 v0, v0, 0x1

    goto :goto_38

    .line 283
    :cond_44
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "invalid backup header"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 285
    :cond_4c
    const-string p1, "SHA-256"

    invoke-static {p1}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object p1

    .line 286
    invoke-virtual {p1, p0}, Ljava/security/MessageDigest;->digest([B)[B

    move-result-object p0

    .line 287
    new-instance p1, Ljava/lang/StringBuilder;

    array-length v0, p0

    mul-int/lit8 v0, v0, 0x2

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(I)V

    .line 288
    array-length v0, p0

    const/4 v1, 0x0

    :goto_60
    if-ge v1, v0, :cond_7d

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

    goto :goto_60

    .line 289
    :cond_7d
    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 281
    :cond_82
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "backup too short"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 271
    :cond_8a
    :try_start_8a
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "openInputStream returned null"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
    :try_end_92
    .catchall {:try_start_8a .. :try_end_92} :catchall_92

    .line 276
    :catchall_92
    move-exception p0

    if-eqz v1, :cond_98

    invoke-virtual {v1}, Ljava/io/InputStream;->close()V

    .line 277
    :cond_98
    goto :goto_9a

    :goto_99
    throw p0

    :goto_9a
    goto :goto_99
.end method

.method private static validateTree(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;
    .registers 9

    .line 393
    const-string v0, ".tmp"

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->isLocalTree(Landroid/net/Uri;)Z

    move-result v1

    if-nez v1, :cond_b

    const-string p0, "\u8bf7\u9009\u62e9\u8bbe\u5907\u5185\u90e8\u5b58\u50a8\u6216\u672c\u673a SD \u5361\u76ee\u5f55"

    return-object p0

    .line 394
    :cond_b
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->hasPersistedAccess(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result v1

    if-nez v1, :cond_14

    const-string p0, "\u672a\u83b7\u5f97\u672c\u5730\u76ee\u5f55\u7684\u8bfb\u5199\u6743\u9650"

    return-object p0

    .line 395
    :cond_14
    nop

    .line 396
    nop

    .line 398
    const/4 v1, 0x0

    :try_start_17
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    .line 399
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->treeDocumentUri(Landroid/net/Uri;)Landroid/net/Uri;

    move-result-object p1

    .line 400
    invoke-static {}, Ljava/util/UUID;->randomUUID()Ljava/util/UUID;

    move-result-object v3

    invoke-virtual {v3}, Ljava/util/UUID;->toString()Ljava/lang/String;

    move-result-object v3

    .line 401
    const-string v4, "text/plain"

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, ".google-pinyin-backup-test-"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v2, p1, v4, v5}, Landroid/provider/DocumentsContract;->createDocument(Landroid/content/ContentResolver;Landroid/net/Uri;Ljava/lang/String;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1
    :try_end_44
    .catchall {:try_start_17 .. :try_end_44} :catchall_e3

    .line 403
    if-nez p1, :cond_4f

    :try_start_46
    const-string v0, "\u8be5\u76ee\u5f55\u4e0d\u652f\u6301\u521b\u5efa\u5907\u4efd\u6587\u4ef6"
    :try_end_48
    .catchall {:try_start_46 .. :try_end_48} :catchall_df

    .line 426
    if-eqz p1, :cond_4d

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 427
    :cond_4d
    nop

    .line 403
    return-object v0

    .line 404
    :cond_4f
    :try_start_4f
    const-string v4, "w"

    invoke-virtual {v2, p1, v4}, Landroid/content/ContentResolver;->openOutputStream(Landroid/net/Uri;Ljava/lang/String;)Ljava/io/OutputStream;

    move-result-object v4

    .line 405
    if-nez v4, :cond_60

    const-string v0, "\u8be5\u76ee\u5f55\u4e0d\u652f\u6301\u5199\u5165\u5907\u4efd\u6587\u4ef6"
    :try_end_59
    .catchall {:try_start_4f .. :try_end_59} :catchall_df

    .line 426
    if-eqz p1, :cond_5e

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 427
    :cond_5e
    nop

    .line 405
    return-object v0

    .line 406
    :cond_60
    const/4 v5, 0x3

    :try_start_61
    new-array v5, v5, [B

    fill-array-data v5, :array_fe

    invoke-virtual {v4, v5}, Ljava/io/OutputStream;->write([B)V

    .line 407
    invoke-virtual {v4}, Ljava/io/OutputStream;->close()V

    .line 408
    invoke-virtual {v2, p1}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object v4

    .line 409
    if-eqz v4, :cond_d1

    invoke-virtual {v4}, Ljava/io/InputStream;->read()I

    move-result v5

    const/16 v6, 0x47

    if-ne v5, v6, :cond_d1

    invoke-virtual {v4}, Ljava/io/InputStream;->read()I

    move-result v5

    const/16 v6, 0x50

    if-ne v5, v6, :cond_d1

    invoke-virtual {v4}, Ljava/io/InputStream;->read()I

    move-result v5

    const/16 v6, 0x49

    if-eq v5, v6, :cond_8b

    goto :goto_d1

    .line 413
    :cond_8b
    invoke-virtual {v4}, Ljava/io/InputStream;->close()V

    .line 414
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, ".google-pinyin-backup-test-renamed-"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, p1, v0}, Landroid/provider/DocumentsContract;->renameDocument(Landroid/content/ContentResolver;Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0
    :try_end_a9
    .catchall {:try_start_61 .. :try_end_a9} :catchall_df

    .line 416
    if-nez v0, :cond_ba

    :try_start_ab
    const-string v1, "\u8be5\u76ee\u5f55\u4e0d\u652f\u6301\u5b89\u5168\u53d1\u5e03\u5907\u4efd\u6587\u4ef6"
    :try_end_ad
    .catchall {:try_start_ab .. :try_end_ad} :catchall_b8

    .line 426
    if-eqz p1, :cond_b2

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 427
    :cond_b2
    if-eqz v0, :cond_b7

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 416
    :cond_b7
    return-object v1

    .line 423
    :catchall_b8
    move-exception v1

    goto :goto_e1

    .line 417
    :cond_ba
    nop

    .line 418
    :try_start_bb
    invoke-static {v2, v0}, Landroid/provider/DocumentsContract;->deleteDocument(Landroid/content/ContentResolver;Landroid/net/Uri;)Z

    move-result p1

    if-nez p1, :cond_ca

    .line 419
    const-string p1, "\u8be5\u76ee\u5f55\u4e0d\u652f\u6301\u5220\u9664\u65e7\u5907\u4efd\u7248\u672c"
    :try_end_c3
    .catchall {:try_start_bb .. :try_end_c3} :catchall_cf

    .line 426
    nop

    .line 427
    if-eqz v0, :cond_c9

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 419
    :cond_c9
    return-object p1

    .line 421
    :cond_ca
    nop

    .line 422
    nop

    .line 426
    nop

    .line 427
    nop

    .line 422
    return-object v1

    .line 423
    :catchall_cf
    move-exception p1

    goto :goto_e5

    .line 410
    :cond_d1
    :goto_d1
    if-eqz v4, :cond_d6

    :try_start_d3
    invoke-virtual {v4}, Ljava/io/InputStream;->close()V

    .line 411
    :cond_d6
    const-string v0, "\u8be5\u76ee\u5f55\u4e0d\u652f\u6301\u53ef\u9760\u8bfb\u53d6\u5907\u4efd\u6587\u4ef6"
    :try_end_d8
    .catchall {:try_start_d3 .. :try_end_d8} :catchall_df

    .line 426
    if-eqz p1, :cond_dd

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 427
    :cond_dd
    nop

    .line 411
    return-object v0

    .line 423
    :catchall_df
    move-exception v0

    move-object v0, v1

    :goto_e1
    move-object v1, p1

    goto :goto_e5

    :catchall_e3
    move-exception p1

    move-object v0, v1

    .line 424
    :goto_e5
    :try_start_e5
    const-string p1, "\u8be5\u672c\u5730\u76ee\u5f55\u4e0d\u652f\u6301\u5b89\u5168\u81ea\u52a8\u5907\u4efd"
    :try_end_e7
    .catchall {:try_start_e5 .. :try_end_e7} :catchall_f2

    .line 426
    if-eqz v1, :cond_ec

    invoke-static {p0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 427
    :cond_ec
    if-eqz v0, :cond_f1

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 424
    :cond_f1
    return-object p1

    .line 426
    :catchall_f2
    move-exception p1

    if-eqz v1, :cond_f8

    invoke-static {p0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 427
    :cond_f8
    if-eqz v0, :cond_fd

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V

    .line 428
    :cond_fd
    throw p1

    :array_fe
    .array-data 1
        0x47t
        0x50t
        0x49t
    .end array-data
.end method

.method static validateTreeAsync(Landroid/content/Context;Landroid/net/Uri;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ValidationCallback;)V
    .registers 5

    .line 379
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    .line 380
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->IO:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4;

    invoke-direct {v1, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4;-><init>(Landroid/content/Context;Landroid/net/Uri;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ValidationCallback;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 390
    return-void
.end method
