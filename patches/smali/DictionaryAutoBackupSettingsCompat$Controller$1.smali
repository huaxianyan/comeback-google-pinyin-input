.class Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$1;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupSettingsCompat.java"

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->openImportList(Z)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;

.field final synthetic val$entries:Ljava/util/List;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;Ljava/util/List;)V
    .registers 3

    .line 127
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$1;->val$entries:Ljava/util/List;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/content/DialogInterface;I)V
    .registers 4

    .line 129
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$1;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$1;->val$entries:Ljava/util/List;

    invoke-interface {v0, p2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;

    invoke-virtual {p1, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->confirmImport(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;)V

    .line 130
    return-void
.end method
