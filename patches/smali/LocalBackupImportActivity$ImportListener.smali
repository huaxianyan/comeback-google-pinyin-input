.class final Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$ImportListener;
.super Ljava/lang/Object;
.source "LocalBackupImportActivity.java"

# interfaces
.implements Lcom/google/android/apps/inputmethod/libs/framework/core/TaskListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "ImportListener"
.end annotation


# instance fields
.field final context:Landroid/content/Context;


# direct methods
.method constructor <init>(Landroid/content/Context;)V
    .registers 2

    .line 97
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$ImportListener;->context:Landroid/content/Context;

    return-void
.end method


# virtual methods
.method public onTaskError(I)V
    .registers 2

    .line 100
    return-void
.end method

.method public onTaskFinished(ZLjava/lang/Object;)V
    .registers 4

    .line 102
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$ImportListener;->context:Landroid/content/Context;

    if-eqz p1, :cond_7

    const-string p1, "\u672c\u5730\u7528\u6237\u8bcd\u5178\u5907\u4efd\u5bfc\u5165\u6210\u529f"

    goto :goto_9

    :cond_7
    const-string p1, "\u672c\u5730\u7528\u6237\u8bcd\u5178\u5907\u4efd\u5bfc\u5165\u5931\u8d25"

    :goto_9
    const/4 v0, 0x1

    invoke-static {p2, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    .line 103
    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 104
    return-void
.end method

.method public onTaskProgress(I)V
    .registers 2

    .line 99
    return-void
.end method

.method public onTaskStart()V
    .registers 1

    .line 98
    return-void
.end method
