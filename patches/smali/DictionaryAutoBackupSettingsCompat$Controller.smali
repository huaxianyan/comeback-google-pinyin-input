.class final Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupSettingsCompat.java"

# interfaces
.implements Landroid/preference/Preference$OnPreferenceClickListener;
.implements Landroid/preference/Preference$OnPreferenceChangeListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "Controller"
.end annotation


# instance fields
.field enabled:Landroid/preference/TwoStatePreference;

.field fragment:Landroid/preference/PreferenceFragment;

.field importBackup:Landroid/preference/Preference;

.field interval:Landroid/preference/ListPreference;

.field location:Landroid/preference/Preference;

.field now:Landroid/preference/Preference;

.field retention:Landroid/preference/ListPreference;


# direct methods
.method constructor <init>(Landroid/preference/PreferenceFragment;)V
    .registers 2

    .line 62
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    return-void
.end method

.method static parse(Ljava/lang/Object;I)I
    .registers 2

    .line 175
    :try_start_0
    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p0
    :try_end_8
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_8} :catch_9

    return p0

    .line 176
    :catch_9
    move-exception p0

    return p1
.end method


# virtual methods
.method bind()V
    .registers 3

    .line 64
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "dictionary_auto_backup_enabled"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    check-cast v0, Landroid/preference/TwoStatePreference;

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabled:Landroid/preference/TwoStatePreference;

    .line 65
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "dictionary_auto_backup_location"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->location:Landroid/preference/Preference;

    .line 66
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "dictionary_auto_backup_interval_days"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    check-cast v0, Landroid/preference/ListPreference;

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->interval:Landroid/preference/ListPreference;

    .line 67
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "dictionary_auto_backup_retention_count"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    check-cast v0, Landroid/preference/ListPreference;

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retention:Landroid/preference/ListPreference;

    .line 68
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "dictionary_auto_backup_now"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->now:Landroid/preference/Preference;

    .line 69
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "dictionary_auto_backup_import"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importBackup:Landroid/preference/Preference;

    .line 70
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabled:Landroid/preference/TwoStatePreference;

    if-eqz v0, :cond_4b

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabled:Landroid/preference/TwoStatePreference;

    invoke-virtual {v0, p0}, Landroid/preference/TwoStatePreference;->setOnPreferenceChangeListener(Landroid/preference/Preference$OnPreferenceChangeListener;)V

    .line 71
    :cond_4b
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->interval:Landroid/preference/ListPreference;

    if-eqz v0, :cond_54

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->interval:Landroid/preference/ListPreference;

    invoke-virtual {v0, p0}, Landroid/preference/ListPreference;->setOnPreferenceChangeListener(Landroid/preference/Preference$OnPreferenceChangeListener;)V

    .line 72
    :cond_54
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retention:Landroid/preference/ListPreference;

    if-eqz v0, :cond_5d

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retention:Landroid/preference/ListPreference;

    invoke-virtual {v0, p0}, Landroid/preference/ListPreference;->setOnPreferenceChangeListener(Landroid/preference/Preference$OnPreferenceChangeListener;)V

    .line 73
    :cond_5d
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->now:Landroid/preference/Preference;

    if-eqz v0, :cond_66

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->now:Landroid/preference/Preference;

    invoke-virtual {v0, p0}, Landroid/preference/Preference;->setOnPreferenceClickListener(Landroid/preference/Preference$OnPreferenceClickListener;)V

    .line 74
    :cond_66
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importBackup:Landroid/preference/Preference;

    if-eqz v0, :cond_6f

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importBackup:Landroid/preference/Preference;

    invoke-virtual {v0, p0}, Landroid/preference/Preference;->setOnPreferenceClickListener(Landroid/preference/Preference$OnPreferenceClickListener;)V

    .line 75
    :cond_6f
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 76
    return-void
.end method

