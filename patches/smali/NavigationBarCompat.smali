.class public final Lcom/google/android/inputmethod/pinyin/NavigationBarCompat;
.super Ljava/lang/Object;
.source "NavigationBarCompat.java"


# Read the final color from the drawable after the keyboard stylesheet has
# been applied. This mirrors Gboard's use of the active keyboard surface token
# and avoids guessing from a theme package name.
.method private static colorFromDrawable(Landroid/graphics/drawable/Drawable;)I
    .locals 4

    const/4 v0, 0x0

    if-eqz p0, :done

    # Google Pinyin's stylesheet does not mutate the XML GradientDrawable.
    # It wraps the drawable in bam and stores the final themed tint in a
    # public ColorStateList. Read that value before inspecting Android types.
    instance-of v1, p0, Lbam;

    if-eqz v1, :color_drawable

    move-object v1, p0

    check-cast v1, Lbam;

    iget-object v1, v1, Lbam;->a:Landroid/content/res/ColorStateList;

    invoke-virtual {v1}, Landroid/content/res/ColorStateList;->getDefaultColor()I

    move-result v2

    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->getState()[I

    move-result-object v3

    invoke-virtual {v1, v3, v2}, Landroid/content/res/ColorStateList;->getColorForState([II)I

    move-result v0

    return v0

    :color_drawable
    instance-of v1, p0, Landroid/graphics/drawable/ColorDrawable;

    if-eqz v1, :gradient

    check-cast p0, Landroid/graphics/drawable/ColorDrawable;

    invoke-virtual {p0}, Landroid/graphics/drawable/ColorDrawable;->getColor()I

    move-result v0

    return v0

    :gradient
    instance-of v1, p0, Landroid/graphics/drawable/GradientDrawable;

    if-eqz v1, :layer

    check-cast p0, Landroid/graphics/drawable/GradientDrawable;

    invoke-virtual {p0}, Landroid/graphics/drawable/GradientDrawable;->getColor()Landroid/content/res/ColorStateList;

    move-result-object v1

    if-eqz v1, :done

    invoke-virtual {v1}, Landroid/content/res/ColorStateList;->getDefaultColor()I

    move-result v0

    return v0

    :layer
    instance-of v1, p0, Landroid/graphics/drawable/LayerDrawable;

    if-eqz v1, :container

    check-cast p0, Landroid/graphics/drawable/LayerDrawable;

    invoke-virtual {p0}, Landroid/graphics/drawable/LayerDrawable;->getNumberOfLayers()I

    move-result v1

    add-int/lit8 v1, v1, -0x1

    :layer_loop
    if-ltz v1, :done

    invoke-virtual {p0, v1}, Landroid/graphics/drawable/LayerDrawable;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v2

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/NavigationBarCompat;->colorFromDrawable(Landroid/graphics/drawable/Drawable;)I

    move-result v2

    if-eqz v2, :next_layer

    return v2

    :next_layer
    add-int/lit8 v1, v1, -0x1

    goto :layer_loop

    :container
    instance-of v1, p0, Landroid/graphics/drawable/DrawableContainer;

    if-eqz v1, :done

    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->getCurrent()Landroid/graphics/drawable/Drawable;

    move-result-object v1

    if-eq v1, p0, :done

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/NavigationBarCompat;->colorFromDrawable(Landroid/graphics/drawable/Drawable;)I

    move-result v0

    :done
    return v0
.end method

.method private static readKeyboardSurfaceColor(Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;)I
    .locals 4

    const/4 v0, 0x0

    iget-object v1, p0, Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;->a:Lcom/google/android/apps/inputmethod/libs/framework/core/InputView;

    if-eqz v1, :done

    # Prefer the currently rendered body surface. It already includes built-in,
    # additional-color and bordered stylesheet overrides.
    const v2, 0x7f0f0156

    invoke-virtual {v1, v2}, Lcom/google/android/apps/inputmethod/libs/framework/core/InputView;->findViewById(I)Landroid/view/View;

    move-result-object v2

    instance-of v3, v2, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardViewHolder;

    if-eqz v3, :keyboard_area

    check-cast v2, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardViewHolder;

    iget-object v2, v2, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardViewHolder;->a:Landroid/view/View;

    if-eqz v2, :keyboard_area

    invoke-virtual {v2}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;

    move-result-object v2

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/NavigationBarCompat;->colorFromDrawable(Landroid/graphics/drawable/Drawable;)I

    move-result v0

    invoke-static {v0}, Landroid/graphics/Color;->alpha(I)I

    move-result v2

    const/16 v3, 0xff

    if-ne v2, v3, :keyboard_area

    return v0

    :keyboard_area
    # Header-only and transition states can temporarily have no body. The
    # keyboard-area background is the next best already-themed surface.
    const v2, 0x7f0f0153

    invoke-virtual {v1, v2}, Lcom/google/android/apps/inputmethod/libs/framework/core/InputView;->findViewById(I)Landroid/view/View;

    move-result-object v1

    if-eqz v1, :invalid

    invoke-virtual {v1}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;

    move-result-object v1

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/NavigationBarCompat;->colorFromDrawable(Landroid/graphics/drawable/Drawable;)I

    move-result v0

    invoke-static {v0}, Landroid/graphics/Color;->alpha(I)I

    move-result v1

    const/16 v2, 0xff

    if-ne v1, v2, :invalid

    return v0

    :invalid
    const/4 v0, 0x0

    :done
    return v0
.end method

.method private static isLightColor(I)Z
    .locals 4

    invoke-static {p0}, Landroid/graphics/Color;->red(I)I

    move-result v0

    mul-int/lit16 v0, v0, 0x12b

    invoke-static {p0}, Landroid/graphics/Color;->green(I)I

    move-result v1

    mul-int/lit16 v1, v1, 0x24b

    add-int/2addr v0, v1

    invoke-static {p0}, Landroid/graphics/Color;->blue(I)I

    move-result v1

    mul-int/lit8 v1, v1, 0x72

    add-int/2addr v0, v1

    const v1, 0x1f400

    if-lt v0, v1, :dark

    const/4 v0, 0x1

    return v0

    :dark
    const/4 v0, 0x0

    return v0
.end method

# Match Android's navigation area to the selected Google Pinyin keyboard theme.
.method public static apply(Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;)V
    .locals 8

    :try_start
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1a

    if-lt v0, v1, :done

    # Prefer the final rendered keyboard surface. Theme-name classification is
    # retained only as a fallback for very early lifecycle states.
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/NavigationBarCompat;->readKeyboardSurfaceColor(Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;)I

    move-result v2

    if-eqz v2, :theme_name_fallback

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/NavigationBarCompat;->isLightColor(I)Z

    move-result v5

    goto :set_window

    :theme_name_fallback
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
