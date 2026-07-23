.class public final Lcom/google/android/inputmethod/pinyin/PagerDiagnosticsCompat;
.super Ljava/lang/Object;
.source "PagerDiagnosticsCompat.java"


.field private static active:Z

.field private static currentPage:I

.field private static offset:F

.field private static velocity:I

.field private static distance:I


# Called after lk computes the current page-relative offset but before it
# chooses a target. Ignore every shared-lk user except the full symbol/emoji
# holder so candidate paging logs and behavior remain untouched.
.method public static begin(Landroid/view/View;IFI)V
    .locals 1

    instance-of v0, p0, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/PageableRecentSubCategorySoftKeyListHolderView;

    if-eqz v0, :done

    const/4 v0, 0x1

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/PagerDiagnosticsCompat;->active:Z

    sput p1, Lcom/google/android/inputmethod/pinyin/PagerDiagnosticsCompat;->currentPage:I

    sput p2, Lcom/google/android/inputmethod/pinyin/PagerDiagnosticsCompat;->offset:F

    sput p3, Lcom/google/android/inputmethod/pinyin/PagerDiagnosticsCompat;->velocity:I

    const/4 v0, 0x0

    sput v0, Lcom/google/android/inputmethod/pinyin/PagerDiagnosticsCompat;->distance:I

    :done
    return-void
.end method

.method public static distance(Landroid/view/View;I)V
    .locals 1

    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/PagerDiagnosticsCompat;->active:Z

    if-eqz v0, :done

    instance-of v0, p0, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/PageableRecentSubCategorySoftKeyListHolderView;

    if-eqz v0, :done

    sput p1, Lcom/google/android/inputmethod/pinyin/PagerDiagnosticsCompat;->distance:I

    :done
    return-void
.end method

.method public static finish(Landroid/view/View;I)V
    .locals 8

    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/PagerDiagnosticsCompat;->active:Z

    if-eqz v0, :done

    instance-of v0, p0, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/PageableRecentSubCategorySoftKeyListHolderView;

    if-eqz v0, :done

    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0}, Landroid/view/ViewConfiguration;->get(Landroid/content/Context;)Landroid/view/ViewConfiguration;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/ViewConfiguration;->getScaledMinimumFlingVelocity()I

    move-result v0

    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->density:F

    const/high16 v1, 0x41c80000    # 25.0f

    mul-float/2addr p0, v1

    float-to-int p0, p0

    sget v1, Lcom/google/android/inputmethod/pinyin/PagerDiagnosticsCompat;->distance:I

    sget v2, Lcom/google/android/inputmethod/pinyin/PagerDiagnosticsCompat;->velocity:I

    invoke-static {v2}, Ljava/lang/Math;->abs(I)I

    move-result v2

    if-le v2, v0, :not_fling

    const/4 v2, 0x1

    goto :have_fling

    :not_fling
    const/4 v2, 0x0

    :have_fling
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "drag=true current="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v4, Lcom/google/android/inputmethod/pinyin/PagerDiagnosticsCompat;->currentPage:I

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, " target="

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, " changed="

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-ne v4, p1, :changed

    const/4 v4, 0x0

    goto :append_changed

    :changed
    const/4 v4, 0x1

    :append_changed
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v4, " offset="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v4, Lcom/google/android/inputmethod/pinyin/PagerDiagnosticsCompat;->offset:F

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v4, " legacyDistance="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " distanceThreshold="

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " velocity="

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget p0, Lcom/google/android/inputmethod/pinyin/PagerDiagnosticsCompat;->velocity:I

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " minVelocity="

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " fling="

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p0, " result="

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v4, Lcom/google/android/inputmethod/pinyin/PagerDiagnosticsCompat;->currentPage:I

    if-eq v4, p1, :result_same

    const-string p0, "page"

    goto :append_result

    :result_same
    const-string p0, "snap_back"

    :append_result
    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "GPPagerDiag"

    invoke-static {p1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x0

    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/PagerDiagnosticsCompat;->active:Z

    :done
    return-void
.end method
