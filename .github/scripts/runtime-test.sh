#!/usr/bin/env bash
set -euo pipefail
API="$1"
PROFILE="$2"
OUT="runtime-$API-$PROFILE"
PKG="com.ahmeterayolcer.worlddefense"
mkdir -p "$OUT"

adb wait-for-device
adb shell getprop ro.build.version.sdk | tee "$OUT/sdk.txt"
adb shell getprop ro.product.model | tee "$OUT/emulator-model.txt"
adb shell wm size | tee "$OUT/wm-size.txt"
adb shell wm density | tee "$OUT/wm-density.txt"

adb install -r -t builds/World-Defense-runtime.apk | tee "$OUT/install.txt"
adb shell pm path "$PKG" | tee "$OUT/package-path.txt"
grep -q "package:" "$OUT/package-path.txt"
adb shell dumpsys package "$PKG" > "$OUT/package.txt"

adb shell pm clear "$PKG" || true
adb shell run-as "$PKG" mkdir -p files
adb shell run-as "$PKG" touch files/qa_fast.flag
adb logcat -b all -c >/dev/null 2>&1 || true

adb shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 | tee "$OUT/launch.txt"
for i in $(seq 1 40); do
  adb logcat -d -v brief > "$OUT/menu-log.txt"
  if grep -q "WORLD_DEFENSE_MAIN_MENU_READY" "$OUT/menu-log.txt"; then
    echo "MAIN_MENU_READY_AT_SECOND=$i" | tee "$OUT/menu-ready.txt"
    break
  fi
  sleep 1
done
grep -q "WORLD_DEFENSE_BOOT_READY" "$OUT/menu-log.txt"
grep -q "WORLD_DEFENSE_BOOT_TO_MENU" "$OUT/menu-log.txt"
grep -q "WORLD_DEFENSE_MAIN_MENU_READY" "$OUT/menu-log.txt"
adb shell pidof "$PKG" | tee "$OUT/pid-menu.txt"
test -s "$OUT/pid-menu.txt"
adb exec-out screencap -p > "$OUT/menu-screen.png"
test $(stat -c '%s' "$OUT/menu-screen.png") -gt 1000

SIZE=$(adb shell wm size | tail -n 1 | tr -d '\r')
WH=$(printf '%s' "$SIZE" | sed 's/.*: //')
W=$(printf '%s' "$WH" | cut -dx -f1)
H=$(printf '%s' "$WH" | cut -dx -f2)
tap_pct() {
  adb shell input tap $((W*$1/1000)) $((H*$2/1000))
  sleep 1
}

tap_pct 250 250
tap_pct 750 250
tap_pct 250 390
tap_pct 750 390
adb logcat -d -v brief > "$OUT/menu-buttons.txt"
for marker in DEFENSE ARMY BASE INTEL; do
  grep -q "WORLD_DEFENSE_BUTTON_$marker" "$OUT/menu-buttons.txt"
done

adb shell input keyevent KEYCODE_HOME
sleep 2
adb shell pidof "$PKG" > "$OUT/pid-background.txt" || true
adb shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 > "$OUT/resume.txt"
sleep 2
adb shell pidof "$PKG" | tee "$OUT/pid-resume.txt"
test -s "$OUT/pid-resume.txt"

tap_pct 500 800
for i in $(seq 1 20); do
  adb logcat -d -v brief > "$OUT/battle-log.txt"
  grep -q "WORLD_DEFENSE_BATTLE_READY_STAGE_1" "$OUT/battle-log.txt" && break
  sleep 1
done
grep -q "WORLD_DEFENSE_BUTTON_PLAY" "$OUT/battle-log.txt"
grep -q "WORLD_DEFENSE_BATTLE_READY_STAGE_1" "$OUT/battle-log.txt"

tap_pct 170 910
tap_pct 480 910
tap_pct 780 910
adb logcat -d -v brief > "$OUT/ability-log.txt"
grep -q "WORLD_DEFENSE_ABILITY_AIRSTRIKE" "$OUT/ability-log.txt"
grep -q "WORLD_DEFENSE_ABILITY_REINFORCEMENT" "$OUT/ability-log.txt"
grep -q "WORLD_DEFENSE_ABILITY_EMP" "$OUT/ability-log.txt"

