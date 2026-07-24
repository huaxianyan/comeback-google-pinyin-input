.class Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$7;
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


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;)V
    .registers 2

    .line 71
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$7;->this$0:Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/content/DialogInterface;I)V
    .registers 3

    .line 72
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$7;->this$0:Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;->finish()V

    return-void
.end method
