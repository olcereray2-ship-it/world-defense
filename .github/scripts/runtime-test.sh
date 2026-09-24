#!/usr/bin/env bash
set -euo pipefail
API="$1"
PROFILE="$2"
OUT="runtime-${API}-${PROFILE}"
PKG="com.ahmeterayolcer.worlddefense"
mkdir -p "$OUT"
adb wait-for-device
adb shell getprop ro.build.version.sdk | tee "$OUT/sdk.txt"
adb install -r -t builds/World-Defense-runtime.apk | tee "$OUT/install.txt"
adb shell pm clear "$PKG" || true
adb shell run-as "$PKG" mkdir -p files
adb shell run-as "$PKG" touch files/qa_fast.flag
adb logcat -b all -c >/dev/null 2>&1 || true
adb shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 | tee "$OUT/launch.txt"
for _ in $(seq 1 30); do
  adb logcat -d -v brief > "$OUT/logcat.txt"
  grep -q "WORLD_DEFENSE_MAIN_MENU_READY" "$OUT/logcat.txt" && break
  sleep 1
done
grep -q "WORLD_DEFENSE_MAIN_MENU_READY" "$OUT/logcat.txt"
SIZE=$(adb shell wm size | tail -n 1 | tr -d '\r')
WH=${SIZE##*: }
W=${WH%x*}; H=${WH#*x}
tap_pct() { adb shell input tap $((W*$1/1000)) $((H*$2/1000)); sleep 1; }
tap_pct 250 250
tap_pct 750 250
tap_pct 250 390
tap_pct 750 390
adb logcat -d -v brief > "$OUT/menu-buttons.txt"
for marker in DEFENSE ARMY BASE INTEL; do grep -q "WORLD_DEFENSE_BUTTON_${marker}" "$OUT/menu-buttons.txt"; done
tap_pct 500 800
for _ in $(seq 1 20); do
  adb logcat -d -v brief > "$OUT/battle-log.txt"
  grep -q "WORLD_DEFENSE_WAVE_5_STAGE_1" "$OUT/battle-log.txt" && break
  sleep 1
done
for marker in WORLD_DEFENSE_BUTTON_PLAY WORLD_DEFENSE_BATTLE_READY_STAGE_1 WORLD_DEFENSE_WAVE_1_STAGE_1 WORLD_DEFENSE_WAVE_2_STAGE_1 WORLD_DEFENSE_WAVE_3_STAGE_1 WORLD_DEFENSE_WAVE_4_STAGE_1 WORLD_DEFENSE_WAVE_5_STAGE_1; do grep -q "$marker" "$OUT/battle-log.txt"; done
grep -Eq "WORLD_DEFENSE_WAVE_[345]_STAGE_1_ENEMIES_[0-9]+_AIR_[1-9]" "$OUT/battle-log.txt"
adb exec-out screencap -p > "$OUT/battle-screen.png" || true
adb shell am force-stop "$PKG"
adb shell run-as "$PKG" touch files/qa.flag
adb logcat -b all -c >/dev/null 2>&1 || true
adb shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 > "$OUT/qa-launch.txt"
for _ in $(seq 1 90); do
  adb logcat -d -v threadtime > "$OUT/deep-qa-android.txt"
  grep -q "WORLD_DEFENSE_DEEP_QA_OK" "$OUT/deep-qa-android.txt" && break
  sleep 1
done
for marker in WORLD_DEFENSE_QA_BOOT WORLD_DEFENSE_DEEP_QA_BEGIN WORLD_DEFENSE_DEEP_QA_OK; do grep -q "$marker" "$OUT/deep-qa-android.txt"; done
adb shell dumpsys activity activities > "$OUT/activity.txt" || true
adb logcat -d -v threadtime > "$OUT/logcat-full.txt"
if grep -E "FATAL EXCEPTION|Fatal signal|SIGSEGV|SIGABRT" "$OUT/logcat-full.txt"; then echo "Fatal runtime error detected"; exit 1; fi
echo "FULL_RUNTIME_QA_OK api=$API profile=$PROFILE" | tee "$OUT/result.txt"
