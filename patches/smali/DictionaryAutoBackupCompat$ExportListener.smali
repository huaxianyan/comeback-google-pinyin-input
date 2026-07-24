.class final Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupCompat.java"

# interfaces
.implements Lcom/google/android/apps/inputmethod/libs/framework/core/TaskListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "ExportListener"
.end annotation


# instance fields
.field final context:Landroid/content/Context;

.field final force:Z

.field final name:Ljava/lang/String;

.field final uri:Landroid/net/Uri;


# direct methods
.method constructor <init>(Landroid/content/Context;Landroid/net/Uri;Ljava/lang/String;Z)V
    .registers 5

    .line 144
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 145
    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p1

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->context:Landroid/content/Context;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->uri:Landroid/net/Uri;

    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->name:Ljava/lang/String;

    iput-boolean p4, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->force:Z

    .line 146
    return-void
.end method


# virtual methods
.method public onTaskError(I)V
    .registers 2

    .line 149
    return-void
.end method

.method public onTaskFinished(ZLjava/lang/Object;)V
    .registers 4

    .line 151
    # getter for: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->IO:Ljava/util/concurrent/ExecutorService;
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->access$500()Ljava/util/concurrent/ExecutorService;

    move-result-object p2

    new-instance v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;

    invoke-direct {v0, p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;-><init>(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;Z)V

    invoke-interface {p2, v0}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 155
    return-void
.end method

.method public onTaskProgress(I)V
    .registers 2

    .line 148
    return-void
.end method

.method public onTaskStart()V
    .registers 1

    .line 147
    return-void
.end method
