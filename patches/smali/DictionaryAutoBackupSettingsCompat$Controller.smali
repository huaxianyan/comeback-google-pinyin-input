.class final Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupSettingsCompat.java"

# interfaces
.implements Landroid/preference/Preference$OnPreferenceClickListener;
.implements Landroid/preference/Preference$OnPreferenceChangeListener;
.implements Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ValidationCallback;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "Controller"
.end annotation


# instance fields
.field private backupNowPreference:Landroid/preference/Preference;

.field private enableAfterPick:Z

.field private enabledPreference:Landroid/preference/TwoStatePreference;

.field private fragment:Landroid/preference/PreferenceFragment;

.field private intervalPreference:Landroid/preference/ListPreference;

.field private locationPreference:Landroid/preference/Preference;

.field private pendingTree:Landroid/net/Uri;

.field private retentionPreference:Landroid/preference/ListPreference;

.field private validating:Z


# direct methods
.method constructor <init>(Landroid/preference/PreferenceFragment;)V
    .registers 2

    .line 89
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    return-void
.end method

.method private static configuredTree(Landroid/content/SharedPreferences;)Landroid/net/Uri;
    .registers 3

    .line 359
    const-string v0, "dictionary_auto_backup_tree_uri"

    const/4 v1, 0x0

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 360
    if-eqz p0, :cond_17

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    if-nez v0, :cond_10

    goto :goto_17

    .line 361
    :cond_10
    :try_start_10
    invoke-static {p0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p0
    :try_end_14
    .catch Ljava/lang/RuntimeException; {:try_start_10 .. :try_end_14} :catch_15

    return-object p0

    .line 362
    :catch_15
    move-exception p0

    return-object v1

    .line 360
    :cond_17
    :goto_17
    return-object v1
.end method

.method private context()Landroid/content/Context;
    .registers 2

    .line 121
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v0, :cond_18

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-nez v0, :cond_d

    goto :goto_18

    .line 122
    :cond_d
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    invoke-virtual {v0}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    goto :goto_19

    .line 121
    :cond_18
    :goto_18
    const/4 v0, 0x0

    :goto_19
    return-object v0
.end method

.method private openTreePicker(Z)V
    .registers 5

    .line 178
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v0, :cond_5a

    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->validating:Z

    if-eqz v0, :cond_9

    goto :goto_5a

    .line 179
    :cond_9
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    const/4 v2, 0x0

    if-ge v0, v1, :cond_20

    .line 180
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {p1}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object p1

    const-string v0, "\u672c\u5730\u81ea\u52a8\u5907\u4efd\u9700\u8981 Android 5.0 \u6216\u66f4\u9ad8\u7248\u672c"

    invoke-static {p1, v0, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    .line 181
    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 182
    return-void

    .line 184
    :cond_20
    iput-boolean p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enableAfterPick:Z

    .line 185
    new-instance p1, Landroid/content/Intent;

    const-string v0, "android.intent.action.OPEN_DOCUMENT_TREE"

    invoke-direct {p1, v0}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 191
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1a

    if-lt v0, v1, :cond_3c

    .line 192
    const-string v0, "com.android.externalstorage.documents"

    const-string v1, "primary:Documents"

    invoke-static {v0, v1}, Landroid/provider/DocumentsContract;->buildDocumentUri(Ljava/lang/String;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    .line 195
    const-string v1, "android.provider.extra.INITIAL_URI"

    invoke-virtual {p1, v1, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Landroid/os/Parcelable;)Landroid/content/Intent;

    .line 197
    :cond_3c
    const/16 v0, 0xc3

    invoke-virtual {p1, v0}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 202
    :try_start_41
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const/16 v1, 0x6b01

    invoke-virtual {v0, p1, v1}, Landroid/preference/PreferenceFragment;->startActivityForResult(Landroid/content/Intent;I)V
    :try_end_48
    .catch Ljava/lang/RuntimeException; {:try_start_41 .. :try_end_48} :catch_49

    .line 206
    goto :goto_59

    .line 203
    :catch_49
    move-exception p1

    .line 204
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {p1}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object p1

    const-string v0, "\u65e0\u6cd5\u6253\u5f00\u672c\u5730\u76ee\u5f55\u9009\u62e9\u5668"

    invoke-static {p1, v0, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    .line 205
    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 207
    :goto_59
    return-void

    .line 178
    :cond_5a
    :goto_5a
    return-void
.end method

.method private static parseInt(Ljava/lang/Object;I)I
    .registers 2

    .line 366
    :try_start_0
    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p0
    :try_end_8
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_8} :catch_9

    return p0

    .line 367
    :catch_9
    move-exception p0

    return p1
.end method

.method private static queryDisplayName(Landroid/content/ContentResolver;Landroid/net/Uri;)Ljava/lang/String;
    .registers 11

    .line 371
    nop

    .line 373
    const/4 v1, 0x0

    const/4 v0, 0x1

    :try_start_3
    new-array v4, v0, [Ljava/lang/String;

    const-string v0, "_display_name"

    const/4 v8, 0x0

    aput-object v0, v4, v8

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v5, 0x0

    move-object v2, p0

    move-object v3, p1

    invoke-virtual/range {v2 .. v7}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v1

    .line 375
    if-eqz v1, :cond_2d

    invoke-interface {v1}, Landroid/database/Cursor;->moveToFirst()Z

    move-result p0

    if-eqz p0, :cond_2d

    .line 376
    invoke-interface {v1, v8}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object p0

    .line 377
    if-eqz p0, :cond_2d

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p1
    :try_end_25
    .catch Ljava/lang/RuntimeException; {:try_start_3 .. :try_end_25} :catch_33
    .catchall {:try_start_3 .. :try_end_25} :catchall_30

    if-lez p1, :cond_2d

    .line 381
    if-eqz v1, :cond_2c

    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 377
    :cond_2c
    return-object p0

    .line 381
    :cond_2d
    if-eqz v1, :cond_40

    goto :goto_3d

    :catchall_30
    move-exception v0

    move-object p0, v0

    goto :goto_35

    .line 379
    :catch_33
    move-exception v0

    goto :goto_3b

    .line 381
    :goto_35
    if-eqz v1, :cond_3a

    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 382
    :cond_3a
    throw p0

    .line 381
    :goto_3b
    if-eqz v1, :cond_40

    :goto_3d
    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 383
    :cond_40
    const-string p0, "\u8bbe\u5907\u672c\u5730\u5907\u4efd\u76ee\u5f55"

    return-object p0
.end method

.method private refreshSoon()V
    .registers 3

    .line 351
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v0, :cond_22

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_22

    .line 352
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    invoke-virtual {v0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$1;

    invoke-direct {v1, p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$1;-><init>(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;)V

    invoke-virtual {v0, v1}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    .line 356
    :cond_22
    return-void
.end method

.method private setControlsEnabled(Z)V
    .registers 3

    .line 343
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    if-eqz v0, :cond_9

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    invoke-virtual {v0, p1}, Landroid/preference/TwoStatePreference;->setEnabled(Z)V

    .line 344
    :cond_9
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_12

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    invoke-virtual {v0, p1}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 345
    :cond_12
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    if-eqz v0, :cond_1b

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    invoke-virtual {v0, p1}, Landroid/preference/ListPreference;->setEnabled(Z)V

    .line 346
    :cond_1b
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    if-eqz v0, :cond_24

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    invoke-virtual {v0, p1}, Landroid/preference/ListPreference;->setEnabled(Z)V

    .line 347
    :cond_24
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_2d

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    invoke-virtual {v0, p1}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 348
    :cond_2d
    return-void
.end method


# virtual methods
.method bind()V
    .registers 3

    .line 94
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "dictionary_auto_backup_enabled"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    check-cast v0, Landroid/preference/TwoStatePreference;

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    .line 96
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "dictionary_auto_backup_location"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    .line 97
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "dictionary_auto_backup_interval_days"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    check-cast v0, Landroid/preference/ListPreference;

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    .line 99
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "dictionary_auto_backup_retention_count"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    check-cast v0, Landroid/preference/ListPreference;

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    .line 101
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "dictionary_auto_backup_now"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    .line 103
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    if-eqz v0, :cond_41

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    invoke-virtual {v0, p0}, Landroid/preference/TwoStatePreference;->setOnPreferenceChangeListener(Landroid/preference/Preference$OnPreferenceChangeListener;)V

    .line 104
    :cond_41
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_4a

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    invoke-virtual {v0, p0}, Landroid/preference/Preference;->setOnPreferenceClickListener(Landroid/preference/Preference$OnPreferenceClickListener;)V

    .line 105
    :cond_4a
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    if-eqz v0, :cond_53

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    invoke-virtual {v0, p0}, Landroid/preference/ListPreference;->setOnPreferenceChangeListener(Landroid/preference/Preference$OnPreferenceChangeListener;)V

    .line 106
    :cond_53
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    if-eqz v0, :cond_5c

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    invoke-virtual {v0, p0}, Landroid/preference/ListPreference;->setOnPreferenceChangeListener(Landroid/preference/Preference$OnPreferenceChangeListener;)V

    .line 107
    :cond_5c
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_65

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    invoke-virtual {v0, p0}, Landroid/preference/Preference;->setOnPreferenceClickListener(Landroid/preference/Preference$OnPreferenceClickListener;)V

    .line 108
    :cond_65
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 109
    return-void
.end method

.method destroy()V
    .registers 2

    .line 112
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    .line 113
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    .line 114
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    .line 115
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    .line 116
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    .line 117
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    .line 118
    return-void
.end method

.method public onPreferenceChange(Landroid/preference/Preference;Ljava/lang/Object;)Z
    .registers 8

    .line 140
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    .line 141
    const/4 v1, 0x0

    if-nez v0, :cond_8

    return v1

    .line 142
    :cond_8
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v2

    .line 143
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    const/4 v4, 0x1

    if-ne p1, v3, :cond_4d

    .line 144
    sget-object p1, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {p1, p2}, Ljava/lang/Boolean;->equals(Ljava/lang/Object;)Z

    move-result p1

    .line 145
    const-string p2, "dictionary_auto_backup_enabled"

    if-nez p1, :cond_2a

    .line 146
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1, p2, v1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 147
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refreshSoon()V

    .line 148
    return v4

    .line 150
    :cond_2a
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->configuredTree(Landroid/content/SharedPreferences;)Landroid/net/Uri;

    move-result-object p1

    .line 151
    if-eqz p1, :cond_49

    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->hasPersistedAccess(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result p1

    if-nez p1, :cond_37

    goto :goto_49

    .line 155
    :cond_37
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1, p2, v4}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 156
    invoke-static {v0, v4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->request(Landroid/content/Context;Z)V

    .line 157
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refreshSoon()V

    .line 158
    return v4

    .line 152
    :cond_49
    :goto_49
    invoke-direct {p0, v4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->openTreePicker(Z)V

    .line 153
    return v1

    .line 160
    :cond_4d
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    if-ne p1, v0, :cond_6f

    .line 161
    const/4 p1, 0x7

    invoke-static {p2, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->parseInt(Ljava/lang/Object;I)I

    move-result p2

    .line 162
    if-lt p2, v4, :cond_5e

    const/16 v0, 0x16d

    if-le p2, v0, :cond_5d

    goto :goto_5e

    :cond_5d
    move p1, p2

    .line 163
    :cond_5e
    :goto_5e
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    const-string v0, "dictionary_auto_backup_interval_days"

    invoke-interface {p2, v0, p1}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 164
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refreshSoon()V

    .line 165
    return v4

    .line 167
    :cond_6f
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    if-ne p1, v0, :cond_92

    .line 168
    const/16 p1, 0xa

    invoke-static {p2, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->parseInt(Ljava/lang/Object;I)I

    move-result p2

    .line 169
    if-lt p2, v4, :cond_81

    const/16 v0, 0x64

    if-le p2, v0, :cond_80

    goto :goto_81

    :cond_80
    move p1, p2

    .line 170
    :cond_81
    :goto_81
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    const-string v0, "dictionary_auto_backup_retention_count"

    invoke-interface {p2, v0, p1}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 171
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refreshSoon()V

    .line 172
    return v4

    .line 174
    :cond_92
    return v1
.end method

.method public onPreferenceClick(Landroid/preference/Preference;)Z
    .registers 6

    .line 126
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    .line 127
    const/4 v1, 0x1

    if-nez v0, :cond_8

    return v1

    .line 128
    :cond_8
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    const/4 v3, 0x0

    if-ne p1, v2, :cond_11

    .line 129
    invoke-direct {p0, v3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->openTreePicker(Z)V

    .line 130
    return v1

    .line 132
    :cond_11
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    if-ne p1, v2, :cond_19

    .line 133
    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->request(Landroid/content/Context;Z)V

    .line 134
    return v1

    .line 136
    :cond_19
    return v3
.end method

.method onTreeResult(ILandroid/content/Intent;)V
    .registers 7

    .line 210
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-nez v0, :cond_5

    return-void

    .line 211
    :cond_5
    const/4 v0, -0x1

    const/4 v1, 0x0

    if-ne p1, v0, :cond_65

    if-eqz p2, :cond_65

    invoke-virtual {p2}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object p1

    if-nez p1, :cond_12

    goto :goto_65

    .line 216
    :cond_12
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object p1

    .line 217
    if-nez p1, :cond_19

    return-void

    .line 218
    :cond_19
    invoke-virtual {p2}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object v0

    .line 219
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->isLocalTree(Landroid/net/Uri;)Z

    move-result v2

    const/4 v3, 0x1

    if-nez v2, :cond_33

    .line 220
    const-string p2, "\u8bf7\u9009\u62e9\u8bbe\u5907\u5185\u90e8\u5b58\u50a8\u6216\u672c\u673a SD \u5361\u76ee\u5f55\uff0c\u4e0d\u652f\u6301\u4e91\u7aef\u4f4d\u7f6e"

    invoke-static {p1, p2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    .line 221
    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 222
    iput-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enableAfterPick:Z

    .line 223
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 224
    return-void

    .line 226
    :cond_33
    invoke-virtual {p2}, Landroid/content/Intent;->getFlags()I

    move-result p2

    and-int/lit8 p2, p2, 0x3

    .line 230
    :try_start_39
    invoke-virtual {p1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    invoke-virtual {v2, v0, p2}, Landroid/content/ContentResolver;->takePersistableUriPermission(Landroid/net/Uri;I)V
    :try_end_40
    .catch Ljava/lang/RuntimeException; {:try_start_39 .. :try_end_40} :catch_55

    .line 236
    nop

    .line 237
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pendingTree:Landroid/net/Uri;

    .line 238
    iput-boolean v3, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->validating:Z

    .line 239
    invoke-direct {p0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->setControlsEnabled(Z)V

    .line 240
    const-string p2, "\u6b63\u5728\u9a8c\u8bc1\u672c\u5730\u5907\u4efd\u76ee\u5f55\u2026"

    invoke-static {p1, p2, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p2

    invoke-virtual {p2}, Landroid/widget/Toast;->show()V

    .line 241
    invoke-static {p1, v0, p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->validateTreeAsync(Landroid/content/Context;Landroid/net/Uri;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ValidationCallback;)V

    .line 242
    return-void

    .line 231
    :catch_55
    move-exception p2

    .line 232
    const-string p2, "\u65e0\u6cd5\u4fdd\u5b58\u672c\u5730\u76ee\u5f55\u8bbf\u95ee\u6743\u9650"

    invoke-static {p1, p2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 233
    iput-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enableAfterPick:Z

    .line 234
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 235
    return-void

    .line 212
    :cond_65
    :goto_65
    iput-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enableAfterPick:Z

    .line 213
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 214
    return-void
.end method

.method public onValidationFinished(Landroid/net/Uri;Ljava/lang/String;)V
    .registers 13

    .line 245
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    .line 246
    if-nez v0, :cond_7

    return-void

    .line 247
    :cond_7
    const/4 v1, 0x0

    iput-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->validating:Z

    .line 248
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pendingTree:Landroid/net/Uri;

    if-eqz v2, :cond_a7

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pendingTree:Landroid/net/Uri;

    invoke-virtual {v2, p1}, Landroid/net/Uri;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_18

    goto/16 :goto_a7

    .line 252
    :cond_18
    const/4 v2, 0x0

    iput-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pendingTree:Landroid/net/Uri;

    .line 253
    const/4 v3, 0x3

    const/4 v4, 0x1

    if-eqz p2, :cond_36

    .line 255
    :try_start_1f
    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    invoke-virtual {v2, p1, v3}, Landroid/content/ContentResolver;->releasePersistableUriPermission(Landroid/net/Uri;I)V
    :try_end_26
    .catch Ljava/lang/RuntimeException; {:try_start_1f .. :try_end_26} :catch_27

    goto :goto_28

    .line 258
    :catch_27
    move-exception p1

    :goto_28
    nop

    .line 259
    invoke-static {v0, p2, v4}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 260
    iput-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enableAfterPick:Z

    .line 261
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 262
    return-void

    .line 265
    :cond_36
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p2

    .line 266
    const-string v5, "dictionary_auto_backup_tree_uri"

    invoke-interface {p2, v5, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 267
    const-string v6, "dictionary_auto_backup_enabled"

    invoke-interface {p2, v6, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v7

    .line 268
    iget-boolean v8, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enableAfterPick:Z

    if-nez v8, :cond_4f

    if-eqz v7, :cond_4d

    goto :goto_4f

    :cond_4d
    const/4 v7, 0x0

    goto :goto_50

    :cond_4f
    :goto_4f
    const/4 v7, 0x1

    .line 269
    :goto_50
    iput-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enableAfterPick:Z

    .line 270
    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v8

    invoke-static {v8, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->queryDisplayName(Landroid/content/ContentResolver;Landroid/net/Uri;)Ljava/lang/String;

    move-result-object v8

    .line 271
    invoke-interface {p2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    invoke-virtual {p1}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object v9

    invoke-interface {p2, v5, v9}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    .line 272
    const-string v5, "dictionary_auto_backup_tree_label"

    invoke-interface {p2, v5, v8}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    .line 273
    invoke-interface {p2, v6, v7}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    .line 274
    const-string v5, "dictionary_auto_backup_last_status"

    const-string v6, "\u672c\u5730\u76ee\u5f55\u9a8c\u8bc1\u6210\u529f"

    invoke-interface {p2, v5, v6}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    .line 275
    invoke-interface {p2}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 277
    if-eqz v2, :cond_95

    invoke-virtual {p1}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_95

    .line 279
    :try_start_87
    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p1

    invoke-static {v2}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p2

    invoke-virtual {p1, p2, v3}, Landroid/content/ContentResolver;->releasePersistableUriPermission(Landroid/net/Uri;I)V
    :try_end_92
    .catch Ljava/lang/RuntimeException; {:try_start_87 .. :try_end_92} :catch_93

    goto :goto_94

    .line 282
    :catch_93
    move-exception p1

    :goto_94
    nop

    .line 284
    :cond_95
    const-string p1, "\u672c\u5730\u5907\u4efd\u76ee\u5f55\u5df2\u8bbe\u7f6e"

    invoke-static {v0, p1, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 285
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 286
    if-eqz v7, :cond_a6

    invoke-static {v0, v4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->request(Landroid/content/Context;Z)V

    .line 287
    :cond_a6
    return-void

    .line 249
    :cond_a7
    :goto_a7
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 250
    return-void
.end method

.method refresh()V
    .registers 15

    .line 290
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    .line 291
    if-nez v0, :cond_7

    return-void

    .line 292
    :cond_7
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v1

    .line 293
    const-string v2, "dictionary_auto_backup_enabled"

    const/4 v3, 0x0

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v2

    .line 294
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->configuredTree(Landroid/content/SharedPreferences;)Landroid/net/Uri;

    move-result-object v4

    .line 295
    const/4 v5, 0x1

    if-eqz v4, :cond_21

    .line 296
    invoke-static {v0, v4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->hasPersistedAccess(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result v6

    if-eqz v6, :cond_21

    const/4 v6, 0x1

    goto :goto_22

    :cond_21
    const/4 v6, 0x0

    .line 298
    :goto_22
    iget-object v7, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    const/4 v8, 0x0

    if-eqz v7, :cond_ac

    .line 299
    iget-object v7, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    invoke-virtual {v7, v2}, Landroid/preference/TwoStatePreference;->setChecked(Z)V

    .line 300
    const-string v7, "dictionary_auto_backup_last_status"

    invoke-interface {v1, v7, v8}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    .line 301
    const-string v9, "dictionary_auto_backup_last_success_time"

    const-wide/16 v10, 0x0

    invoke-interface {v1, v9, v10, v11}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v12

    .line 302
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->isInProgress()Z

    move-result v9

    if-eqz v9, :cond_48

    .line 303
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    const-string v7, "\u6b63\u5728\u751f\u6210\u672c\u5730\u5907\u4efd\u2026"

    invoke-virtual {v0, v7}, Landroid/preference/TwoStatePreference;->setSummary(Ljava/lang/CharSequence;)V

    goto :goto_a4

    .line 304
    :cond_48
    if-eqz v7, :cond_5e

    invoke-virtual {v7}, Ljava/lang/String;->length()I

    move-result v9

    if-lez v9, :cond_5e

    const-string v9, "\u5907\u4efd\u6210\u529f"

    invoke-virtual {v9, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-nez v9, :cond_5e

    .line 305
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    invoke-virtual {v0, v7}, Landroid/preference/TwoStatePreference;->setSummary(Ljava/lang/CharSequence;)V

    goto :goto_a4

    .line 306
    :cond_5e
    cmp-long v7, v12, v10

    if-lez v7, :cond_9d

    .line 307
    invoke-static {v0}, Landroid/text/format/DateFormat;->getDateFormat(Landroid/content/Context;)Ljava/text/DateFormat;

    move-result-object v7

    .line 308
    invoke-static {v0}, Landroid/text/format/DateFormat;->getTimeFormat(Landroid/content/Context;)Ljava/text/DateFormat;

    move-result-object v0

    .line 309
    iget-object v9, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    const-string v11, "\u4e0a\u6b21\u5907\u4efd\uff1a"

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-static {v12, v13}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v11

    invoke-virtual {v7, v11}, Ljava/text/DateFormat;->format(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v10, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    const-string v10, " "

    invoke-virtual {v7, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    .line 310
    invoke-static {v12, v13}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v10

    invoke-virtual {v0, v10}, Ljava/text/DateFormat;->format(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v7, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 309
    invoke-virtual {v9, v0}, Landroid/preference/TwoStatePreference;->setSummary(Ljava/lang/CharSequence;)V

    .line 311
    goto :goto_a4

    .line 312
    :cond_9d
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    const-string v7, "\u5c1a\u672a\u751f\u6210\u672c\u5730\u5907\u4efd"

    invoke-virtual {v0, v7}, Landroid/preference/TwoStatePreference;->setSummary(Ljava/lang/CharSequence;)V

    .line 314
    :goto_a4
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    iget-boolean v7, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->validating:Z

    xor-int/2addr v7, v5

    invoke-virtual {v0, v7}, Landroid/preference/TwoStatePreference;->setEnabled(Z)V

    .line 316
    :cond_ac
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_e3

    .line 317
    const-string v0, "dictionary_auto_backup_tree_label"

    invoke-interface {v1, v0, v8}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 318
    if-nez v4, :cond_c0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    const-string v4, "\u672a\u9009\u62e9\uff08\u4ec5\u8bbe\u5907\u672c\u5730\uff09"

    invoke-virtual {v0, v4}, Landroid/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    goto :goto_db

    .line 319
    :cond_c0
    if-nez v6, :cond_ca

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    const-string v4, "\u4f4d\u7f6e\u4e0d\u53ef\u8bbf\u95ee\uff0c\u8bf7\u91cd\u65b0\u9009\u62e9"

    invoke-virtual {v0, v4}, Landroid/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    goto :goto_db

    .line 320
    :cond_ca
    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_d6

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v7

    if-nez v7, :cond_d5

    goto :goto_d6

    .line 321
    :cond_d5
    goto :goto_d8

    :cond_d6
    :goto_d6
    const-string v0, "\u5df2\u9009\u62e9\u8bbe\u5907\u672c\u5730\u76ee\u5f55"

    .line 320
    :goto_d8
    invoke-virtual {v4, v0}, Landroid/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    .line 322
    :goto_db
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    iget-boolean v4, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->validating:Z

    xor-int/2addr v4, v5

    invoke-virtual {v0, v4}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 324
    :cond_e3
    const-string v0, "dictionary_auto_backup_interval_days"

    const/4 v4, 0x7

    invoke-interface {v1, v0, v4}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    .line 325
    const-string v4, "dictionary_auto_backup_retention_count"

    const/16 v7, 0xa

    invoke-interface {v1, v4, v7}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v1

    .line 326
    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    if-eqz v4, :cond_10f

    .line 327
    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    invoke-static {v0}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Landroid/preference/ListPreference;->setValue(Ljava/lang/String;)V

    .line 328
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    if-eqz v2, :cond_10b

    if-eqz v6, :cond_10b

    iget-boolean v4, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->validating:Z

    if-nez v4, :cond_10b

    const/4 v4, 0x1

    goto :goto_10c

    :cond_10b
    const/4 v4, 0x0

    :goto_10c
    invoke-virtual {v0, v4}, Landroid/preference/ListPreference;->setEnabled(Z)V

    .line 330
    :cond_10f
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    if-eqz v0, :cond_12c

    .line 331
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    invoke-static {v1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/preference/ListPreference;->setValue(Ljava/lang/String;)V

    .line 332
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    if-eqz v2, :cond_128

    if-eqz v6, :cond_128

    iget-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->validating:Z

    if-nez v1, :cond_128

    const/4 v1, 0x1

    goto :goto_129

    :cond_128
    const/4 v1, 0x0

    :goto_129
    invoke-virtual {v0, v1}, Landroid/preference/ListPreference;->setEnabled(Z)V

    .line 334
    :cond_12c
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_150

    .line 335
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    if-eqz v6, :cond_140

    iget-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->validating:Z

    if-nez v1, :cond_140

    .line 336
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->isInProgress()Z

    move-result v1

    if-nez v1, :cond_140

    const/4 v3, 0x1

    goto :goto_141

    :cond_140
    nop

    .line 335
    :goto_141
    invoke-virtual {v0, v3}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 337
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    if-eqz v6, :cond_14b

    .line 338
    const-string v1, "\u7acb\u5373\u5bfc\u51fa\u5230\u6240\u9009\u672c\u5730\u76ee\u5f55"

    goto :goto_14d

    :cond_14b
    const-string v1, "\u8bf7\u5148\u9009\u62e9\u672c\u5730\u5907\u4efd\u4f4d\u7f6e"

    .line 337
    :goto_14d
    invoke-virtual {v0, v1}, Landroid/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    .line 340
    :cond_150
    return-void
.end method
