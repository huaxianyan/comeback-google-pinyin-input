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
.field private final context:Landroid/content/Context;

.field private final finalName:Ljava/lang/String;

.field private final force:Z

.field private final partial:Landroid/net/Uri;

.field private taskError:I

.field private final tree:Landroid/net/Uri;


# direct methods
.method constructor <init>(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V
    .registers 6

    .line 212
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 213
    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p1

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->context:Landroid/content/Context;

    .line 214
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->tree:Landroid/net/Uri;

    .line 215
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->partial:Landroid/net/Uri;

    .line 216
    iput-object p4, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->finalName:Ljava/lang/String;

    .line 217
    iput-boolean p5, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->force:Z

    .line 218
    return-void
.end method

.method static synthetic access$200(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)Landroid/content/Context;
    .registers 1

    .line 204
    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->context:Landroid/content/Context;

    return-object p0
.end method

.method static synthetic access$300(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)Landroid/net/Uri;
    .registers 1

    .line 204
    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->partial:Landroid/net/Uri;

    return-object p0
.end method

.method static synthetic access$500(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)Z
    .registers 1

    .line 204
    iget-boolean p0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->force:Z

    return p0
.end method

.method static synthetic access$600(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)I
    .registers 1

    .line 204
    iget p0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->taskError:I

    return p0
.end method

.method static synthetic access$800(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)Landroid/net/Uri;
    .registers 1

    .line 204
    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->tree:Landroid/net/Uri;

    return-object p0
.end method

.method static synthetic access$900(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)Ljava/lang/String;
    .registers 1

    .line 204
    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->finalName:Ljava/lang/String;

    return-object p0
.end method


# virtual methods
.method public onTaskError(I)V
    .registers 2

    .line 222
    iput p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->taskError:I

    return-void
.end method

.method public onTaskFinished(ZLjava/lang/Object;)V
    .registers 4

    .line 225
    # getter for: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->IO:Ljava/util/concurrent/ExecutorService;
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->access$1100()Ljava/util/concurrent/ExecutorService;

    move-result-object p2

    new-instance v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;

    invoke-direct {v0, p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;-><init>(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;Z)V

    invoke-interface {p2, v0}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 237
    return-void
.end method

.method public onTaskProgress(I)V
    .registers 2

    .line 221
    return-void
.end method

.method public onTaskStart()V
    .registers 1

    .line 220
    return-void
.end method
