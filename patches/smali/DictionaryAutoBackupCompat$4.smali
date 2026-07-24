.class Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->validateTreeAsync(Landroid/content/Context;Landroid/net/Uri;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ValidationCallback;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$callback:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ValidationCallback;

.field final synthetic val$context:Landroid/content/Context;

.field final synthetic val$tree:Landroid/net/Uri;


# direct methods
.method constructor <init>(Landroid/content/Context;Landroid/net/Uri;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ValidationCallback;)V
    .registers 4

    .line 380
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4;->val$context:Landroid/content/Context;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4;->val$tree:Landroid/net/Uri;

    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4;->val$callback:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ValidationCallback;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 4

    .line 382
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4;->val$context:Landroid/content/Context;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4;->val$tree:Landroid/net/Uri;

    # invokes: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->validateTree(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;
    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->access$1200(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;

    move-result-object v0

    .line 383
    # getter for: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->MAIN:Landroid/os/Handler;
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->access$1300()Landroid/os/Handler;

    move-result-object v1

    new-instance v2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4$1;

    invoke-direct {v2, p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4$1;-><init>(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4;Ljava/lang/String;)V

    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 388
    return-void
.end method
