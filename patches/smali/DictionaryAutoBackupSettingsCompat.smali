.class public final Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupSettingsCompat.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;
    }
.end annotation


# static fields
.field private static final CONTROLLERS:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Landroid/preference/PreferenceFragment;",
            "Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;",
            ">;"
        }
    .end annotation
.end field

.field private static final KEY_BACKUP_NOW:Ljava/lang/String; = "dictionary_auto_backup_now"

.field private static final KEY_LOCATION:Ljava/lang/String; = "dictionary_auto_backup_location"

.field private static final REQUEST_TREE:I = 0x6b01


# direct methods
.method static constructor <clinit>()V
    .registers 1

    .line 30
    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->CONTROLLERS:Ljava/util/Map;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 33
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static bind(Landroid/preference/PreferenceFragment;)V
    .registers 4

    .line 36
    if-eqz p0, :cond_2b

    invoke-virtual {p0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-nez v0, :cond_9

    goto :goto_2b

    .line 37
    :cond_9
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->CONTROLLERS:Ljava/util/Map;

    monitor-enter v0

    .line 38
    :try_start_c
    sget-object v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->CONTROLLERS:Ljava/util/Map;

    invoke-interface {v1, p0}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;

    .line 39
    if-eqz v1, :cond_19

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->destroy()V

    .line 40
    :cond_19
    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;

    invoke-direct {v1, p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;-><init>(Landroid/preference/PreferenceFragment;)V

    .line 41
    sget-object v2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->CONTROLLERS:Ljava/util/Map;

    invoke-interface {v2, p0, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 42
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->bind()V

    .line 43
    monitor-exit v0

    .line 44
    return-void

    .line 43
    :catchall_28
    move-exception p0

    monitor-exit v0
    :try_end_2a
    .catchall {:try_start_c .. :try_end_2a} :catchall_28

    throw p0

    .line 36
    :cond_2b
    :goto_2b
    return-void
.end method

.method public static handleActivityResult(Landroid/preference/PreferenceFragment;IILandroid/content/Intent;)Z
    .registers 5

    .line 48
    const/16 v0, 0x6b01

    if-eq p1, v0, :cond_6

    const/4 p0, 0x0

    return p0

    .line 50
    :cond_6
    sget-object p1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->CONTROLLERS:Ljava/util/Map;

    monitor-enter p1

    :try_start_9
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->CONTROLLERS:Ljava/util/Map;

    invoke-interface {v0, p0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;

    monitor-exit p1
    :try_end_12
    .catchall {:try_start_9 .. :try_end_12} :catchall_19

    .line 51
    if-eqz p0, :cond_17

    invoke-virtual {p0, p2, p3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->onTreeResult(ILandroid/content/Intent;)V

    .line 52
    :cond_17
    const/4 p0, 0x1

    return p0

    .line 50
    :catchall_19
    move-exception p0

    :try_start_1a
    monitor-exit p1
    :try_end_1b
    .catchall {:try_start_1a .. :try_end_1b} :catchall_19

    throw p0
.end method

.method public static refresh(Landroid/preference/PreferenceFragment;)V
    .registers 3

    .line 57
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->CONTROLLERS:Ljava/util/Map;

    monitor-enter v0

    :try_start_3
    sget-object v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->CONTROLLERS:Ljava/util/Map;

    invoke-interface {v1, p0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;

    monitor-exit v0
    :try_end_c
    .catchall {:try_start_3 .. :try_end_c} :catchall_12

    .line 58
    if-eqz p0, :cond_11

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 59
    :cond_11
    return-void

    .line 57
    :catchall_12
    move-exception p0

    :try_start_13
    monitor-exit v0
    :try_end_14
    .catchall {:try_start_13 .. :try_end_14} :catchall_12

    throw p0
.end method

.method static refreshAll()V
    .registers 3

    .line 70
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->CONTROLLERS:Ljava/util/Map;

    monitor-enter v0

    .line 71
    :try_start_3
    new-instance v1, Ljava/util/ArrayList;

    sget-object v2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->CONTROLLERS:Ljava/util/Map;

    invoke-interface {v2}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    .line 72
    monitor-exit v0
    :try_end_f
    .catchall {:try_start_3 .. :try_end_f} :catchall_24

    .line 73
    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_13
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_23

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    goto :goto_13

    .line 74
    :cond_23
    return-void

    .line 72
    :catchall_24
    move-exception v1

    :try_start_25
    monitor-exit v0
    :try_end_26
    .catchall {:try_start_25 .. :try_end_26} :catchall_24

    goto :goto_28

    :goto_27
    throw v1

    :goto_28
    goto :goto_27
.end method

.method public static unbind(Landroid/preference/PreferenceFragment;)V
    .registers 3

    .line 62
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->CONTROLLERS:Ljava/util/Map;

    monitor-enter v0

    .line 63
    :try_start_3
    sget-object v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->CONTROLLERS:Ljava/util/Map;

    invoke-interface {v1, p0}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;

    .line 64
    if-eqz p0, :cond_10

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->destroy()V

    .line 65
    :cond_10
    monitor-exit v0

    .line 66
    return-void

    .line 65
    :catchall_12
    move-exception p0

    monitor-exit v0
    :try_end_14
    .catchall {:try_start_3 .. :try_end_14} :catchall_12

    throw p0
.end method
