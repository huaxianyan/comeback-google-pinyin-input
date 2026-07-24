.class Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$5;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishFailure(Landroid/content/Context;ZLjava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$c:Landroid/content/Context;

.field final synthetic val$force:Z

.field final synthetic val$message:Ljava/lang/String;


# direct methods
.method constructor <init>(ZLandroid/content/Context;Ljava/lang/String;)V
    .registers 4

    .line 271
    iput-boolean p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$5;->val$force:Z

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$5;->val$c:Landroid/content/Context;

    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$5;->val$message:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    .line 272
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->refreshAll()V

    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$5;->val$force:Z

    if-eqz v0, :cond_e

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$5;->val$c:Landroid/content/Context;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$5;->val$message:Ljava/lang/String;

    # invokes: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->toast(Landroid/content/Context;Ljava/lang/String;)V
    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->access$600(Landroid/content/Context;Ljava/lang/String;)V

    .line 273
    :cond_e
    return-void
.end method
