.class public final Lcom/google/android/inputmethod/pinyin/firstrun/FirstRunStateCompat;
.super Ljava/lang/Object;
.source "FirstRunStateCompat.java"


# static fields
.field private static final PREFS:Ljava/lang/String; = "first_run_local_state"
.field private static final KEY_COMPLETE:Ljava/lang/String; = "guide_complete"
.field private static final KEY_DASHBOARD_PENDING:Ljava/lang/String; = "dashboard_pending"


# direct methods
.method private constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .locals 2

    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "first_run_local_state"

    const/4 p0, 0x0

    invoke-virtual {v0, v1, p0}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    return-object v0
.end method

.method public static isComplete(Landroid/content/Context;)Z
    .locals 2

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/firstrun/FirstRunStateCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "guide_complete"

    const/4 p0, 0x0

    invoke-interface {v0, v1, p0}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    return v0
.end method

.method public static complete(Landroid/content/Context;)V
    .locals 3

    # This file is not registered with BackupAgent. Commit synchronously before
    # the guide task is removed so IME startup cannot enqueue the guide again.
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/firstrun/FirstRunStateCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "guide_complete"

    const/4 v2, 0x1

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "dashboard_pending"

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    # A restored USER_SELECTED_KEYBOARD value must not bypass the original
    # first keyboard-layout chooser after this installation's guide completes.
    invoke-static {p0}, Landroid/preference/PreferenceManager;->getDefaultSharedPreferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "USER_SELECTED_KEYBOARD"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    return-void
.end method

.method public static clearRestoredSetupState(Landroid/content/Context;)V
    .locals 2

    # HAD_FIRST_RUN and USER_SELECTED_KEYBOARD describe installation-local
    # setup, not portable user settings. Other preferences remain restored.
    invoke-static {p0}, Landroid/preference/PreferenceManager;->getDefaultSharedPreferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "HAD_FIRST_RUN"

    invoke-interface {v0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "USER_SELECTED_KEYBOARD"

    invoke-interface {v0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    return-void
.end method

.method public static shouldForceDashboard(Landroid/content/Context;)Z
    .locals 3

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/firstrun/FirstRunStateCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "dashboard_pending"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    if-eqz v0, :not_pending

    invoke-static {p0}, Landroid/preference/PreferenceManager;->getDefaultSharedPreferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "USER_SELECTED_KEYBOARD"

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    if-eqz v0, :pending

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/firstrun/FirstRunStateCompat;->markDashboardHandled(Landroid/content/Context;)V

    :not_pending
    const/4 v0, 0x0

    return v0

    :pending
    const/4 v0, 0x1

    return v0
.end method

.method public static markDashboardHandled(Landroid/content/Context;)V
    .locals 2

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/firstrun/FirstRunStateCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "dashboard_pending"

    invoke-interface {v0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    return-void
.end method
