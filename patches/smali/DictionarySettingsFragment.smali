.class public Lcom/google/android/apps/inputmethod/pinyin/preference/DictionarySettingsFragment;
.super Lado;
.source "PG"


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    invoke-direct {p0}, Lado;-><init>()V

    return-void
.end method


# virtual methods
.method protected final a()Lcom/google/android/apps/inputmethod/libs/dataservice/preference/AbstractDictionarySettings;
    .locals 1

    .prologue
    new-instance v0, Lbee;

    invoke-direct {v0}, Lbee;-><init>()V

    return-object v0
.end method

.method public onCreate(Landroid/os/Bundle;)V
    .locals 0

    invoke-super {p0, p1}, Lado;->onCreate(Landroid/os/Bundle;)V

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->bind(Landroid/preference/PreferenceFragment;)V

    return-void
.end method

.method public onActivityResult(IILandroid/content/Intent;)V
    .locals 1

    invoke-static {p0, p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->handleActivityResult(Landroid/preference/PreferenceFragment;IILandroid/content/Intent;)Z

    move-result v0

    if-nez v0, :handled

    invoke-super {p0, p1, p2, p3}, Lado;->onActivityResult(IILandroid/content/Intent;)V

    :handled
    return-void
.end method

.method public onRequestPermissionsResult(I[Ljava/lang/String;[I)V
    .locals 1

    invoke-static {p0, p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->handleRequestPermissionsResult(Landroid/preference/PreferenceFragment;I[Ljava/lang/String;[I)Z

    move-result v0

    if-nez v0, :permission_handled

    invoke-super {p0, p1, p2, p3}, Lado;->onRequestPermissionsResult(I[Ljava/lang/String;[I)V

    :permission_handled
    return-void
.end method

.method public onResume()V
    .locals 0

    invoke-super {p0}, Lado;->onResume()V

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->refresh(Landroid/preference/PreferenceFragment;)V

    return-void
.end method

.method public onDestroy()V
    .locals 0

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->unbind(Landroid/preference/PreferenceFragment;)V

    invoke-super {p0}, Lado;->onDestroy()V

    return-void
.end method
