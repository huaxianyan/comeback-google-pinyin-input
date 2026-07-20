#!/usr/bin/env python3
"""Apply the Android 16 compatibility v4 patch to apktool 2.12.1 output.

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
        "versionInfo:\n  versionCode: 4520316\n"
        "  versionName: 4.5.2.193126728-arm64-v8a-a16compat4",
    )

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

    print(f"Applied compatibility v4 patches to {decoded}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("decoded", type=Path, help="apktool decoded directory")
    args = parser.parse_args()
    apply(args.decoded.resolve())


if __name__ == "__main__":
    main()
