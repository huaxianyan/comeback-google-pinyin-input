.class Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$1;
.super Ljava/lang/Object;
.source "LocalBackupImportActivity.java"

# interfaces
.implements Landroid/content/DialogInterface$OnCancelListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;->showBackups()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;)V
    .registers 2

    .line 45
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$1;->this$0:Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onCancel(Landroid/content/DialogInterface;)V
    .registers 2

    .line 46
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$1;->this$0:Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;->finish()V

    return-void
.end method
