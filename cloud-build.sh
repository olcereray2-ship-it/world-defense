#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"
GODOT_VERSION="4.5.1"
TOOLS="$ROOT/.cloud-tools"
ANDROID_HOME="$TOOLS/android-sdk"
GODOT_HOME="$TOOLS/godot"
mkdir -p "$TOOLS" "$ANDROID_HOME/cmdline-tools" "$GODOT_HOME" build

need(){ command -v "$1" >/dev/null 2>&1 || { echo "Missing required command: $1"; exit 2; }; }
for x in curl unzip java javac keytool; do need "$x"; done

if [ ! -x "$GODOT_HOME/godot" ]; then
  echo "Downloading Godot ${GODOT_VERSION}..."
  curl -fL "https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip" -o "$TOOLS/godot.zip"
  unzip -qo "$TOOLS/godot.zip" -d "$GODOT_HOME"
  mv "$GODOT_HOME/Godot_v${GODOT_VERSION}-stable_linux.x86_64" "$GODOT_HOME/godot"
  chmod +x "$GODOT_HOME/godot"
fi

TEMPLATE_DIR="$HOME/.local/share/godot/export_templates/${GODOT_VERSION}.stable"
if [ ! -f "$TEMPLATE_DIR/android_debug.apk" ]; then
  echo "Downloading Godot export templates..."
  curl -fL "https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_export_templates.tpz" -o "$TOOLS/templates.tpz"
  rm -rf "$TOOLS/templates"
  unzip -qo "$TOOLS/templates.tpz" -d "$TOOLS"
  mkdir -p "$TEMPLATE_DIR"
  cp -a "$TOOLS/templates/." "$TEMPLATE_DIR/"
fi

SDKMANAGER="$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager"
if [ ! -x "$SDKMANAGER" ]; then
  echo "Downloading Android command-line tools..."
  curl -fL "https://dl.google.com/android/repository/commandlinetools-linux-15859902_latest.zip" -o "$TOOLS/android-cli.zip"
  rm -rf "$TOOLS/android-cli"
  mkdir -p "$TOOLS/android-cli"
  unzip -qo "$TOOLS/android-cli.zip" -d "$TOOLS/android-cli"
  mkdir -p "$ANDROID_HOME/cmdline-tools/latest"
  cp -a "$TOOLS/android-cli/cmdline-tools/." "$ANDROID_HOME/cmdline-tools/latest/"
fi

yes | "$SDKMANAGER" --sdk_root="$ANDROID_HOME" --licenses >/dev/null || true
"$SDKMANAGER" --sdk_root="$ANDROID_HOME" "platform-tools" "platforms;android-35" "build-tools;35.0.0"

JAVA_BIN="$(readlink -f "$(command -v javac)")"
JAVA_HOME="${JAVA_HOME:-$(dirname "$(dirname "$JAVA_BIN")")}"
export ANDROID_HOME JAVA_HOME

mkdir -p "$HOME/.android" "$HOME/.config/godot"
DEBUG_KEYSTORE="$HOME/.android/debug.keystore"
if [ ! -f "$DEBUG_KEYSTORE" ]; then
  keytool -genkeypair -keystore "$DEBUG_KEYSTORE" -storepass android -alias androiddebugkey -keypass android -keyalg RSA -keysize 2048 -validity 10000 -dname "CN=Android Debug,O=World Defense,C=TR"
fi
export GODOT_ANDROID_KEYSTORE_DEBUG_PATH="$DEBUG_KEYSTORE"
export GODOT_ANDROID_KEYSTORE_DEBUG_USER="androiddebugkey"
export GODOT_ANDROID_KEYSTORE_DEBUG_PASSWORD="android"

cat > "$HOME/.config/godot/editor_settings-4.5.tres" <<EOF
[gd_resource type="EditorSettings" format=3]

[resource]
export/android/android_sdk_path = "$ANDROID_HOME"
export/android/java_sdk_path = "$JAVA_HOME"
EOF

"$GODOT_HOME/godot" --headless --editor --path "$ROOT" --quit
"$GODOT_HOME/godot" --headless --path "$ROOT" --export-debug "Android" "$ROOT/build/World-Defense.apk"

test -s build/World-Defense.apk
unzip -tq build/World-Defense.apk
sha256sum build/World-Defense.apk | tee build/SHA256.txt
stat -c '%s' build/World-Defense.apk | tee build/SIZE_BYTES.txt
echo "APK_READY=$ROOT/build/World-Defense.apk"
ls -lh build/World-Defense.apk