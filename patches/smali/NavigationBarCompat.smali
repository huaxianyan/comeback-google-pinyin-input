.class public final Lcom/google/android/inputmethod/pinyin/NavigationBarCompat;
.super Ljava/lang/Object;
.source "NavigationBarCompat.java"


# Match Android's navigation area to the selected Google Pinyin keyboard theme.
.method public static apply(Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;)V
    .locals 8

    :try_start
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1a

    if-lt v0, v1, :done

    # The old IME always inherited a black navigation bar.  The current
    # keyboard theme key reliably identifies the built-in light/dark themes.
    const/4 v2, 0x0

    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;->getKeyboardTheme()Lcom/google/android/apps/inputmethod/libs/framework/keyboard/IKeyboardTheme;

    move-result-object v3

    if-eqz v3, :light

    invoke-interface {v3}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/IKeyboardTheme;->getViewStyleCacheKey()Ljava/lang/String;

    move-result-object v3

    if-eqz v3, :light

    sget-object v4, Ljava/util/Locale;->US:Ljava/util/Locale;

    invoke-virtual {v3, v4}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object v3

    # Additional theme names are appended after the always-dark base theme,
    # so explicit light/white markers must win over the base's "dark" text.
    const-string v4, "light"

    invoke-virtual {v3, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v4

    if-nez v4, :light

    const-string v4, "white"

    invoke-virtual {v3, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v4

    if-nez v4, :light

    const-string v4, "dark"

    invoke-virtual {v3, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v4

    if-nez v4, :dark

    const-string v4, "black"

    invoke-virtual {v3, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v4

    if-nez v4, :dark

    const-string v4, "holo_blue"

    invoke-virtual {v3, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v4

    if-nez v4, :dark

    :light
    const v2, -0x13100f    # ffec eff1: default material-light keyboard body

    const/4 v5, 0x1

    goto :set_window

    :dark
    const v2, -0xd9cdc8    # ff26 3238: default material-dark keyboard body

    const/4 v5, 0x0

    :set_window
    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;->getWindow()Landroid/app/Dialog;

    move-result-object v3

    if-eqz v3, :done

    invoke-virtual {v3}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object v3

    if-eqz v3, :done

    invoke-virtual {v3, v2}, Landroid/view/Window;->setNavigationBarColor(I)V

    invoke-virtual {v3}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v4

    invoke-virtual {v4}, Landroid/view/View;->getSystemUiVisibility()I

    move-result v6

    if-eqz v5, :dark_icons_off

    or-int/lit8 v6, v6, 0x10

    goto :set_icons

    :dark_icons_off
    and-int/lit8 v6, v6, -0x11

    :set_icons
    invoke-virtual {v4, v6}, Landroid/view/View;->setSystemUiVisibility(I)V

    const/16 v4, 0x1c

    if-lt v0, v4, :check_contrast

    invoke-virtual {v3, v2}, Landroid/view/Window;->setNavigationBarDividerColor(I)V

    :check_contrast
    const/16 v4, 0x1d

    if-lt v0, v4, :done

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/view/Window;->setNavigationBarContrastEnforced(Z)V

    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :done

    :done
    return-void
.end method
