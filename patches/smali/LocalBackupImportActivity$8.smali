.class Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$8;
.super Ljava/lang/Object;
.source "LocalBackupImportActivity.java"

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;->confirm(Landroid/net/Uri;Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;

.field final synthetic val$uri:Landroid/net/Uri;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;Landroid/net/Uri;)V
    .registers 3

    .line 67
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$8;->this$0:Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$8;->val$uri:Landroid/net/Uri;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/content/DialogInterface;I)V
    .registers 3

    .line 69
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$8;->this$0:Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;

    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$8;->val$uri:Landroid/net/Uri;

    invoke-static {p1, p2}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;->startNativeImport(Landroid/content/Context;Landroid/net/Uri;)Z

    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$8;->this$0:Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;->finish()V

    .line 70
    return-void
.end method
