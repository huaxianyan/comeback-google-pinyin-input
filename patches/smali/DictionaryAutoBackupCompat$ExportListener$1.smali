.class Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->onTaskFinished(ZLjava/lang/Object;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

.field final synthetic val$success:Z


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;Z)V
    .registers 3

    .line 151
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    iput-boolean p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->val$success:Z

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 4

    .line 152
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->val$success:Z

    if-nez v0, :cond_1d

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->context:Landroid/content/Context;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    iget-object v1, v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->uri:Landroid/net/Uri;

    # invokes: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->delete(Landroid/content/Context;Landroid/net/Uri;)Z
    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->access$200(Landroid/content/Context;Landroid/net/Uri;)Z

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->context:Landroid/content/Context;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    iget-boolean v1, v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->force:Z

    const-string v2, "\u539f\u751f\u7528\u6237\u8bcd\u5178\u5bfc\u51fa\u5931\u8d25"

    # invokes: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishFailure(Landroid/content/Context;ZLjava/lang/String;)V
    invoke-static {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->access$300(Landroid/content/Context;ZLjava/lang/String;)V

    goto :goto_2c

    .line 153
    :cond_1d
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->context:Landroid/content/Context;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    iget-object v1, v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->uri:Landroid/net/Uri;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    iget-boolean v2, v2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->force:Z

    # invokes: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->publish(Landroid/content/Context;Landroid/net/Uri;Z)V
    invoke-static {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->access$400(Landroid/content/Context;Landroid/net/Uri;Z)V

    .line 154
    :goto_2c
    return-void
.end method
