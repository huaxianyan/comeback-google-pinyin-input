.class public final Lcom/google/android/inputmethod/pinyin/ScrollTouchCompat;
.super Ljava/lang/Object;
.source "ScrollTouchCompat.java"


# Android now dispatches transformed MotionEvent copies to descendant views.
# Mutating the event inside the ScrollView no longer changes the original event
# later consumed by SoftKeyboardView's custom key pipeline. Bridge the detected
# scroll state explicitly between the two layers.
.field private static scrolling:Z


.method public static reset()V
    .locals 1

    const/4 v0, 0x0

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/ScrollTouchCompat;->scrolling:Z

    return-void
.end method

.method public static markScrolling()V
    .locals 1

    const/4 v0, 0x1

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/ScrollTouchCompat;->scrolling:Z

    return-void
.end method

.method public static cancelOuterRelease(Landroid/view/MotionEvent;)V
    .locals 3

    invoke-virtual {p0}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    if-nez v0, :check_up

    invoke-static {}, Lcom/google/android/inputmethod/pinyin/ScrollTouchCompat;->reset()V

    return-void

    :check_up
    const/4 v1, 0x1

    if-ne v0, v1, :check_cancel

    sget-boolean v2, Lcom/google/android/inputmethod/pinyin/ScrollTouchCompat;->scrolling:Z

    if-eqz v2, :reset

    const/4 v2, 0x3

    invoke-virtual {p0, v2}, Landroid/view/MotionEvent;->setAction(I)V

    goto :reset

    :check_cancel
    const/4 v1, 0x3

    if-ne v0, v1, :done

    :reset
    const/4 v0, 0x0

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/ScrollTouchCompat;->scrolling:Z

    :done
    return-void
.end method
