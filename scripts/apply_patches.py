#!/usr/bin/env python3
"""Apply the Android 16 compatibility v5 patch to apktool 2.12.1 output.

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


def apply(decoded: Path) -> None:
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
        "versionInfo:\n  versionCode: 4520317\n"
        "  versionName: 4.5.2.193126728-arm64-v8a-a16compat5",
    )

    arrays = decoded / "res/values/arrays.xml"
    replace_once(
        arrays,
        "        <item>@layout/first_run_page_permission</item>\n"
        "        <item>@layout/first_run_page_setup_user_metrics</item>\n"
        "        <item>@layout/first_run_page_done</item>",
        "        <item>@layout/first_run_page_permission</item>\n"
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
            "first_run_page_done.xml",
            "first_run_page_indicator_image.xml",
        }
        if destination.exists() and source.name not in overwritten_layouts:
            raise RuntimeError(f"Refusing to overwrite resource: {destination}")
        shutil.copyfile(source, destination)

    # Android only permits INTERSECT and DIFFERENCE for Canvas clipping on
    # current releases. The legacy handwriting/gesture renderers use REPLACE,
    # which throws IllegalArgumentException as soon as a stroke starts.
    replace_exactly(
        decoded / "smali/ayc.smali",
        "Landroid/graphics/Region$Op;->REPLACE:Landroid/graphics/Region$Op;",
        "Landroid/graphics/Region$Op;->INTERSECT:Landroid/graphics/Region$Op;",
        3,
    )
    for relative in (
        "smali/aye.smali",
        "smali/com/google/android/apps/inputmethod/libs/gestureui/"
        "GestureOverlayView$a.smali",
        "smali/com/google/android/apps/inputmethod/libs/handwriting/keyboard/"
        "HandwritingOverlayView.smali",
    ):
        replace_exactly(
            decoded / relative,
            "Landroid/graphics/Region$Op;->REPLACE:Landroid/graphics/Region$Op;",
            "Landroid/graphics/Region$Op;->INTERSECT:Landroid/graphics/Region$Op;",
            1,
        )

    # REPLACE did not accumulate clipping between points. INTERSECT does, so
    # isolate each renderer clip with save/restore; otherwise recognition works
    # but almost the entire stroke is clipped out and remains invisible.
    stroke_renderer = decoded / "smali/ayc.smali"
    for clip_call in (
        "    invoke-virtual {p2, v1, v2}, Landroid/graphics/Canvas;->clipRect("
        "Landroid/graphics/RectF;Landroid/graphics/Region$Op;)Z",
        "    invoke-virtual {p2, v0, v1}, Landroid/graphics/Canvas;->clipRect("
        "Landroid/graphics/RectF;Landroid/graphics/Region$Op;)Z",
        "    invoke-virtual {p2, v6, v1}, Landroid/graphics/Canvas;->clipRect("
        "Landroid/graphics/RectF;Landroid/graphics/Region$Op;)Z",
    ):
        replace_once(
            stroke_renderer,
            clip_call,
            "    invoke-virtual {p2}, Landroid/graphics/Canvas;->save()I\n\n"
            + clip_call,
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

    # Always use the complete first-run page set. The old activation-only
    # branch produced two indicators, then restarted with four after IME select.
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
    iget-object v0, p0, Lapy;->a:[Ljava/lang/String;

    array-length v0, v0

    if-lez v0, :without_permission

    const v0, 0x7f0a0018

    return v0

    :without_permission
    const v0, 0x7f0a0019

    return v0
.end method"""
    replace_once(first_run_activity, old_page_selector, new_page_selector)
    replace_once(
        first_run_activity,
        "\n\n# virtual methods\n.method protected final a()I",
        "\n\n# virtual methods\n.method public onBackPressed()V\n"
        "    .locals 0\n\n"
        "    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/"
        "PinyinFirstRunActivity;->finishAndRemoveTask()V\n\n"
        "    return-void\n"
        ".end method\n\n"
        ".method protected final a()I",
    )

    # Closing or pressing Back must remove the setup task instead of revealing
    # the legacy settings activity that launched the first-run screen.
    for listener in ("smali/aqb.smali", "smali/aqe.smali"):
        replace_once(
            decoded / listener,
            "    invoke-virtual {v0}, Lapy;->finish()V",
            "    invoke-virtual {v0}, Lapy;->finishAndRemoveTask()V",
        )

    # The old scroll containers changed ACTION_UP to ACTION_CANCEL only after
    # dispatching it. Android 16 therefore clicked the item under the finger at
    # the end of a candidate/punctuation scroll. Cancel before handling UP.
    scroll_holder = decoded / "smali/awo.smali"
    replace_once(
        scroll_holder,
        """    .line 14
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
    return v0""",
        """    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :dispatch

    iget-object v0, p0, Lawo;->a:Lawp;

    iget-boolean v0, v0, Lawp;->a:Z

    if-eqz v0, :dispatch

    const/4 v0, 0x3

    invoke-virtual {p1, v0}, Landroid/view/MotionEvent;->setAction(I)V

    :dispatch
    invoke-super {p0, p1}, Landroid/widget/ScrollView;->onTouchEvent(Landroid/view/MotionEvent;)Z

    move-result v0

    iget-object v1, p0, Lawo;->a:Landroid/view/GestureDetector;

    invoke-virtual {v1, p1}, Landroid/view/GestureDetector;->onTouchEvent(Landroid/view/MotionEvent;)Z

    return v0""",
    )

    for relative, class_name, metrics_line in (
        (
            "smali/com/google/android/apps/inputmethod/libs/framework/keyboard/widget/"
            "PageableCandidatesHolderView.smali",
            "PageableCandidatesHolderView",
            72,
        ),
        (
            "smali/com/google/android/apps/inputmethod/libs/framework/keyboard/widget/"
            "PageableSoftKeyListHolderView.smali",
            "PageableSoftKeyListHolderView",
            52,
        ),
    ):
        path = decoded / relative
        old = (
            "    invoke-super {p0, p1}, Llk;->onTouchEvent(Landroid/view/MotionEvent;)Z\n\n"
            "    move-result v0\n\n"
            f"    .line {metrics_line}\n"
            f"    iget-object v1, p0, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/{class_name};->a:Laws;\n\n"
            "    invoke-virtual {v1, p1}, Laws;->a(Landroid/view/MotionEvent;)V"
        )
        new = (
            "    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I\n\n"
            "    move-result v0\n\n"
            "    const/4 v1, 0x1\n\n"
            "    if-ne v0, v1, :normal_dispatch\n\n"
            f"    iget-object v1, p0, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/{class_name};->a:Laws;\n\n"
            "    invoke-virtual {v1, p1}, Laws;->a(Landroid/view/MotionEvent;)V\n\n"
            "    invoke-super {p0, p1}, Llk;->onTouchEvent(Landroid/view/MotionEvent;)Z\n\n"
            "    move-result v0\n\n"
            "    return v0\n\n"
            "    :normal_dispatch\n"
            "    invoke-super {p0, p1}, Llk;->onTouchEvent(Landroid/view/MotionEvent;)Z\n\n"
            "    move-result v0\n\n"
            f"    iget-object v1, p0, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/{class_name};->a:Laws;\n\n"
            "    invoke-virtual {v1, p1}, Laws;->a(Landroid/view/MotionEvent;)V"
        )
        replace_once(path, old, new)

    manifest = decoded / "AndroidManifest.xml"
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
        '<receiver android:name="com.google.android.apps.inputmethod.libs.framework.core.'
        'LauncherIconVisibilityInitializer">',
        '<receiver android:exported="false" '
        'android:name="com.google.android.apps.inputmethod.libs.framework.core.'
        'LauncherIconVisibilityInitializer">',
    )

    pinyin_ime = decoded / "smali/com/google/android/inputmethod/pinyin/PinyinIME.smali"
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

    helper_src = ROOT / "patches/smali/NavigationBarCompat.smali"
    helper_dst = decoded / "smali/com/google/android/inputmethod/pinyin/NavigationBarCompat.smali"
    if helper_dst.exists():
        raise RuntimeError(f"Refusing to overwrite existing helper: {helper_dst}")
    helper_dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(helper_src, helper_dst)

    print(f"Applied compatibility v5 patches to {decoded}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("decoded", type=Path, help="apktool decoded directory")
    args = parser.parse_args()
    apply(args.decoded.resolve())


if __name__ == "__main__":
    main()
