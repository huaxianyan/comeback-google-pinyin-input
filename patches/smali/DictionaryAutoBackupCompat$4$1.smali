.class Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4$1;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4;->run()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4;

.field final synthetic val$error:Ljava/lang/String;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4;Ljava/lang/String;)V
    .registers 3

    .line 383
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4$1;->val$error:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 4

    .line 385
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4;->val$callback:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ValidationCallback;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4;

    iget-object v1, v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4;->val$tree:Landroid/net/Uri;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$4$1;->val$error:Ljava/lang/String;

    invoke-interface {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ValidationCallback;->onValidationFinished(Landroid/net/Uri;Ljava/lang/String;)V

    .line 386
    return-void
.end method