for i in $(seq 1 25); do
  adb logcat -d -v brief > "$OUT/battle-log.txt"
  grep -q "WORLD_DEFENSE_WAVE_5_STAGE_1" "$OUT/battle-log.txt" && break
  sleep 1
done
for w in 1 2 3 4 5; do
  grep -q "WORLD_DEFENSE_WAVE_"$w"_STAGE_1" "$OUT/battle-log.txt"
done
grep -q "WORLD_DEFENSE_FRIENDLY_COUNT_1_STAGE_1" "$OUT/battle-log.txt"
adb shell pidof "$PKG" | tee "$OUT/pid-battle.txt"
test -s "$OUT/pid-battle.txt"
adb exec-out screencap -p > "$OUT/battle-screen.png"
test $(stat -c '%s' "$OUT/battle-screen.png") -gt 1000

adb shell dumpsys meminfo "$PKG" > "$OUT/meminfo.txt" || true
adb shell dumpsys gfxinfo "$PKG" > "$OUT/gfxinfo.txt" || true
adb shell dumpsys activity activities > "$OUT/activity-before-qa.txt" || true

adb shell am force-stop "$PKG"
adb shell run-as "$PKG" touch files/qa.flag
adb logcat -b all -c >/dev/null 2>&1 || true
adb shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 > "$OUT/qa-launch.txt"

for i in $(seq 1 150); do
  adb logcat -d -v threadtime > "$OUT/deep-qa-android.txt"
  if grep -q "WORLD_DEFENSE_DEEP_QA_OK" "$OUT/deep-qa-android.txt"; then
    echo "DEEP_QA_OK_AT_SECOND=$i" | tee "$OUT/deep-qa-ready.txt"
    break
  fi
  if grep -q "WORLD_DEFENSE_DEEP_QA_FAIL_COUNT" "$OUT/deep-qa-android.txt"; then
    break
  fi
  sleep 1
done
grep -q "WORLD_DEFENSE_QA_BOOT" "$OUT/deep-qa-android.txt"
grep -q "WORLD_DEFENSE_DEEP_QA_BEGIN" "$OUT/deep-qa-android.txt"
grep -q "WORLD_DEFENSE_DEEP_QA_OK" "$OUT/deep-qa-android.txt"
! grep -q "WORLD_DEFENSE_QA_ERROR:" "$OUT/deep-qa-android.txt"

adb logcat -d -v threadtime > "$OUT/logcat-full.txt"
if grep -E "FATAL EXCEPTION|Fatal signal|SIGSEGV|SIGABRT|ANR in $PKG|Application Not Responding" "$OUT/logcat-full.txt"; then
  echo "Fatal/ANR runtime error detected"
  exit 1
fi

adb shell am force-stop "$PKG"
adb shell run-as "$PKG" rm -f files/qa.flag files/qa_fast.flag || true
adb logcat -b all -c >/dev/null 2>&1 || true
for pass in 1 2 3; do
  adb shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 > "$OUT/relaunch-$pass.txt"
  sleep 6
  adb shell pidof "$PKG" > "$OUT/relaunch-$pass-pid.txt"
  test -s "$OUT/relaunch-$pass-pid.txt"
  adb logcat -d -v brief > "$OUT/relaunch-$pass-log.txt"
  grep -q "WORLD_DEFENSE_MAIN_MENU_READY" "$OUT/relaunch-$pass-log.txt"
  if grep -E "FATAL EXCEPTION|Fatal signal|SIGSEGV|SIGABRT|ANR in $PKG" "$OUT/relaunch-$pass-log.txt"; then exit 1; fi
  adb shell am force-stop "$PKG"
  adb logcat -b all -c >/dev/null 2>&1 || true
done

echo "FULL_RUNTIME_QA_OK api=$API profile=$PROFILE" | tee "$OUT/result.txt"
