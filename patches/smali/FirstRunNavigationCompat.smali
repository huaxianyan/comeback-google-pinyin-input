.class public final Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunNavigationCompat;
.super Ljava/lang/Object;
.source "FirstRunNavigationCompat.java"


# direct methods
.method public static update(Lapy;ILjava/lang/Object;)V
    .locals 5

    instance-of v0, p0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/PinyinFirstRunActivity;

    if-eqz v0, :done

    iget-object v0, p0, Lapy;->a:Landroid/view/View;

    if-eqz v0, :previous_done

    if-lez p1, :hide_previous

    const/4 v1, 0x0

    goto :set_previous_visibility

    :hide_previous
    const/4 v1, 0x4

    :set_previous_visibility
    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    :previous_done
    iget-object v0, p0, Lapy;->b:Landroid/view/View;

    if-eqz v0, :done

    iget-object v1, p0, Lapy;->a:[I

    array-length v1, v1

    add-int/lit8 v1, v1, -0x1

    if-ne p1, v1, :show_next

    const-string v2, "完成"

    goto :set_next_text

    :show_next
    const-string v2, "下一步"

    :set_next_text
    move-object v3, v0

    check-cast v3, Landroid/widget/TextView;

    invoke-virtual {v3, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    instance-of v1, p2, Lapr;

    if-eqz v1, :enable_next

    check-cast p2, Lapr;

    invoke-virtual {p2}, Lapr;->a()Z

    move-result v1

    invoke-virtual {v0, v1}, Landroid/view/View;->setEnabled(Z)V

    goto :done

    :enable_next
    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/view/View;->setEnabled(Z)V

    :done
    return-void
.end method

.method public static markCurrentComplete(Lapy;)V
    .locals 2

    instance-of v0, p0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/PinyinFirstRunActivity;

    if-eqz v0, :done

    iget-object v0, p0, Lapy;->b:Landroid/view/View;

    if-eqz v0, :done

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/view/View;->setEnabled(Z)V

    :done
    return-void
.end method

.method private constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method
