.class public final Lcom/google/android/inputmethod/pinyin/DictionaryRecoveryCompat;
.super Ljava/lang/Object;
.source "DictionaryRecoveryCompat.java"


# direct methods
.method private constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static file(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/io/File;
    .locals 2

    invoke-static {p1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0, p2}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Landroid/content/Context;->getFileStreamPath(Ljava/lang/String;)Ljava/io/File;

    move-result-object v1

    return-object v1
.end method

.method public static prepareForLoad(Landroid/content/Context;Ljava/lang/String;)V
    .locals 4

    invoke-virtual {p0, p1}, Landroid/content/Context;->getFileStreamPath(Ljava/lang/String;)Ljava/io/File;

    move-result-object v0

    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v1

    if-nez v1, :done

    const-string v1, "_bak"

    invoke-static {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryRecoveryCompat;->file(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/io/File;

    move-result-object v1

    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v2

    if-eqz v2, :try_tmp

    invoke-virtual {v1, v0}, Ljava/io/File;->renameTo(Ljava/io/File;)Z

    move-result v2

    if-nez v2, :done

    :try_tmp
    const-string v1, "_tmp"

    invoke-static {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryRecoveryCompat;->file(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/io/File;

    move-result-object v1

    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v2

    if-eqz v2, :done

    invoke-virtual {v1, v0}, Ljava/io/File;->renameTo(Ljava/io/File;)Z

    :done
    return-void
.end method

.method public static recoverAfterLoadFailure(Landroid/content/Context;Ljava/lang/String;)Z
    .locals 6

    invoke-virtual {p0, p1}, Landroid/content/Context;->getFileStreamPath(Ljava/lang/String;)Ljava/io/File;

    move-result-object v0

    const-string v1, "_bak"

    invoke-static {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryRecoveryCompat;->file(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/io/File;

    move-result-object v1

    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v2

    if-eqz v2, :archive

    const-string v2, "_unreadable"

    invoke-static {p0, p1, v2}, Lcom/google/android/inputmethod/pinyin/DictionaryRecoveryCompat;->file(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/io/File;

    move-result-object v2

    invoke-virtual {v2}, Ljava/io/File;->exists()Z

    move-result v3

    if-nez v3, :delete_main

    invoke-virtual {v0, v2}, Ljava/io/File;->renameTo(Ljava/io/File;)Z

    goto :restore_backup

    :delete_main
    invoke-virtual {v0}, Ljava/io/File;->delete()Z

    :restore_backup
    invoke-virtual {v1, v0}, Ljava/io/File;->renameTo(Ljava/io/File;)Z

    move-result v3

    return v3

    :archive
    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v2

    if-eqz v2, :failed

    const-string v2, "_unreadable"

    invoke-static {p0, p1, v2}, Lcom/google/android/inputmethod/pinyin/DictionaryRecoveryCompat;->file(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/io/File;

    move-result-object v2

    invoke-virtual {v2}, Ljava/io/File;->exists()Z

    move-result v3

    if-nez v3, :failed

    invoke-virtual {v0, v2}, Ljava/io/File;->renameTo(Ljava/io/File;)Z

    :failed
    const/4 v0, 0x0

    return v0
.end method
