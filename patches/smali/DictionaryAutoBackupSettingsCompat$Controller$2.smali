.class Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$2;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupSettingsCompat.java"

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->confirmImport(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;

.field final synthetic val$entry:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;)V
    .registers 3

    .line 137
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$2;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$2;->val$entry:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/content/DialogInterface;I)V
    .registers 3

    .line 139
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$2;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;

    iget-object p1, p1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {p1}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object p1

    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$2;->val$entry:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;

    iget-object p2, p2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;->uri:Landroid/net/Uri;

    invoke-static {p1, p2}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;->startNativeImport(Landroid/content/Context;Landroid/net/Uri;)Z

    .line 140
    return-void
.end method
