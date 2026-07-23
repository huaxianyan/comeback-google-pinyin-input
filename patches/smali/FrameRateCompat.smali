.class public final Lcom/google/android/inputmethod/pinyin/FrameRateCompat;
.super Ljava/lang/Object;
.source "FrameRateCompat.java"


# Android 15+ exposes the same touch-driven Window boost used by current
# Gboard. It raises refresh rate only while the user is interacting and lets
# LTPO/ARR return to an idle rate afterwards.
.method private static setTouchBoost(Landroid/view/Window;Z)V
    .locals 5

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x23

    if-lt v0, v1, :done

    const-class v0, Landroid/view/Window;

    const-string v1, "setFrameRateBoostOnTouchEnabled"

    const/4 v2, 0x1

    new-array v3, v2, [Ljava/lang/Class;

    sget-object v4, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    const/4 v2, 0x0

    aput-object v4, v3, v2

    invoke-virtual {v0, v1, v3}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/Object;

    invoke-static {p1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p1

    aput-object p1, v1, v2

    invoke-virtual {v0, p0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    :done
    return-void
.end method

# Remove the old exact-120-Hz votes. A zero frame rate means no preference and
# returns mode selection to SurfaceFlinger/DisplayManager.
.method private static clearFixedVotes(Landroid/view/Window;)V
    .locals 4

    invoke-virtual {p0}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v0

    iget v1, v0, Landroid/view/WindowManager$LayoutParams;->preferredRefreshRate:F

    const/4 v2, 0x0

    cmpl-float v1, v1, v2

    if-eqz v1, :clear_view

    iput v2, v0, Landroid/view/WindowManager$LayoutParams;->preferredRefreshRate:F

    invoke-virtual {p0, v0}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V

    :clear_view
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1e

    if-lt v0, v1, :done

    invoke-virtual {p0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object p0

    const/4 v0, 0x0    # FRAME_RATE_COMPATIBILITY_DEFAULT

    invoke-virtual {p0, v2, v0}, Landroid/view/View;->setFrameRate(FI)V

    :done
    return-void
.end method

# Enable dynamic touch boost for the active IME window. Older Android releases
# receive no exact frame-rate vote and continue using the system default.
.method public static apply(Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;)V
    .locals 2

    :try_start
    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;->getWindow()Landroid/app/Dialog;

    move-result-object v0

    if-eqz v0, :done

    invoke-virtual {v0}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object v0

    if-eqz v0, :done

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FrameRateCompat;->clearFixedVotes(Landroid/view/Window;)V

    const/4 v1, 0x1

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/FrameRateCompat;->setTouchBoost(Landroid/view/Window;Z)V
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :done

    :done
    return-void
.end method

# InputMethodService reuses its Window. Disable boost and clear every frame-rate
# vote when the input view finishes so no preference leaks into an idle window.
.method public static clear(Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;)V
    .locals 2

    :try_start
    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;->getWindow()Landroid/app/Dialog;

    move-result-object v0

    if-eqz v0, :done

    invoke-virtual {v0}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object v0

    if-eqz v0, :done

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/FrameRateCompat;->setTouchBoost(Landroid/view/Window;Z)V

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FrameRateCompat;->clearFixedVotes(Landroid/view/Window;)V
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :done

    :done
    return-void
.end method