.method confirmImport(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;)V
    .registers 5

    .line 134
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v0, :cond_54

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-nez v0, :cond_d

    goto :goto_54

    .line 135
    :cond_d
    new-instance v0, Landroid/app/AlertDialog$Builder;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v1}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v1, "\u5bfc\u5165\u7528\u6237\u8bcd\u5178\u5907\u4efd"

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "\u5c06\u201c"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-object v2, p1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;->name:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "\u201d\u5408\u5e76\u5230\u5f53\u524d\u7528\u6237\u8bcd\u5178\uff1f"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 136
    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$2;

    invoke-direct {v1, p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$2;-><init>(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;)V

    .line 137
    const p1, 0x104000a

    invoke-virtual {v0, p1, v1}, Landroid/app/AlertDialog$Builder;->setPositiveButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    .line 141
    const/high16 v0, 0x1040000

    const/4 v1, 0x0

    invoke-virtual {p1, v0, v1}, Landroid/app/AlertDialog$Builder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    invoke-virtual {p1}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    .line 142
    return-void

    .line 134
    :cond_54
    :goto_54
    return-void
.end method

.method context()Landroid/content/Context;
    .registers 2

    .line 79
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v0, :cond_18

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-nez v0, :cond_d

    goto :goto_18

    .line 80
    :cond_d
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    invoke-virtual {v0}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    goto :goto_19

    .line 79
    :cond_18
    :goto_18
    const/4 v0, 0x0

    :goto_19
    return-object v0
.end method

.method destroy()V
    .registers 2

    .line 77
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabled:Landroid/preference/TwoStatePreference;

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->location:Landroid/preference/Preference;

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->interval:Landroid/preference/ListPreference;

    .line 78
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retention:Landroid/preference/ListPreference;

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->now:Landroid/preference/Preference;

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importBackup:Landroid/preference/Preference;

    return-void
.end method

.method public onPreferenceChange(Landroid/preference/Preference;Ljava/lang/Object;)Z
    .registers 8

    .line 89
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    const/4 v1, 0x0

    if-nez v0, :cond_8

    return v1

    .line 90
    :cond_8
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v2

    .line 91
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabled:Landroid/preference/TwoStatePreference;

    const/4 v4, 0x1

    if-ne p1, v3, :cond_2d

    .line 92
    sget-object p1, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {p1, p2}, Ljava/lang/Boolean;->equals(Ljava/lang/Object;)Z

    move-result p1

    .line 93
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    const-string v1, "dictionary_auto_backup_enabled"

    invoke-interface {p2, v1, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    invoke-interface {p2}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 94
    if-eqz p1, :cond_29

    invoke-static {v0, v4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->request(Landroid/content/Context;Z)V

    .line 95
    :cond_29
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refreshSoon()V

    return v4

    .line 97
    :cond_2d
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->interval:Landroid/preference/ListPreference;

    if-ne p1, v0, :cond_47

    .line 98
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    const/4 v0, 0x7

    invoke-static {p2, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->parse(Ljava/lang/Object;I)I

    move-result p2

    const-string v0, "dictionary_auto_backup_interval_days"

    invoke-interface {p1, v0, p2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 99
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refreshSoon()V

    return v4

    .line 101
    :cond_47
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retention:Landroid/preference/ListPreference;

    if-ne p1, v0, :cond_62

    .line 102
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    const/16 v0, 0xa

    invoke-static {p2, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->parse(Ljava/lang/Object;I)I

    move-result p2

    const-string v0, "dictionary_auto_backup_retention_count"

    invoke-interface {p1, v0, p2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 103
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refreshSoon()V

    return v4

    .line 105
    :cond_62
    return v1
.end method

.method public onPreferenceClick(Landroid/preference/Preference;)Z
    .registers 5

    .line 83
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    const/4 v1, 0x1

    if-nez v0, :cond_8

    return v1

    .line 84
    :cond_8
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->now:Landroid/preference/Preference;

    if-ne p1, v2, :cond_10

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->request(Landroid/content/Context;Z)V

    goto :goto_18

    .line 85
    :cond_10
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importBackup:Landroid/preference/Preference;

    if-ne p1, v0, :cond_18

    const/4 p1, 0x0

    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->openImportList(Z)V

    .line 86
    :cond_18
    :goto_18
    return v1
.end method

.method onStoragePermissionResult([I)V
    .registers 4

    .line 144
    const/4 v0, 0x1

    if-eqz p1, :cond_f

    array-length v1, p1

    if-lez v1, :cond_f

    const/4 v1, 0x0

    aget p1, p1, v1

    if-nez p1, :cond_f

    .line 145
    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->openImportList(Z)V

    goto :goto_1e

    .line 146
    :cond_f
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object p1

    if-eqz p1, :cond_1e

    const-string v1, "\u9700\u8981\u6587\u4ef6\u6743\u9650\u8bfb\u53d6\u5378\u8f7d\u524d\u4fdd\u7559\u7684\u672c\u5730\u5907\u4efd"

    invoke-static {p1, v1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    .line 147
    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 148
    :cond_1e
    :goto_1e
    return-void
.end method

.method openImportList(Z)V
    .registers 7

    .line 108
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    if-eqz v0, :cond_9e

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-nez v1, :cond_c

    goto/16 :goto_9e

    .line 109
    :cond_c
    nop

    .line 110
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->listBackups(Landroid/content/Context;)Ljava/util/List;

    move-result-object v0

    .line 111
    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v1

    const/4 v2, 0x0

    if-eqz v1, :cond_3b

    if-nez p1, :cond_3b

    sget p1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x17

    if-lt p1, v1, :cond_3b

    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    .line 112
    invoke-virtual {p1}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object p1

    const-string v1, "android.permission.WRITE_EXTERNAL_STORAGE"

    invoke-virtual {p1, v1}, Landroid/app/Activity;->checkSelfPermission(Ljava/lang/String;)I

    move-result p1

    if-eqz p1, :cond_3b

    .line 114
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const/4 v0, 0x1

    new-array v0, v0, [Ljava/lang/String;

    aput-object v1, v0, v2

    const/16 v1, 0x6b02

    invoke-virtual {p1, v0, v1}, Landroid/preference/PreferenceFragment;->requestPermissions([Ljava/lang/String;I)V

    .line 116
    return-void

    .line 118
    :cond_3b
    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result p1

    const/4 v1, 0x0

    if-eqz p1, :cond_64

    .line 119
    new-instance p1, Landroid/app/AlertDialog$Builder;

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    invoke-direct {p1, v0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v0, "\u6ca1\u6709\u53ef\u8bbf\u95ee\u7684\u672c\u5730\u5907\u4efd"

    invoke-virtual {p1, v0}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    .line 120
    const-string v0, "Documents/GooglePinyinBackup \u4e2d\u6ca1\u6709\u53ef\u5217\u51fa\u7684\u5907\u4efd\u3002\u5378\u8f7d\u91cd\u88c5\u540e\u4e5f\u53ef\u4ee5\u5728 File Geek \u4e2d\u6253\u5f00\u6216\u5206\u4eab .txt \u5230 Google \u62fc\u97f3\u3002"

    invoke-virtual {p1, v0}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    .line 121
    const v0, 0x104000a

    invoke-virtual {p1, v0, v1}, Landroid/app/AlertDialog$Builder;->setPositiveButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    invoke-virtual {p1}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    .line 122
    return-void

    .line 124
    :cond_64
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result p1

    new-array v3, p1, [Ljava/lang/String;

    .line 125
    nop

    :goto_6b
    if-ge v2, p1, :cond_7a

    invoke-interface {v0, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;

    iget-object v4, v4, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;->name:Ljava/lang/String;

    aput-object v4, v3, v2

    add-int/lit8 v2, v2, 0x1

    goto :goto_6b

    .line 126
    :cond_7a
    new-instance p1, Landroid/app/AlertDialog$Builder;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v2}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v2

    invoke-direct {p1, v2}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v2, "\u5bfc\u5165\u672c\u5730\u5907\u4efd"

    invoke-virtual {p1, v2}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    new-instance v2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$1;

    invoke-direct {v2, p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$1;-><init>(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;Ljava/util/List;)V

    .line 127
    invoke-virtual {p1, v3, v2}, Landroid/app/AlertDialog$Builder;->setItems([Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    .line 131
    const/high16 v0, 0x1040000

    invoke-virtual {p1, v0, v1}, Landroid/app/AlertDialog$Builder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    invoke-virtual {p1}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    .line 132
    return-void

    .line 108
    :cond_9e
    :goto_9e
    return-void
.end method

.method refresh()V
    .registers 13

    .line 150
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    if-nez v0, :cond_7

    return-void

    .line 151
    :cond_7
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v1

    .line 152
    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x1d

    const/4 v4, 0x1

    const/4 v5, 0x0

    if-lt v2, v3, :cond_15

    const/4 v2, 0x1

    goto :goto_16

    :cond_15
    const/4 v2, 0x0

    .line 153
    :goto_16
    const-string v3, "dictionary_auto_backup_enabled"

    invoke-interface {v1, v3, v5}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v3

    .line 154
    iget-object v6, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabled:Landroid/preference/TwoStatePreference;

    if-eqz v6, :cond_9d

    .line 155
    iget-object v6, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabled:Landroid/preference/TwoStatePreference;

    invoke-virtual {v6, v3}, Landroid/preference/TwoStatePreference;->setChecked(Z)V

    iget-object v6, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabled:Landroid/preference/TwoStatePreference;

    invoke-virtual {v6, v2}, Landroid/preference/TwoStatePreference;->setEnabled(Z)V

    .line 156
    const-string v6, "dictionary_auto_backup_last_status"

    const/4 v7, 0x0

    invoke-interface {v1, v6, v7}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    .line 157
    const-string v7, "dictionary_auto_backup_last_success_time"

    const-wide/16 v8, 0x0

    invoke-interface {v1, v7, v8, v9}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v10

    .line 158
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->isInProgress()Z

    move-result v7

    if-eqz v7, :cond_47

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabled:Landroid/preference/TwoStatePreference;

    const-string v6, "\u6b63\u5728\u751f\u6210\u672c\u5730\u5907\u4efd\u2026"

    invoke-virtual {v0, v6}, Landroid/preference/TwoStatePreference;->setSummary(Ljava/lang/CharSequence;)V

    goto :goto_9d

    .line 159
    :cond_47
    if-eqz v6, :cond_57

    const-string v7, "\u5907\u4efd\u6210\u529f"

    invoke-virtual {v7, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-nez v7, :cond_57

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabled:Landroid/preference/TwoStatePreference;

    invoke-virtual {v0, v6}, Landroid/preference/TwoStatePreference;->setSummary(Ljava/lang/CharSequence;)V

    goto :goto_9d

    .line 160
    :cond_57
    cmp-long v6, v10, v8

    if-lez v6, :cond_96

    iget-object v6, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabled:Landroid/preference/TwoStatePreference;

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "\u4e0a\u6b21\u5907\u4efd\uff1a"

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    .line 161
    invoke-static {v0}, Landroid/text/format/DateFormat;->getDateFormat(Landroid/content/Context;)Ljava/text/DateFormat;

    move-result-object v8

    invoke-static {v10, v11}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v9

    invoke-virtual {v8, v9}, Ljava/text/DateFormat;->format(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    const-string v8, " "

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    .line 162
    invoke-static {v0}, Landroid/text/format/DateFormat;->getTimeFormat(Landroid/content/Context;)Ljava/text/DateFormat;

    move-result-object v0

    invoke-static {v10, v11}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v8

    invoke-virtual {v0, v8}, Ljava/text/DateFormat;->format(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v7, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 160
    invoke-virtual {v6, v0}, Landroid/preference/TwoStatePreference;->setSummary(Ljava/lang/CharSequence;)V

    goto :goto_9d

    .line 163
    :cond_96
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabled:Landroid/preference/TwoStatePreference;

    const-string v6, "\u5907\u4efd\u6587\u4ef6\u5728\u6e05\u9664\u6570\u636e\u6216\u5378\u8f7d\u540e\u4ecd\u4f1a\u4fdd\u7559"

    invoke-virtual {v0, v6}, Landroid/preference/TwoStatePreference;->setSummary(Ljava/lang/CharSequence;)V

    .line 165
    :cond_9d
    :goto_9d
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->location:Landroid/preference/Preference;

    if-eqz v0, :cond_ad

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->location:Landroid/preference/Preference;

    const-string v6, "\u5185\u90e8\u5b58\u50a8/Documents/GooglePinyinBackup"

    invoke-virtual {v0, v6}, Landroid/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->location:Landroid/preference/Preference;

    invoke-virtual {v0, v5}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 166
    :cond_ad
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->interval:Landroid/preference/ListPreference;

    if-eqz v0, :cond_cd

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->interval:Landroid/preference/ListPreference;

    const-string v6, "dictionary_auto_backup_interval_days"

    const/4 v7, 0x7

    invoke-interface {v1, v6, v7}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v6

    invoke-static {v6}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v0, v6}, Landroid/preference/ListPreference;->setValue(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->interval:Landroid/preference/ListPreference;

    if-eqz v3, :cond_c9

    if-eqz v2, :cond_c9

    const/4 v6, 0x1

    goto :goto_ca

    :cond_c9
    const/4 v6, 0x0

    :goto_ca
    invoke-virtual {v0, v6}, Landroid/preference/ListPreference;->setEnabled(Z)V

    .line 167
    :cond_cd
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retention:Landroid/preference/ListPreference;

    if-eqz v0, :cond_ee

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retention:Landroid/preference/ListPreference;

    const-string v6, "dictionary_auto_backup_retention_count"

    const/16 v7, 0xa

    invoke-interface {v1, v6, v7}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v1

    invoke-static {v1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/preference/ListPreference;->setValue(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retention:Landroid/preference/ListPreference;

    if-eqz v3, :cond_ea

    if-eqz v2, :cond_ea

    const/4 v1, 0x1

    goto :goto_eb

    :cond_ea
    const/4 v1, 0x0

    :goto_eb
    invoke-virtual {v0, v1}, Landroid/preference/ListPreference;->setEnabled(Z)V

    .line 168
    :cond_ee
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->now:Landroid/preference/Preference;

    if-eqz v0, :cond_108

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->now:Landroid/preference/Preference;

    if-eqz v2, :cond_fd

    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->isInProgress()Z

    move-result v1

    if-nez v1, :cond_fd

    goto :goto_fe

    :cond_fd
    const/4 v4, 0x0

    :goto_fe
    invoke-virtual {v0, v4}, Landroid/preference/Preference;->setEnabled(Z)V

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->now:Landroid/preference/Preference;

    const-string v1, "\u7acb\u5373\u5bfc\u51fa\u5230\u56fa\u5b9a\u672c\u5730\u76ee\u5f55"

    invoke-virtual {v0, v1}, Landroid/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    .line 169
    :cond_108
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importBackup:Landroid/preference/Preference;

    if-eqz v0, :cond_113

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importBackup:Landroid/preference/Preference;

    const-string v1, "\u5217\u51fa\u56fa\u5b9a\u76ee\u5f55\u4e2d\u7684\u672c\u5730\u5907\u4efd\uff1b\u4e5f\u53ef\u4ece\u6587\u4ef6\u7ba1\u7406\u5668\u6253\u5f00\u5907\u4efd"

    invoke-virtual {v0, v1}, Landroid/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    .line 170
    :cond_113
    return-void
.end method

.method refreshSoon()V
    .registers 3

    .line 171
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v0, :cond_22

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_22

    .line 172
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    invoke-virtual {v0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$3;

    invoke-direct {v1, p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$3;-><init>(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;)V

    invoke-virtual {v0, v1}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    .line 174
    :cond_22
    return-void
.end method
