.class Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$5;
.super Ljava/lang/Object;
.source "LocalBackupImportActivity.java"

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


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

.field final synthetic val$entries:Ljava/util/List;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;Ljava/util/List;)V
    .registers 3

    .line 53
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$5;->this$0:Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$5;->val$entries:Ljava/util/List;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/content/DialogInterface;I)V
    .registers 5

    .line 55
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$5;->this$0:Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$5;->val$entries:Ljava/util/List;

    invoke-interface {v0, p2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;->uri:Landroid/net/Uri;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$5;->val$entries:Ljava/util/List;

    invoke-interface {v1, p2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;

    iget-object p2, p2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;->name:Ljava/lang/String;

    # invokes: Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;->confirm(Landroid/net/Uri;Ljava/lang/String;)V
    invoke-static {p1, v0, p2}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;->access$000(Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;Landroid/net/Uri;Ljava/lang/String;)V

    .line 56
    return-void
.end method
