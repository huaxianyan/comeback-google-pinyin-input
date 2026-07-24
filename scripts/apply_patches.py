#!/usr/bin/env python3
"""Apply Android 16/17 compatibility patches to Google Pinyin 4.5.2.

This script intentionally targets the unmodified Google Pinyin Input
4.5.2.193126728 arm64-v8a APK. It aborts instead of guessing when an expected
source fragment is missing or appears more than once.
"""

from __future__ import annotations

import argparse
import shutil
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def replace_once(path: Path, old: str, new: str) -> None:
    text = path.read_text(encoding="utf-8")
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f"Expected exactly one match in {path}, found {count}")
    path.write_text(text.replace(old, new), encoding="utf-8", newline="\n")


def replace_exactly(path: Path, old: str, new: str, expected: int) -> None:
    text = path.read_text(encoding="utf-8")
    count = text.count(old)
    if count != expected:
        raise RuntimeError(f"Expected {expected} matches in {path}, found {count}")
    path.write_text(text.replace(old, new), encoding="utf-8", newline="\n")


def apply(decoded: Path, application_id: str) -> None:
    if not (decoded / "apktool.yml").is_file():
        raise RuntimeError(f"Not an apktool output directory: {decoded}")

    # Keep the target increase deliberately small. This removes Android 16's
    # legacy-app warning without enabling every Android 12-16 behavior change.
    replace_once(
        decoded / "apktool.yml",
        "sdkInfo:\n  minSdkVersion: 17\n  targetSdkVersion: 26",
        "sdkInfo:\n  minSdkVersion: 17\n  targetSdkVersion: 28",
    )
    replace_once(
        decoded / "apktool.yml",
        "versionInfo:\n  versionCode: 4520313\n  versionName: 4.5.2.193126728-arm64-v8a",
        "versionInfo:\n  versionCode: 4520360\n"
        "  versionName: 4.5.2",
    )

    arrays = decoded / "res/values/arrays.xml"
    replace_once(
        arrays,
        "        <item>@layout/first_run_page_permission</item>\n"
        "        <item>@layout/first_run_page_setup_user_metrics</item>\n"
        "        <item>@layout/first_run_page_done</item>",
        "        <item>@layout/first_run_page_done</item>",
    )
    replace_once(
        arrays,
        "        <item>@layout/first_run_page_select_input_method</item>\n"
        "        <item>@layout/first_run_page_setup_user_metrics</item>\n"
        "        <item>@layout/first_run_page_done</item>",
        "        <item>@layout/first_run_page_select_input_method</item>\n"
        "        <item>@layout/first_run_page_done</item>",
    )

    # API 35+ receives an MD3-inspired first-run surface with day/night colors,
    # rounded filled buttons, current typography and a finish-only final action.
    resource_patches = ROOT / "patches/res"
    for source in resource_patches.rglob("*"):
        if not source.is_file():
            continue
        destination = decoded / "res" / source.relative_to(resource_patches)
        destination.parent.mkdir(parents=True, exist_ok=True)
        overwritten_layouts = {
            "first_run.xml",
            "first_run_page_done.xml",
            "first_run_page_footer.xml",
        }
        if destination.exists() and source.name not in overwritten_layouts:
            raise RuntimeError(f"Refusing to overwrite resource: {destination}")
        shutil.copyfile(source, destination)

    # Android rejects the legacy Region.Op.REPLACE clip used by the old
    # handwriting renderer. Match current Gboard: isolate every dirty-rect draw
    # with save/restore and use the default INTERSECT clipRect overload, without
    # depending on the deprecated Region.Op API.
    stroke_renderer = decoded / "smali/ayc.smali"
    for rect_register, op_register in (("v1", "v2"), ("v0", "v1"), ("v6", "v1")):
        replace_once(
            stroke_renderer,
            f"    sget-object {op_register}, Landroid/graphics/Region$Op;->REPLACE:"
            "Landroid/graphics/Region$Op;\n\n"
            f"    invoke-virtual {{p2, {rect_register}, {op_register}}}, "
            "Landroid/graphics/Canvas;->clipRect(Landroid/graphics/RectF;"
            "Landroid/graphics/Region$Op;)Z",
            "    invoke-virtual {p2}, Landroid/graphics/Canvas;->save()I\n\n"
            f"    invoke-virtual {{p2, {rect_register}}}, Landroid/graphics/Canvas;"
            "->clipRect(Landroid/graphics/RectF;)Z",
        )
    for draw_call in (
        "    invoke-virtual {p2, v2, v3, v0, v4}, Landroid/graphics/Canvas;"
        "->drawCircle(FFFLandroid/graphics/Paint;)V",
        "    invoke-virtual {p2, v1, v2}, Landroid/graphics/Canvas;->drawPath("
        "Landroid/graphics/Path;Landroid/graphics/Paint;)V",
        "    invoke-virtual {p2, v1, v2, v0, v3}, Landroid/graphics/Canvas;"
        "->drawCircle(FFFLandroid/graphics/Paint;)V",
    ):
        replace_once(
            stroke_renderer,
            draw_call,
            draw_call + "\n\n    invoke-virtual {p2}, Landroid/graphics/Canvas;->restore()V",
        )

    # Keep full-canvas handwriting clears state-neutral as well. Restore before
    # replaying retained strokes so every renderer call starts from a clean clip.
    for relative in (
        "smali/aye.smali",
        "smali/com/google/android/apps/inputmethod/libs/handwriting/keyboard/"
        "HandwritingOverlayView.smali",
    ):
        clear_path = decoded / relative
        replace_once(
            clear_path,
            "    iget-object v0, v6, Lcom/google/android/apps/inputmethod/libs/"
            "handwriting/keyboard/HandwritingOverlayView;->a:Landroid/graphics/Canvas;\n\n"
            "    sget-object v1, Landroid/graphics/PorterDuff$Mode;->CLEAR:"
            "Landroid/graphics/PorterDuff$Mode;\n\n"
            "    invoke-virtual {v0, v7, v1}, Landroid/graphics/Canvas;->drawColor("
            "ILandroid/graphics/PorterDuff$Mode;)V"
            if relative == "smali/aye.smali"
            else
            "    iget-object v0, p0, Lcom/google/android/apps/inputmethod/libs/"
            "handwriting/keyboard/HandwritingOverlayView;->a:Landroid/graphics/Canvas;\n\n"
            "    sget-object v1, Landroid/graphics/PorterDuff$Mode;->CLEAR:"
            "Landroid/graphics/PorterDuff$Mode;\n\n"
            "    invoke-virtual {v0, v6, v1}, Landroid/graphics/Canvas;->drawColor("
            "ILandroid/graphics/PorterDuff$Mode;)V",
            (
                "    iget-object v0, v6, Lcom/google/android/apps/inputmethod/libs/"
                "handwriting/keyboard/HandwritingOverlayView;->a:Landroid/graphics/Canvas;\n\n"
                "    sget-object v1, Landroid/graphics/PorterDuff$Mode;->CLEAR:"
                "Landroid/graphics/PorterDuff$Mode;\n\n"
                "    invoke-virtual {v0, v7, v1}, Landroid/graphics/Canvas;->drawColor("
                "ILandroid/graphics/PorterDuff$Mode;)V\n\n"
                "    invoke-virtual {v0}, Landroid/graphics/Canvas;->restore()V"
                if relative == "smali/aye.smali"
                else
                "    iget-object v0, p0, Lcom/google/android/apps/inputmethod/libs/"
                "handwriting/keyboard/HandwritingOverlayView;->a:Landroid/graphics/Canvas;\n\n"
                "    sget-object v1, Landroid/graphics/PorterDuff$Mode;->CLEAR:"
                "Landroid/graphics/PorterDuff$Mode;\n\n"
                "    invoke-virtual {v0, v6, v1}, Landroid/graphics/Canvas;->drawColor("
                "ILandroid/graphics/PorterDuff$Mode;)V\n\n"
                "    invoke-virtual {v0}, Landroid/graphics/Canvas;->restore()V"
            ),
        )
        replace_once(
            clear_path,
            "    sget-object v5, Landroid/graphics/Region$Op;->REPLACE:"
            "Landroid/graphics/Region$Op;\n\n"
            "    move v2, v1\n\n"
            "    invoke-virtual/range {v0 .. v5}, Landroid/graphics/Canvas;->clipRect("
            "FFFFLandroid/graphics/Region$Op;)Z",
            "    invoke-virtual {v0}, Landroid/graphics/Canvas;->save()I\n\n"
            "    move v2, v1\n\n"
            "    invoke-virtual/range {v0 .. v4}, Landroid/graphics/Canvas;->clipRect(FFFF)Z",
        )

    # Gesture trails already bracket their local clear with save/restore; only
    # replace the prohibited operation there.
    replace_exactly(
        decoded / (
            "smali/com/google/android/apps/inputmethod/libs/gestureui/"
            "GestureOverlayView$a.smali"
        ),
        "Landroid/graphics/Region$Op;->REPLACE:Landroid/graphics/Region$Op;",
        "Landroid/graphics/Region$Op;->INTERSECT:Landroid/graphics/Region$Op;",
        1,
    )

    # Keep a stable three-step flow: enable, select, done. Current Gboard no
    # longer includes its legacy permission or user-metrics pages in the normal
    # first-run array; capabilities request permission only when actually used.
    first_run_activity = decoded / (
        "smali/com/google/android/apps/inputmethod/pinyin/firstrun/"
        "PinyinFirstRunActivity.smali"
    )
    old_page_selector = """.method protected final a()I
    .locals 4

    .prologue
    const/4 v1, 0x0

    .line 9
    .line 10
    iget-object v0, p0, Lapy;->a:[Ljava/lang/String;

    .line 11
    array-length v0, v0

    if-lez v0, :cond_0

    const/4 v0, 0x1

    .line 12
    :goto_0
    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/PinyinFirstRunActivity;->getIntent()Landroid/content/Intent;

    move-result-object v2

    const-string v3, "activation_page"

    invoke-virtual {v2, v3, v1}, Landroid/content/Intent;->getBooleanExtra(Ljava/lang/String;Z)Z

    move-result v1

    if-eqz v1, :cond_1

    const v0, 0x7f0a0001

    .line 15
    :goto_1
    return v0

    :cond_0
    move v0, v1

    .line 11
    goto :goto_0

    .line 13
    :cond_1
    if-eqz v0, :cond_2

    const v0, 0x7f0a0018

    goto :goto_1

    .line 14
    :cond_2
    const v0, 0x7f0a0019

    .line 15
    goto :goto_1
.end method"""
    new_page_selector = """.method protected final a()I
    .locals 1

    .prologue
    const v0, 0x7f0a0019

    return v0
.end method"""
    replace_once(first_run_activity, old_page_selector, new_page_selector)
    replace_once(
        first_run_activity,
        "\n\n# virtual methods\n.method protected final a()I",
        "\n\n# virtual methods\n.method public final exitGuide()V\n"
        "    .locals 2\n\n"
        "    new-instance v0, Landroid/content/Intent;\n\n"
        "    const-string v1, \"android.intent.action.MAIN\"\n\n"
        "    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V\n\n"
        "    const-string v1, \"android.intent.category.HOME\"\n\n"
        "    invoke-virtual {v0, v1}, Landroid/content/Intent;->addCategory("
        "Ljava/lang/String;)Landroid/content/Intent;\n\n"
        "    const/high16 v1, 0x14000000\n\n"
        "    invoke-virtual {v0, v1}, Landroid/content/Intent;->addFlags(I)"
        "Landroid/content/Intent;\n\n"
        "    invoke-virtual {p0, v0}, Lcom/google/android/apps/inputmethod/pinyin/"
        "firstrun/PinyinFirstRunActivity;->startActivity(Landroid/content/Intent;)V\n\n"
        "    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/"
        "PinyinFirstRunActivity;->finishAndRemoveTask()V\n\n"
        "    return-void\n"
        ".end method\n\n"
        ".method public onBackPressed()V\n"
        "    .locals 2\n\n"
        "    iget-object v0, p0, Lapy;->a:Lcom/google/android/apps/inputmethod/libs/"
        "framework/keyboard/widget/BidiViewPager;\n\n"
        "    invoke-virtual {v0}, Lcom/google/android/apps/inputmethod/libs/framework/"
        "keyboard/widget/BidiViewPager;->a()I\n\n"
        "    move-result v1\n\n"
        "    if-lez v1, :exit_guide\n\n"
        "    add-int/lit8 v1, v1, -0x1\n\n"
        "    invoke-virtual {v0, v1}, Lcom/google/android/apps/inputmethod/libs/framework/"
        "keyboard/widget/BidiViewPager;->b(I)V\n\n"
        "    return-void\n\n"
        "    :exit_guide\n"
        "    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/"
        "PinyinFirstRunActivity;->exitGuide()V\n\n"
        "    return-void\n"
        ".end method\n\n"
        ".method protected final a()I",
    )

    # The first-run footer uses the framework's existing navi_skip slot as a
    # Previous button. Keep the same listener's original Finish behavior for
    # feature-tour activities, but move one page back in Pinyin first-run.
    previous_listener = decoded / "smali/apz.smali"
    replace_once(
        previous_listener,
        ".method public final onClick(Landroid/view/View;)V\n"
        "    .locals 1\n\n"
        "    .prologue\n"
        "    .line 2\n"
        "    iget-object v0, p0, Lapz;->a:Lapy;\n\n"
        "    invoke-virtual {v0}, Lapy;->finish()V\n\n"
        "    .line 3\n"
        "    return-void\n"
        ".end method",
        ".method public final onClick(Landroid/view/View;)V\n"
        "    .locals 2\n\n"
        "    iget-object v0, p0, Lapz;->a:Lapy;\n\n"
        "    instance-of v1, v0, Lcom/google/android/apps/inputmethod/pinyin/"
        "firstrun/PinyinFirstRunActivity;\n\n"
        "    if-eqz v1, :finish_feature_activity\n\n"
        "    iget-object v0, v0, Lapy;->a:Lcom/google/android/apps/inputmethod/libs/"
        "framework/keyboard/widget/BidiViewPager;\n\n"
        "    invoke-virtual {v0}, Lcom/google/android/apps/inputmethod/libs/framework/"
        "keyboard/widget/BidiViewPager;->a()I\n\n"
        "    move-result v1\n\n"
        "    if-lez v1, :done\n\n"
        "    add-int/lit8 v1, v1, -0x1\n\n"
        "    invoke-virtual {v0, v1}, Lcom/google/android/apps/inputmethod/libs/framework/"
        "keyboard/widget/BidiViewPager;->b(I)V\n\n"
        "    goto :done\n\n"
        "    :finish_feature_activity\n"
        "    invoke-virtual {v0}, Lapy;->finish()V\n\n"
        "    :done\n"
        "    return-void\n"
        ".end method",
    )

    # On the last first-run page the right-side Next slot becomes Finish and
    # exits through the already validated Home/task cleanup path.
    next_listener = decoded / "smali/aqa.smali"
    replace_once(
        next_listener,
        "    invoke-virtual {v0}, Lcom/google/android/apps/inputmethod/libs/framework/"
        "keyboard/widget/BidiViewPager;->a()I\n\n"
        "    move-result v1\n\n"
        "    .line 5\n"
        "    iget-object v0, p0, Laqa;->a:Lapy;",
        "    invoke-virtual {v0}, Lcom/google/android/apps/inputmethod/libs/framework/"
        "keyboard/widget/BidiViewPager;->a()I\n\n"
        "    move-result v1\n\n"
        "    iget-object v0, p0, Laqa;->a:Lapy;\n\n"
        "    instance-of v2, v0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/"
        "PinyinFirstRunActivity;\n\n"
        "    if-eqz v2, :continue_next\n\n"
        "    iget-object v2, v0, Lapy;->a:[I\n\n"
        "    array-length v2, v2\n\n"
        "    add-int/lit8 v2, v2, -0x1\n\n"
        "    if-ne v1, v2, :continue_next\n\n"
        "    check-cast v0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/"
        "PinyinFirstRunActivity;\n\n"
        "    invoke-virtual {v0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/"
        "PinyinFirstRunActivity;->exitGuide()V\n\n"
        "    return-void\n\n"
        "    :continue_next\n"
        "    .line 5\n"
        "    iget-object v0, p0, Laqa;->a:Lapy;",
    )

    # Page selection owns footer visibility, Next/Finish text and initial enabled
    # state. Run this after old generic footer logic so first/last rules win.
    page_adapter = decoded / "smali/aqc.smali"
    replace_once(
        page_adapter,
        "    :cond_3\n"
        "    return-void\n\n"
        "    :cond_4",
        "    :cond_3\n"
        "    invoke-virtual {p0, p1}, Laqc;->a(I)I\n\n"
        "    move-result v4\n\n"
        "    iget-object v2, p0, Laqc;->a:Lapy;\n\n"
        "    invoke-static {v2, v4, p2}, Lcom/google/android/apps/inputmethod/pinyin/"
        "firstrun/FirstRunNavigationCompat;->update(Lapy;ILjava/lang/Object;)V\n\n"
        "    return-void\n\n"
        "    :cond_4",
    )

    # Completing Enable/Select used to auto-advance through Lapt. Keep the page
    # in place and only unlock Next, so navigation is explicit and predictable.
    completion_runnable = decoded / "smali/apt.smali"
    replace_once(
        completion_runnable,
        "    check-cast v0, Lapy;\n\n"
        "    iget-object v1, p0, Lapt;->a:Lapr;",
        "    check-cast v0, Lapy;\n\n"
        "    instance-of v1, v0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/"
        "PinyinFirstRunActivity;\n\n"
        "    if-eqz v1, :original_completion\n\n"
        "    invoke-static {v0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/"
        "FirstRunNavigationCompat;->markCurrentComplete(Lapy;)V\n\n"
        "    return-void\n\n"
        "    :original_completion\n"
        "    iget-object v1, p0, Lapt;->a:Lapr;",
    )

    # Completion/close must explicitly bring Home forward before removing the
    # setup task; finishAndRemoveTask alone can reveal its launcher settings.
    for listener in ("smali/aqb.smali", "smali/aqe.smali"):
        replace_once(
            decoded / listener,
            "    invoke-virtual {v0}, Lapy;->finish()V",
            "    check-cast v0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/"
            "PinyinFirstRunActivity;\n\n"
            "    invoke-virtual {v0}, Lcom/google/android/apps/inputmethod/pinyin/"
            "firstrun/PinyinFirstRunActivity;->exitGuide()V",
        )

    # The left list scrolls correctly, but its original starting SoftKey is
    # selected on release. Detect actual pointer displacement directly in the
    # list (without GestureDetector heuristics) and replace UP with CANCEL.
    scroll_holder = decoded / "smali/awo.smali"
    replace_once(
        scroll_holder,
        ".field private d:I\n",
        ".field private d:I\n\n"
        ".field private compatDownScrollY:I\n\n"
        ".field private compatMoved:Z\n",
    )
    old_touch = """.method public onTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 3

    .prologue
    .line 14
    invoke-super {p0, p1}, Landroid/widget/ScrollView;->onTouchEvent(Landroid/view/MotionEvent;)Z

    move-result v0

    .line 15
    iget-object v1, p0, Lawo;->a:Landroid/view/GestureDetector;

    invoke-virtual {v1, p1}, Landroid/view/GestureDetector;->onTouchEvent(Landroid/view/MotionEvent;)Z

    .line 16
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v1

    const/4 v2, 0x1

    if-ne v1, v2, :cond_0

    iget-object v1, p0, Lawo;->a:Lawp;

    iget-boolean v1, v1, Lawp;->a:Z

    if-eqz v1, :cond_0

    .line 17
    const/4 v1, 0x3

    invoke-virtual {p1, v1}, Landroid/view/MotionEvent;->setAction(I)V

    .line 18
    :cond_0
    return v0
.end method"""
    new_touch = """.method public dispatchTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 4

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v1

    if-nez v1, :dispatch

    invoke-virtual {p0}, Lawo;->getScrollY()I

    move-result v2

    iput v2, p0, Lawo;->compatDownScrollY:I

    const/4 v2, 0x0

    iput-boolean v2, p0, Lawo;->compatMoved:Z

    invoke-static {}, Lcom/google/android/inputmethod/pinyin/ScrollTouchCompat;->reset()V

    :dispatch
    invoke-super {p0, p1}, Landroid/widget/ScrollView;->dispatchTouchEvent(Landroid/view/MotionEvent;)Z

    move-result v0

    const/4 v2, 0x2

    if-ne v1, v2, :done

    iget-boolean v2, p0, Lawo;->compatMoved:Z

    if-nez v2, :done

    invoke-virtual {p0}, Lawo;->getScrollY()I

    move-result v2

    iget v3, p0, Lawo;->compatDownScrollY:I

    if-ne v2, v3, :mark_moved

    goto :done

    :mark_moved
    const/4 v2, 0x1

    iput-boolean v2, p0, Lawo;->compatMoved:Z

    invoke-static {}, Lcom/google/android/inputmethod/pinyin/ScrollTouchCompat;->markScrolling()V

    :done
    return v0
.end method

.method public onTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 1

    invoke-super {p0, p1}, Landroid/widget/ScrollView;->onTouchEvent(Landroid/view/MotionEvent;)Z

    move-result v0

    return v0
.end method"""
    replace_once(scroll_holder, old_touch, new_touch)

    # Keep pageable holders' original order: the pager must see ACTION_UP before
    # the click-cancellation helper mutates it. v5 reversed this order and made
    # every genuine page swipe look like ACTION_CANCEL, forcing users to drag
    # beyond half a page before the page could change.
    #
    # Android now gives the pageable holder a transformed MotionEvent copy, so
    # aws cancelling only that copy does not reliably cancel SoftKeyboardView's
    # custom key pipeline. Preserve aws' own CANCEL and additionally bridge its
    # confirmed paging-touch-slop state to the outer event, matching Gboard's
    # ohc -> rzb -> SoftKeyboardView cancellation protocol.
    pageable_touch = decoded / "smali/aws.smali"
    replace_once(
        pageable_touch,
        "    .line 13\n"
        "    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->setAction(I)V\n\n"
        "    goto :goto_0\n\n"
        "    .line 14\n",
        "    .line 13\n"
        "    invoke-static {}, Lcom/google/android/inputmethod/pinyin/"
        "ScrollTouchCompat;->markScrolling()V\n\n"
        "    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->setAction(I)V\n\n"
        "    goto :goto_0\n\n"
        "    .line 14\n",
    )
    replace_once(
        pageable_touch,
        "    .line 17\n"
        "    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->setAction(I)V\n\n"
        "    goto :goto_0\n\n"
        "    .line 5\n",
        "    .line 17\n"
        "    invoke-static {}, Lcom/google/android/inputmethod/pinyin/"
        "ScrollTouchCompat;->markScrolling()V\n\n"
        "    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->setAction(I)V\n\n"
        "    goto :goto_0\n\n"
        "    .line 5\n",
    )

    # V34: lk's legacy 25dp check compares UP against a final internal pointer
    # baseline and is always zero on current Android, making its fling branch
    # unreachable despite high VelocityTracker values. Only for the full
    # symbol/emoji subclass, rely on the existing dragging gate plus the system
    # minimum fling velocity, as RecyclerView/ViewPager2 does. Every other lk
    # user retains the original distance + velocity double gate.
    four_directional_pager = decoded / "smali/lk.smali"
    replace_once(
        four_directional_pager,
        "    iget v6, p0, Llk;->n:I\n\n"
        "    if-le v0, v6, :cond_f\n\n"
        "    invoke-static {v2}, Ljava/lang/Math;->abs(I)I",
        "    iget v6, p0, Llk;->n:I\n\n"
        "    instance-of v7, p0, Lcom/google/android/apps/inputmethod/libs/framework/"
        "keyboard/widget/PageableRecentSubCategorySoftKeyListHolderView;\n\n"
        "    if-nez v7, :compat_check_fling_velocity\n\n"
        "    if-le v0, v6, :cond_f\n\n"
        "    :compat_check_fling_velocity\n"
        "    invoke-static {v2}, Ljava/lang/Math;->abs(I)I",
    )

    # Let the ScrollView receive the original UP first so it can calculate
    # fling velocity. Only afterwards cancel the outer copy before the custom
    # keyboard handler consumes it.
    soft_keyboard = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/framework/keyboard/"
        "SoftKeyboardView.smali"
    )
    replace_once(
        soft_keyboard,
        "    .line 99\n"
        "    :cond_4\n"
        "    invoke-super {p0, p1}, Landroid/widget/FrameLayout;->dispatchTouchEvent("
        "Landroid/view/MotionEvent;)Z\n\n"
        "    .line 100",
        "    .line 99\n"
        "    :cond_4\n"
        "    invoke-super {p0, p1}, Landroid/widget/FrameLayout;->dispatchTouchEvent("
        "Landroid/view/MotionEvent;)Z\n\n"
        "    # Preserve ScrollView UP/fling, then cancel only the outer key event.\n"
        "    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/"
        "ScrollTouchCompat;->cancelOuterRelease(Landroid/view/MotionEvent;)V\n\n"
        "    .line 100",
    )

    # Remove obsolete network-facing features and their settings entry points.
    replace_once(
        decoded / "res/xml/setting_other.xml",
        '    <com.google.android.apps.inputmethod.libs.framework.preference.widget.'
        'CheckBoxPreferenceWithConfirmDialog android:persistent="true" '
        'android:title="@string/setting_user_metrics_title" '
        'android:key="@string/pref_key_enable_user_metrics" '
        'android:dialogTitle="@string/setting_user_metrics_feedback_title" '
        'android:dialogMessage="@string/setting_user_metrics_feedback_message" />\n',
        "",
    )
    replace_once(
        decoded / "res/menu/menu_settings.xml",
        '    <item android:id="@id/action_send_feedback" android:orderInCategory="2" '
        'android:title="@string/setting_send_feedback_title" '
        'android:showAsAction="never" />\n',
        "",
    )
    dictionary_settings_xml = decoded / "res/xml/setting_dictionary.xml"
    replace_once(
        dictionary_settings_xml,
        '    <PreferenceCategory android:title="@string/setting_update_category_title">\n'
        '        <com.google.android.apps.inputmethod.libs.framework.preference.widget.'
        'AutoSyncedCheckBoxPreference android:persistent="true" '
        'android:title="@string/setting_update_enabled_title" '
        'android:key="@string/pref_key_enable_dictionary_update" />\n'
        '        <CheckBoxPreference android:persistent="true" '
        'android:title="@string/setting_update_notify_enabled_title" '
        'android:key="@string/pref_key_enable_notify_dictionary_update" '
        'android:dependency="@string/pref_key_enable_dictionary_update" />\n'
        '    </PreferenceCategory>\n',
        "",
    )

    # Fixed-path rotating exports survive clear-data/uninstall. The validated
    # local backup actions replace the obsolete picker-based import/export rows;
    # their state lives outside the preferences registered with BackupAgent.
    replace_once(
        dictionary_settings_xml,
        '        <Preference android:persistent="false" '
        'android:title="@string/setting_import_user_dictionary_title" '
        'android:key="@string/setting_import_user_dictionary_key" />\n'
        '        <Preference android:persistent="false" '
        'android:title="@string/setting_export_user_dictionary_title" '
        'android:key="@string/setting_export_user_dictionary_key" />',
        '        <CheckBoxPreference android:persistent="false" '
        'android:title="@string/dictionary_auto_backup_title" '
        'android:key="dictionary_auto_backup_enabled" '
        'android:summary="@string/dictionary_auto_backup_privacy_summary" />\n'
        '        <Preference android:persistent="false" '
        'android:title="@string/dictionary_auto_backup_location_title" '
        'android:key="dictionary_auto_backup_location" />\n'
        '        <ListPreference android:persistent="false" '
        'android:title="@string/dictionary_auto_backup_interval_title" '
        'android:key="dictionary_auto_backup_interval_days" '
        'android:entries="@array/dictionary_auto_backup_interval_entries" '
        'android:entryValues="@array/dictionary_auto_backup_interval_values" />\n'
        '        <ListPreference android:persistent="false" '
        'android:title="@string/dictionary_auto_backup_retention_title" '
        'android:key="dictionary_auto_backup_retention_count" '
        'android:entries="@array/dictionary_auto_backup_retention_entries" '
        'android:entryValues="@array/dictionary_auto_backup_retention_values" />\n'
        '        <Preference android:persistent="false" '
        'android:title="@string/dictionary_auto_backup_now_title" '
        'android:key="dictionary_auto_backup_now" />\n'
        '        <Preference android:persistent="false" '
        'android:title="@string/dictionary_auto_backup_import_title" '
        'android:key="dictionary_auto_backup_import" />',
    )

    # PinyinApp's Laym instance registers Clearcut/Primes processors, daily
    # pings and keyboard event collectors. Without it, IMetrics remains usable
    # internally but no upload processors are attached.
    replace_once(
        decoded / "smali/com/google/android/apps/inputmethod/pinyin/PinyinApp.smali",
        "    .line 16\n"
        "    :cond_1\n"
        "    iget-object v0, p0, Lcom/google/android/apps/inputmethod/pinyin/"
        "PinyinApp;->a:Laym;\n\n"
        "    if-nez v0, :cond_2\n\n"
        "    .line 17\n"
        "    new-instance v0, Laym;\n\n"
        "    invoke-direct {v0, p0}, Laym;-><init>(Landroid/app/Application;)V\n\n"
        "    iput-object v0, p0, Lcom/google/android/apps/inputmethod/pinyin/"
        "PinyinApp;->a:Laym;\n\n"
        "    .line 18\n"
        "    :cond_2",
        "    .line 16\n"
        "    :cond_1\n"
        "    # Compatibility build: Clearcut/Primes collection is disabled.\n"
        "    .line 18\n"
        "    :cond_2",
    )

    # Remove the dead Chinese system-dictionary updater and the remaining daily
    # analytics task registration. Keep the unrelated local English model task.
    pinyin_ime = decoded / "smali/com/google/android/inputmethod/pinyin/PinyinIME.smali"
    replace_once(
        pinyin_ime,
        "    .line 5\n"
        "    invoke-static {p0}, Lamo;->a(Landroid/content/Context;)Lamo;\n\n"
        "    move-result-object v0\n\n"
        "    const-string v1, \"new_words_update\"\n\n"
        "    new-instance v2, Lcom/google/android/apps/inputmethod/libs/hmm/sync/"
        "NewWordsUpdateTaskFactory;\n\n"
        "    const-string v3, \"https://tools.google.com/service/update?as=pinyinsysdict\"\n\n"
        "    .line 6\n"
        "    invoke-static {p0}, Lbdt;->a(Landroid/content/Context;)Lbdt;\n\n"
        "    move-result-object v4\n\n"
        "    .line 7\n"
        "    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/PinyinIME;"
        "->getResources()Landroid/content/res/Resources;\n\n"
        "    move-result-object v5\n\n"
        "    const v6, 0x7f110252\n\n"
        "    invoke-virtual {v5, v6}, Landroid/content/res/Resources;"
        "->getString(I)Ljava/lang/String;\n\n"
        "    move-result-object v5\n\n"
        "    invoke-direct {v2, p0, v3, v4, v5}, Lcom/google/android/apps/inputmethod/"
        "libs/hmm/sync/NewWordsUpdateTaskFactory;-><init>(Landroid/content/Context;"
        "Ljava/lang/String;Lcom/google/android/apps/inputmethod/libs/hmm/"
        "AbstractHmmEngineFactory;Ljava/lang/String;)V\n\n"
        "    .line 8\n"
        "    invoke-virtual {v0, v1, v2}, Lamo;->a(Ljava/lang/String;"
        "Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "PeriodicalTaskFactory;)V\n\n",
        "",
    )
    replace_once(
        pinyin_ime,
        "    .line 11\n"
        "    invoke-virtual {p0}, Landroid/content/Context;->getResources()"
        "Landroid/content/res/Resources;\n\n"
        "    move-result-object v0\n\n"
        "    const v1, 0x7f0b000b\n\n"
        "    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getBoolean(I)Z\n\n"
        "    move-result v0\n\n"
        "    if-eqz v0, :cond_0\n\n"
        "    .line 12\n"
        "    invoke-static {p0}, Lamo;->a(Landroid/content/Context;)Lamo;\n\n"
        "    move-result-object v0\n\n"
        "    const-string v1, \"daily_ping_task\"\n\n"
        "    new-instance v2, Lazm;\n\n"
        "    invoke-direct {v2}, Lazm;-><init>()V\n\n"
        "    invoke-virtual {v0, v1, v2}, Lamo;->a(Ljava/lang/String;"
        "Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "PeriodicalTaskFactory;)V\n\n"
        "    .line 13\n"
        "    :cond_0",
        "    .line 13\n"
        "    :cond_0",
    )

    # Queue a due local export after Pinyin has submitted/completed both Chinese
    # and English save paths. The helper is a no-op unless explicitly enabled.
    replace_once(
        pinyin_ime,
        "    .line 22\n"
        "    invoke-static {p0}, Lagb;->a(Landroid/content/Context;)Lagb;\n\n"
        "    move-result-object v0\n\n"
        "    invoke-static {p0, v0}, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "SaveDictionaryTask;->saveDictionaryNow(Landroid/content/Context;"
        "Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)V\n\n"
        "    .line 23",
        "    .line 22\n"
        "    invoke-static {p0}, Lagb;->a(Landroid/content/Context;)Lagb;\n\n"
        "    move-result-object v0\n\n"
        "    invoke-static {p0, v0}, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "SaveDictionaryTask;->saveDictionaryNow(Landroid/content/Context;"
        "Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)V\n\n"
        "    const/4 v0, 0x0\n\n"
        "    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/"
        "DictionaryAutoBackupCompat;->request(Landroid/content/Context;Z)V\n\n"
        "    .line 23",
    )
    replace_once(
        pinyin_ime,
        "    .line 32\n"
        "    invoke-static {p0}, Lagb;->a(Landroid/content/Context;)Lagb;\n\n"
        "    move-result-object v0\n\n"
        "    invoke-static {p0, v0}, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "SaveDictionaryTask;->launchTaskIfNeeded(Landroid/content/Context;"
        "Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)V\n\n"
        "    .line 33",
        "    .line 32\n"
        "    invoke-static {p0}, Lagb;->a(Landroid/content/Context;)Lagb;\n\n"
        "    move-result-object v0\n\n"
        "    invoke-static {p0, v0}, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "SaveDictionaryTask;->launchTaskIfNeeded(Landroid/content/Context;"
        "Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)V\n\n"
        "    const/4 v0, 0x0\n\n"
        "    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/"
        "DictionaryAutoBackupCompat;->request(Landroid/content/Context;Z)V\n\n"
        "    .line 33",
    )

    # Remove the dictionary-update permission feature registration.
    replace_once(
        decoded / "smali/com/google/android/apps/inputmethod/pinyin/PinyinApp.smali",
        "    .line 8\n"
        "    const v1, 0x7f110252\n\n"
        "    const v2, 0x7f1103ad\n\n"
        "    new-array v3, v7, [Ljava/lang/String;\n\n"
        "    const-string v4, \"android.permission.INTERNET\"\n\n"
        "    aput-object v4, v3, v5\n\n"
        "    const-string v4, \"android.permission.ACCESS_NETWORK_STATE\"\n\n"
        "    aput-object v4, v3, v6\n\n"
        "    invoke-virtual {v0, v1, v2, v3}, Lcom/google/android/apps/inputmethod/"
        "libs/framework/core/FeaturePermissionsManager;->a(II[Ljava/lang/String;)V\n\n",
        "",
    )

    # Recover interrupted dictionary rotations before enrollment. If native
    # loading fails, retry once with the previous known-good rolling backup.
    engine_factory = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/hmm/"
        "AbstractHmmEngineFactory.smali"
    )
    replace_once(
        engine_factory,
        ".method public final enrollMutableDictionary(Landroid/content/Context;"
        "Ljava/lang/String;II)V\n"
        "    .locals 10\n\n"
        "    .prologue\n"
        "    .line 289\n"
        "    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "AbstractHmmEngineFactory;->getDataManager()Lcom/google/android/apps/"
        "inputmethod/libs/hmm/DataManager;",
        ".method public final enrollMutableDictionary(Landroid/content/Context;"
        "Ljava/lang/String;II)V\n"
        "    .locals 10\n\n"
        "    .prologue\n"
        "    invoke-static {p1, p2}, Lcom/google/android/inputmethod/pinyin/"
        "DictionaryRecoveryCompat;->prepareForLoad(Landroid/content/Context;"
        "Ljava/lang/String;)V\n\n"
        "    .line 289\n"
        "    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "AbstractHmmEngineFactory;->getDataManager()Lcom/google/android/apps/"
        "inputmethod/libs/hmm/DataManager;",
    )
    replace_once(
        engine_factory,
        "    .line 299\n"
        "    :try_start_4\n"
        "    invoke-virtual {v7}, Ljava/io/FileInputStream;->close()V\n"
        "    :try_end_4\n"
        "    .catch Ljava/io/IOException; {:try_start_4 .. :try_end_4} :catch_0\n\n"
        "    .line 303\n"
        "    :cond_2",
        "    .line 299\n"
        "    :try_start_4\n"
        "    invoke-virtual {v7}, Ljava/io/FileInputStream;->close()V\n"
        "    :try_end_4\n"
        "    .catch Ljava/io/IOException; {:try_start_4 .. :try_end_4} :catch_0\n\n"
        "    invoke-static {p1, p2}, Lcom/google/android/inputmethod/pinyin/"
        "DictionaryRecoveryCompat;->recoverAfterLoadFailure(Landroid/content/"
        "Context;Ljava/lang/String;)Z\n\n"
        "    move-result v1\n\n"
        "    if-eqz v1, :cond_2\n\n"
        "    invoke-virtual {p0, p1, p2, p3, p4}, Lcom/google/android/apps/"
        "inputmethod/libs/hmm/AbstractHmmEngineFactory;->enrollMutableDictionary("
        "Landroid/content/Context;Ljava/lang/String;II)V\n\n"
        "    return-void\n\n"
        "    .line 303\n"
        "    :cond_2",
    )
    replace_once(
        engine_factory,
        "    :catch_0\n"
        "    move-exception v1\n\n"
        "    goto :goto_1\n"
        ".end method",
        "    :catch_0\n"
        "    move-exception v1\n\n"
        "    invoke-static {p1, p2}, Lcom/google/android/inputmethod/pinyin/"
        "DictionaryRecoveryCompat;->recoverAfterLoadFailure(Landroid/content/"
        "Context;Ljava/lang/String;)Z\n\n"
        "    move-result v1\n\n"
        "    if-eqz v1, :goto_1\n\n"
        "    invoke-virtual {p0, p1, p2, p3, p4}, Lcom/google/android/apps/"
        "inputmethod/libs/hmm/AbstractHmmEngineFactory;->enrollMutableDictionary("
        "Landroid/content/Context;Ljava/lang/String;II)V\n\n"
        "    return-void\n"
        ".end method",
    )

    # Keep one rolling backup after a successful atomic file rotation instead
    # of immediately deleting the only previous known-good dictionary.
    dictionary_accessor = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor.smali"
    )
    replace_once(
        dictionary_accessor,
        "    .line 102\n"
        "    :cond_8\n"
        "    :try_start_3\n"
        "    invoke-virtual {v4}, Ljava/io/File;->delete()Z\n\n"
        "    move-result v0\n\n"
        "    if-nez v0, :cond_9\n\n"
        "    .line 103\n"
        "    const-string v0, \"error deleting file: %s\"\n\n"
        "    const/4 v5, 0x1\n\n"
        "    new-array v5, v5, [Ljava/lang/Object;\n\n"
        "    const/4 v6, 0x0\n\n"
        "    invoke-virtual {v4}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;\n\n"
        "    move-result-object v7\n\n"
        "    aput-object v7, v5, v6\n\n"
        "    invoke-static {v0, v5}, Lalg;->b(Ljava/lang/String;[Ljava/lang/Object;)V\n"
        "    :try_end_3\n"
        "    .catchall {:try_start_3 .. :try_end_3} :catchall_0\n\n"
        "    .line 104\n"
        "    :cond_9",
        "    .line 102\n"
        "    :cond_8\n"
        "    :try_start_3\n"
        "    # Compatibility build: retain the previous known-good dictionary as _bak.\n"
        "    invoke-virtual {v4}, Ljava/io/File;->exists()Z\n\n"
        "    move-result v0\n"
        "    :try_end_3\n"
        "    .catchall {:try_start_3 .. :try_end_3} :catchall_0\n\n"
        "    .line 104\n"
        "    :cond_9",
    )

    # Serialize scheduled and lifecycle-forced saves so separate task instances
    # cannot rotate the same main/_bak/_tmp paths concurrently. Current Gboard
    # likewise uses one class-wide monitor around its save runnable.
    save_dictionary_task = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/hmm/SaveDictionaryTask.smali"
    )
    replace_once(
        save_dictionary_task,
        ".field public static sRunningTasks:Ljava/util/Set;\n"
        "    .annotation system Ldalvik/annotation/Signature;\n"
        "        value = {\n"
        "            \"Ljava/util/Set\",\n"
        "            \"<\",\n"
        "            \"Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;\",\n"
        "            \">;\"\n"
        "        }\n"
        "    .end annotation\n"
        ".end field",
        ".field public static sRunningTasks:Ljava/util/Set;\n"
        "    .annotation system Ldalvik/annotation/Signature;\n"
        "        value = {\n"
        "            \"Ljava/util/Set\",\n"
        "            \"<\",\n"
        "            \"Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;\",\n"
        "            \">;\"\n"
        "        }\n"
        "    .end annotation\n"
        ".end field\n\n"
        ".field public static final sSaveLock:Ljava/lang/Object;",
    )
    replace_once(
        save_dictionary_task,
        "    sput-object v0, Lcom/google/android/apps/inputmethod/libs/hmm/SaveDictionaryTask;->sRunningTasks:Ljava/util/Set;\n\n"
        "    .line 49",
        "    sput-object v0, Lcom/google/android/apps/inputmethod/libs/hmm/SaveDictionaryTask;->sRunningTasks:Ljava/util/Set;\n\n"
        "    new-instance v0, Ljava/lang/Object;\n\n"
        "    invoke-direct {v0}, Ljava/lang/Object;-><init>()V\n\n"
        "    sput-object v0, Lcom/google/android/apps/inputmethod/libs/hmm/SaveDictionaryTask;->sSaveLock:Ljava/lang/Object;\n\n"
        "    .line 49",
    )
    replace_once(
        save_dictionary_task,
        ".method saveDictionaries()V\n"
        "    .locals 4\n\n"
        "    .prologue\n"
        "    .line 7",
        ".method saveDictionaries()V\n"
        "    .locals 5\n\n"
        "    .prologue\n"
        "    sget-object v4, Lcom/google/android/apps/inputmethod/libs/hmm/SaveDictionaryTask;->sSaveLock:Ljava/lang/Object;\n\n"
        "    monitor-enter v4\n\n"
        "    :try_start_save\n"
        "    .line 7",
    )
    replace_once(
        save_dictionary_task,
        "    invoke-virtual {v0, v1, v2, v3}, Lamx;->a(Ljava/lang/String;J)V\n\n"
        "    .line 14\n"
        "    return-void\n"
        ".end method",
        "    invoke-virtual {v0, v1, v2, v3}, Lamx;->a(Ljava/lang/String;J)V\n"
        "    :try_end_save\n"
        "    .catchall {:try_start_save .. :try_end_save} :catchall_save\n\n"
        "    monitor-exit v4\n\n"
        "    .line 14\n"
        "    return-void\n\n"
        "    :catchall_save\n"
        "    move-exception v0\n\n"
        "    monitor-exit v4\n\n"
        "    throw v0\n"
        ".end method",
    )

    # A lifecycle-forced save runs synchronously and can otherwise overlap a
    # background manual/automatic exporter. Keep native accessor enumeration
    # under the same process-wide lock as dictionary rotation.
    export_task = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/hmm/userdictionary/"
        "UserDictExportTask.smali"
    )
    replace_once(
        export_task,
        ".method protected varargs doInBackground([Ljava/lang/Void;)Ljava/lang/Boolean;\n"
        "    .locals 2\n\n"
        "    .prologue\n"
        "    .line 7\n"
        "    invoke-direct {p0}, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "userdictionary/UserDictExportTask;->openDictionaries()"
        "[Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;\n\n"
        "    move-result-object v0\n\n"
        "    .line 8\n"
        "    invoke-direct {p0, v0}, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "userdictionary/UserDictExportTask;->exportUserDictionary("
        "[Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;)Z\n\n"
        "    move-result v1\n\n"
        "    .line 9\n"
        "    invoke-direct {p0, v0}, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "userdictionary/UserDictExportTask;->closeDictionaries("
        "[Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;)V\n\n"
        "    .line 10\n"
        "    invoke-static {v1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;\n\n"
        "    move-result-object v0\n\n"
        "    return-object v0\n"
        ".end method",
        ".method protected varargs doInBackground([Ljava/lang/Void;)Ljava/lang/Boolean;\n"
        "    .locals 4\n\n"
        "    .prologue\n"
        "    sget-object v2, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "SaveDictionaryTask;->sSaveLock:Ljava/lang/Object;\n\n"
        "    monitor-enter v2\n\n"
        "    :try_start_export_lock\n"
        "    .line 7\n"
        "    invoke-direct {p0}, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "userdictionary/UserDictExportTask;->openDictionaries()"
        "[Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;\n\n"
        "    move-result-object v0\n\n"
        "    .line 8\n"
        "    invoke-direct {p0, v0}, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "userdictionary/UserDictExportTask;->exportUserDictionary("
        "[Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;)Z\n\n"
        "    move-result v1\n\n"
        "    .line 9\n"
        "    invoke-direct {p0, v0}, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "userdictionary/UserDictExportTask;->closeDictionaries("
        "[Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;)V\n\n"
        "    .line 10\n"
        "    invoke-static {v1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;\n\n"
        "    move-result-object v0\n"
        "    :try_end_export_lock\n"
        "    .catchall {:try_start_export_lock .. :try_end_export_lock} "
        ":catchall_export_lock\n\n"
        "    monitor-exit v2\n\n"
        "    return-object v0\n\n"
        "    :catchall_export_lock\n"
        "    move-exception v3\n\n"
        "    monitor-exit v2\n\n"
        "    throw v3\n"
        ".end method",
    )

    # Retained rolling backups must not resurrect data after an intentional
    # dictionary deletion. Purge sidecars only when main was deleted or is
    # already absent; preserve them if deletion itself failed.
    replace_once(
        engine_factory,
        "    invoke-virtual {v1}, Ljava/io/File;->delete()Z\n\n"
        "    move-result v1\n\n"
        "    .line 358\n"
        "    sget-boolean v2, Laik;->b:Z",
        "    move-object v3, v1\n\n"
        "    invoke-virtual {v3}, Ljava/io/File;->delete()Z\n\n"
        "    move-result v1\n\n"
        "    if-nez v1, :purge_deleted_dictionary_sidecars\n\n"
        "    invoke-virtual {v3}, Ljava/io/File;->exists()Z\n\n"
        "    move-result v2\n\n"
        "    if-nez v2, :skip_deleted_dictionary_sidecars\n\n"
        "    :purge_deleted_dictionary_sidecars\n"
        "    invoke-virtual {p0, v0}, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;->getMutableDictionaryFileName(Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$MutableDictionaryType;)Ljava/lang/String;\n\n"
        "    move-result-object v2\n\n"
        "    invoke-static {p1, v2}, Lcom/google/android/inputmethod/pinyin/DictionaryRecoveryCompat;->purgeSidecars(Landroid/content/Context;Ljava/lang/String;)V\n\n"
        "    :skip_deleted_dictionary_sidecars\n"
        "    .line 358\n"
        "    sget-boolean v2, Laik;->b:Z",
    )

    # A user-requested clear is destructive: once the empty dictionary has
    # persisted successfully, remove the previous non-empty rolling copy and
    # any stale recovery artifacts.
    user_dict_clear_task = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/hmm/sync/UserDictClearTask.smali"
    )
    replace_once(
        user_dict_clear_task,
        "    if-eqz v7, :cond_1\n\n"
        "    .line 28\n"
        "    sget-object v7, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$MutableDictionaryType;->USER_DICTIONARY:Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$MutableDictionaryType;",
        "    if-eqz v7, :cond_1\n\n"
        "    iget-object v7, p0, Lcom/google/android/apps/inputmethod/libs/hmm/sync/UserDictClearTask;->mContext:Landroid/content/Context;\n\n"
        "    invoke-virtual {v4, v8}, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;->getMutableDictionaryFileName(Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$MutableDictionaryType;)Ljava/lang/String;\n\n"
        "    move-result-object v9\n\n"
        "    invoke-static {v7, v9}, Lcom/google/android/inputmethod/pinyin/DictionaryRecoveryCompat;->purgeSidecars(Landroid/content/Context;Ljava/lang/String;)V\n\n"
        "    .line 28\n"
        "    sget-object v7, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$MutableDictionaryType;->USER_DICTIONARY:Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$MutableDictionaryType;",
    )

    # Use a distinct application ID so the compatibility build can coexist
    # with the official Google-signed package for side-by-side comparison.
    manifest = decoded / "AndroidManifest.xml"
    replace_once(
        manifest,
        'package="com.google.android.inputmethod.pinyin"',
        f'package="{application_id}"',
    )
    replace_once(
        manifest,
        'android:authorities="com.google.android.inputmethod.pinyin.user_dictionary"',
        f'android:authorities="{application_id}.user_dictionary"',
    )
    replace_once(
        decoded / "res/values/strings.xml",
        '<string name="user_dictionary_authority">com.google.android.inputmethod.pinyin.user_dictionary</string>',
        f'<string name="user_dictionary_authority">{application_id}.user_dictionary</string>',
    )
    replace_once(
        decoded / "smali/ayn.smali",
        '    const-string v2, "com.google.android.inputmethod.pinyin"',
        f'    const-string v2, "{application_id}"',
    )

    for obsolete_component in (
        '        <activity android:exported="false" android:name="com.google.android.apps.inputmethod.pinyin.preference.PinyinUserFeedbackActivity"/>\n',
        '        <activity android:excludeFromRecents="true" android:name="com.google.userfeedback.android.api.UserFeedbackActivity" android:theme="@android:style/Theme.Dialog"/>\n',
        '        <activity android:excludeFromRecents="true" android:name="com.google.userfeedback.android.api.PreviewActivity" android:theme="@android:style/Theme.Dialog"/>\n',
        '        <activity android:excludeFromRecents="true" android:name="com.google.userfeedback.android.api.ShowTextActivity" android:theme="@android:style/Theme.Dialog"/>\n',
        '        <activity android:excludeFromRecents="true" android:name="com.google.userfeedback.android.api.ShowStringListActivity" android:theme="@android:style/Theme.Dialog"/>\n',
        '        <service android:name="com.google.userfeedback.android.api.SendUserFeedbackService"/>\n',
        '        <receiver android:exported="true" android:name="com.google.firebase.iid.FirebaseInstanceIdReceiver" android:permission="com.google.android.c2dm.permission.SEND">\n            <intent-filter>\n                <action android:name="com.google.android.c2dm.intent.RECEIVE"/>\n                <action android:name="com.google.android.c2dm.intent.REGISTRATION"/>\n            </intent-filter>\n        </receiver>\n',
        '        <receiver android:exported="false" android:name="com.google.firebase.iid.FirebaseInstanceIdInternalReceiver"/>\n',
        '        <service android:exported="true" android:name="com.google.firebase.iid.FirebaseInstanceIdService">\n            <intent-filter android:priority="-500">\n                <action android:name="com.google.firebase.INSTANCE_ID_EVENT"/>\n            </intent-filter>\n        </service>\n',
        '        <service android:exported="true" android:name="com.firebase.jobdispatcher.GooglePlayReceiver" android:permission="com.google.android.gms.permission.BIND_NETWORK_TASK_SERVICE">\n            <intent-filter>\n                <action android:name="com.google.android.gms.gcm.ACTION_TASK_READY"/>\n            </intent-filter>\n        </service>\n',
    ):
        replace_once(manifest, obsolete_component, "")

    replace_once(
        manifest,
        '<service android:directBootAware="true" android:label="@string/ime_name_ref" '
        'android:name="com.google.android.inputmethod.pinyin.PinyinIME" '
        'android:permission="android.permission.BIND_INPUT_METHOD">',
        '<service android:directBootAware="true" android:exported="true" '
        'android:label="@string/ime_name_ref" '
        'android:name="com.google.android.inputmethod.pinyin.PinyinIME" '
        'android:permission="android.permission.BIND_INPUT_METHOD">',
    )
    replace_once(
        manifest,
        '<activity android:enabled="@bool/show_launcher_icon" '
        'android:label="@string/ime_name_ref" '
        'android:name="com.google.android.apps.inputmethod.libs.framework.core.LauncherActivity" '
        'android:theme="@style/SettingsTheme.Transparent">',
        '<activity android:enabled="@bool/show_launcher_icon" android:exported="true" '
        'android:label="@string/ime_name_ref" '
        'android:name="com.google.android.apps.inputmethod.libs.framework.core.LauncherActivity" '
        'android:theme="@style/SettingsTheme.Transparent">',
    )
    replace_once(
        manifest,
        '    </application>\n</manifest>',
        '        <activity android:exported="true" '
        'android:label="@string/dictionary_auto_backup_import_title" '
        'android:name="com.google.android.inputmethod.pinyin.LocalBackupImportActivity">\n'
        '            <intent-filter>\n'
        '                <action android:name="android.intent.action.VIEW"/>\n'
        '                <category android:name="android.intent.category.DEFAULT"/>\n'
        '                <data android:mimeType="text/plain"/>\n'
        '            </intent-filter>\n'
        '            <intent-filter>\n'
        '                <action android:name="android.intent.action.SEND"/>\n'
        '                <category android:name="android.intent.category.DEFAULT"/>\n'
        '                <data android:mimeType="text/plain"/>\n'
        '            </intent-filter>\n'
        '        </activity>\n'
        '    </application>\n</manifest>',
    )

    replace_once(
        manifest,
        '<receiver android:name="com.google.android.apps.inputmethod.libs.framework.core.'
        'LauncherIconVisibilityInitializer">',
        '<receiver android:exported="false" '
        'android:name="com.google.android.apps.inputmethod.libs.framework.core.'
        'LauncherIconVisibilityInitializer">',
    )

    replace_once(
        pinyin_ime,
        "    .line 75\n"
        "    invoke-super {p0, p1, p2}, Labp;->onStartInputView("
        "Landroid/view/inputmethod/EditorInfo;Z)V\n\n"
        "    .line 77",
        "    .line 75\n"
        "    invoke-super {p0, p1, p2}, Labp;->onStartInputView("
        "Landroid/view/inputmethod/EditorInfo;Z)V\n\n"
        "    # Android 16: match the navigation area to the keyboard theme.\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/NavigationBarCompat;"
        "->apply(Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "GoogleInputMethodService;)V\n\n"
        "    # Present recent, non-sensitive clipboard text as a native candidate.\n"
        "    invoke-static {p0, p1}, Lcom/google/android/apps/inputmethod/libs/framework/"
        "core/ClipboardCandidateCompat;->start(Lcom/google/android/apps/inputmethod/libs/"
        "framework/core/GoogleInputMethodService;Landroid/view/inputmethod/EditorInfo;)V\n\n"
        "    .line 77",
    )

    framework = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/framework/core/"
        "GoogleInputMethodService.smali"
    )
    replace_once(
        framework,
        "    .line 1783\n"
        "    invoke-virtual {v2, v1}, Landroid/view/Window;->setNavigationBarColor(I)V\n\n"
        "    goto/16 :goto_0",
        "    .line 1783\n"
        "    invoke-virtual {v2, v1}, Landroid/view/Window;->setNavigationBarColor(I)V\n\n"
        "    # Candidate/extension updates reset the old IME navigation bar.\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/NavigationBarCompat;"
        "->apply(Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "GoogleInputMethodService;)V\n\n"
        "    goto/16 :goto_0",
    )

    # Stop observing the clipboard as soon as the input view is no longer active.
    replace_once(
        pinyin_ime,
        "    .line 96\n"
        "    invoke-super {p0, p1}, Labp;->onFinishInputView(Z)V\n\n"
        "    .line 98",
        "    .line 96\n"
        "    invoke-static {p0}, Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "ClipboardCandidateCompat;->stop(Lcom/google/android/apps/inputmethod/libs/"
        "framework/core/GoogleInputMethodService;)V\n\n"
        "    invoke-super {p0, p1}, Labp;->onFinishInputView(Z)V\n\n"
        "    .line 98",
    )

    input_bundle = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/framework/core/InputBundle.smali"
    )
    # Intercept both candidate-selection paths before a custom payload can
    # reach an HMM implementation that requires an Integer payload.
    replace_once(
        input_bundle,
        "    iget-object v0, v4, Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "KeyData;->a:Ljava/lang/Object;\n\n"
        "    check-cast v0, Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "Candidate;\n\n"
        "    .line 256",
        "    iget-object v0, v4, Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "KeyData;->a:Ljava/lang/Object;\n\n"
        "    check-cast v0, Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "Candidate;\n\n"
        "    invoke-static {p0, v0}, Lcom/google/android/apps/inputmethod/libs/framework/"
        "core/ClipboardCandidateCompat;->handleSelection(Lcom/google/android/apps/"
        "inputmethod/libs/framework/core/InputBundle;Lcom/google/android/apps/inputmethod/"
        "libs/framework/core/Candidate;)Z\n\n"
        "    move-result v1\n\n"
        "    if-eqz v1, :compat_not_clipboard_event\n\n"
        "    move v0, v2\n\n"
        "    goto/16 :goto_0\n\n"
        "    :compat_not_clipboard_event\n"
        "    .line 256",
    )
    # Decorate the first batch of every native candidate cycle. This keeps the
    # clipboard item present when Chinese, English or handwriting candidates
    # replace the initially displayed idle candidate, without duplicating it in
    # later pagination batches.
    replace_once(
        input_bundle,
        "    .prologue\n"
        "    .line 549\n"
        "    iget v0, p0, Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "InputBundle;->b:I",
        "    .prologue\n"
        "    invoke-static {p1}, Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "ClipboardCandidateCompat;->decorateCandidates(Ljava/util/List;)Ljava/util/List;\n\n"
        "    move-result-object p1\n\n"
        "    .line 549\n"
        "    iget v0, p0, Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "InputBundle;->b:I",
    )
    replace_once(
        input_bundle,
        "    .prologue\n"
        "    .line 545\n"
        "    const/4 v0, 0x0",
        "    .prologue\n"
        "    invoke-static {}, Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "ClipboardCandidateCompat;->candidatesUpdated()V\n\n"
        "    .line 545\n"
        "    const/4 v0, 0x0",
    )

    fixed_candidates = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/framework/keyboard/widget/"
        "FixedSizeCandidatesHolderView.smali"
    )
    replace_once(
        fixed_candidates,
        ".method public appendCandidates(Ljava/util/List;)I\n    .locals 11",
        ".method public appendCandidates(Ljava/util/List;)I\n    .locals 12",
    )
    replace_once(
        fixed_candidates,
        "    iget-object v9, p0, Lcom/google/android/apps/inputmethod/libs/framework/"
        "keyboard/widget/FixedSizeCandidatesHolderView;->a:Lavp;\n\n"
        "    iget v10, p0, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/"
        "widget/FixedSizeCandidatesHolderView;->c:I\n\n"
        "    .line 62",
        "    move-object v11, v5\n\n"
        "    iget-object v9, p0, Lcom/google/android/apps/inputmethod/libs/framework/"
        "keyboard/widget/FixedSizeCandidatesHolderView;->a:Lavp;\n\n"
        "    iget v10, p0, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/"
        "widget/FixedSizeCandidatesHolderView;->c:I\n\n"
        "    .line 62",
    )
    replace_once(
        fixed_candidates,
        "    invoke-virtual {v4, v5, v2}, Lcom/google/android/apps/inputmethod/libs/"
        "framework/keyboard/SoftKeyView;->a(IZ)V\n\n"
        "    .line 70",
        "    invoke-virtual {v4, v5, v2}, Lcom/google/android/apps/inputmethod/libs/"
        "framework/keyboard/SoftKeyView;->a(IZ)V\n\n"
        "    invoke-static {v4, v11}, Lcom/google/android/apps/inputmethod/libs/framework/"
        "core/ClipboardCandidateCompat;->decorateView(Lcom/google/android/apps/inputmethod/"
        "libs/framework/keyboard/SoftKeyView;Lcom/google/android/apps/inputmethod/libs/"
        "framework/core/Candidate;)V\n\n"
        "    .line 70",
    )
    replace_once(
        fixed_candidates,
        "    .line 135\n"
        "    :cond_16\n"
        "    iget v0, p0, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/"
        "widget/FixedSizeCandidatesHolderView;->c:I",
        "    .line 135\n"
        "    :cond_16\n"
        "    invoke-static {p0}, Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "ClipboardCandidateCompat;->centerSingleClipboardCandidate(Lcom/google/android/"
        "apps/inputmethod/libs/framework/keyboard/widget/"
        "FixedSizeCandidatesHolderView;)V\n\n"
        "    iget v0, p0, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/"
        "widget/FixedSizeCandidatesHolderView;->c:I",
    )
    replace_once(
        input_bundle,
        ".method public selectTextCandidate(Lcom/google/android/apps/inputmethod/libs/"
        "framework/core/Candidate;Z)V\n"
        "    .locals 4\n\n"
        "    .prologue\n"
        "    const/4 v3, 0x0\n\n"
        "    .line 502",
        ".method public selectTextCandidate(Lcom/google/android/apps/inputmethod/libs/"
        "framework/core/Candidate;Z)V\n"
        "    .locals 4\n\n"
        "    .prologue\n"
        "    const/4 v3, 0x0\n\n"
        "    invoke-static {p0, p1}, Lcom/google/android/apps/inputmethod/libs/framework/"
        "core/ClipboardCandidateCompat;->handleSelection(Lcom/google/android/apps/"
        "inputmethod/libs/framework/core/InputBundle;Lcom/google/android/apps/inputmethod/"
        "libs/framework/core/Candidate;)Z\n\n"
        "    move-result v0\n\n"
        "    if-nez v0, :cond_3\n\n"
        "    .line 502",
    )

    for helper_name in (
        "NavigationBarCompat.smali",
        "ScrollTouchCompat.smali",
        "DictionaryRecoveryCompat.smali",
    ):
        helper_src = ROOT / "patches/smali" / helper_name
        helper_dst = decoded / "smali/com/google/android/inputmethod/pinyin" / helper_name
        if helper_dst.exists():
            raise RuntimeError(f"Refusing to overwrite existing helper: {helper_dst}")
        helper_dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(helper_src, helper_dst)

    auto_backup_helpers = sorted(
        list((ROOT / "patches/smali").glob("DictionaryAutoBackup*.smali"))
        + list((ROOT / "patches/smali").glob("LocalBackupImportActivity*.smali"))
    )
    if not auto_backup_helpers:
        raise RuntimeError("Missing generated dictionary auto-backup helpers")
    for helper_src in auto_backup_helpers:
        helper_dst = decoded / "smali/com/google/android/inputmethod/pinyin" / helper_src.name
        if helper_dst.exists():
            raise RuntimeError(f"Refusing to overwrite existing helper: {helper_dst}")
        shutil.copyfile(helper_src, helper_dst)

    dictionary_fragment_src = ROOT / "patches/smali/DictionarySettingsFragment.smali"
    dictionary_fragment_dst = decoded / (
        "smali/com/google/android/apps/inputmethod/pinyin/preference/"
        "DictionarySettingsFragment.smali"
    )
    if not dictionary_fragment_dst.exists():
        raise RuntimeError(f"Missing dictionary settings fragment: {dictionary_fragment_dst}")
    shutil.copyfile(dictionary_fragment_src, dictionary_fragment_dst)

    first_run_helpers = (
        (
            "FirstRunNavigationCompat.smali",
            "smali/com/google/android/apps/inputmethod/pinyin/firstrun/"
            "FirstRunNavigationCompat.smali",
        ),
        (
            "NonSwipeableFirstRunViewPager.smali",
            "smali/com/google/android/apps/inputmethod/libs/framework/firstrun/"
            "NonSwipeableFirstRunViewPager.smali",
        ),
    )
    for helper_name, relative_destination in first_run_helpers:
        helper_src = ROOT / "patches/smali" / helper_name
        helper_dst = decoded / relative_destination
        if helper_dst.exists():
            raise RuntimeError(f"Refusing to overwrite existing helper: {helper_dst}")
        helper_dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(helper_src, helper_dst)

    candidate_src = ROOT / "patches/smali/ClipboardCandidateCompat.smali"
    candidate_dst = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/framework/core/"
        "ClipboardCandidateCompat.smali"
    )
    if candidate_dst.exists():
        raise RuntimeError(f"Refusing to overwrite existing helper: {candidate_dst}")
    shutil.copyfile(candidate_src, candidate_dst)

    print(f"Applied Google Pinyin compatibility 4.5.2 to {decoded} ({application_id})")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("decoded", type=Path, help="apktool decoded directory")
    parser.add_argument(
        "--application-id",
        default="com.google.android.inputmethod.pinyin.compat",
        help="application ID for coexistence builds",
    )
    args = parser.parse_args()
    apply(args.decoded.resolve(), args.application_id)


if __name__ == "__main__":
    main()
