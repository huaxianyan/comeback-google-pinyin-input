.class public final Lcom/google/android/inputmethod/pinyin/FrameRateCompat;
.super Ljava/lang/Object;
.source "FrameRateCompat.java"


# The 2018 framework never expresses a frame-rate preference. Modern Android
# consequently places the IME surface in the normal (often 60 Hz) category even
# on a 120 Hz display. Request 120 Hz for keyboard scrolling and transitions;
# the compositor will choose the nearest rate supported by the current display.
.method public static apply(Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;)V
    .locals 5

    :try_start
    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;->getWindow()Landroid/app/Dialog;

    move-result-object v0

    if-eqz v0, :done

    invoke-virtual {v0}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object v0

    if-eqz v0, :done

    # Window-level hint works back to API 21 and covers the complete IME surface.
    invoke-virtual {v0}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v1

    const/high16 v2, 0x42f00000    # 120.0f

    iput v2, v1, Landroid/view/WindowManager$LayoutParams;->preferredRefreshRate:F

    invoke-virtual {v0, v1}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V

    # API 30 added a per-surface request. Setting it on the decor view prevents
    # Android's frame-rate-category heuristic from treating this old app as 60 Hz.
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x1e

    if-lt v1, v3, :done

    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0

    const/4 v1, 0x0    # FRAME_RATE_COMPATIBILITY_DEFAULT

    invoke-virtual {v0, v2, v1}, Landroid/view/View;->setFrameRate(FI)V
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :done

    :done
    return-void
.end method
