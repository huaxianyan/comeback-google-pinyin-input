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

    .line 225
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    iput-boolean p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->val$success:Z

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 6

    .line 227
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->val$success:Z

    if-nez v0, :cond_4f

    .line 228
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    # getter for: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->context:Landroid/content/Context;
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->access$200(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)Landroid/content/Context;

    move-result-object v0

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    # getter for: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->partial:Landroid/net/Uri;
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->access$300(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)Landroid/net/Uri;

    move-result-object v1

    # invokes: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->deleteQuietly(Landroid/content/Context;Landroid/net/Uri;)V
    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->access$400(Landroid/content/Context;Landroid/net/Uri;)V

    .line 229
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    # getter for: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->context:Landroid/content/Context;
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->access$200(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)Landroid/content/Context;

    move-result-object v0

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    # getter for: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->force:Z
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->access$500(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)Z

    move-result v1

    .line 230
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    # getter for: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->taskError:I
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->access$600(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)I

    move-result v2

    if-nez v2, :cond_2a

    const-string v2, "\u539f\u751f\u7528\u6237\u8bcd\u5178\u5bfc\u51fa\u5931\u8d25"

    goto :goto_49

    .line 231
    :cond_2a
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\u539f\u751f\u7528\u6237\u8bcd\u5178\u5bfc\u51fa\u5931\u8d25\uff08"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    # getter for: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->taskError:I
    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->access$600(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)I

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "\uff09"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    :goto_49
    nop

    .line 229
    const/4 v3, 0x0

    # invokes: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finishFailure(Landroid/content/Context;ZLjava/lang/String;Ljava/lang/Throwable;)V
    invoke-static {v0, v1, v2, v3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->access$700(Landroid/content/Context;ZLjava/lang/String;Ljava/lang/Throwable;)V

    .line 232
    return-void

    .line 234
    :cond_4f
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    # getter for: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->context:Landroid/content/Context;
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->access$200(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)Landroid/content/Context;

    move-result-object v0

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    # getter for: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->tree:Landroid/net/Uri;
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->access$800(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)Landroid/net/Uri;

    move-result-object v1

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    # getter for: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->partial:Landroid/net/Uri;
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->access$300(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)Landroid/net/Uri;

    move-result-object v2

    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    # getter for: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->finalName:Ljava/lang/String;
    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->access$900(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)Ljava/lang/String;

    move-result-object v3

    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;

    # getter for: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->force:Z
    invoke-static {v4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;->access$500(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportListener;)Z

    move-result v4

    # invokes: Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->finalizeExport(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V
    invoke-static {v0, v1, v2, v3, v4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->access$1000(Landroid/content/Context;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;Z)V

    .line 235
    return-void
.end method
