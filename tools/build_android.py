#!/usr/bin/env python3
"""Reproducible Godot 4.7.2 Android debug build and verification for World Defense."""
from __future__ import annotations

import hashlib
import os
import subprocess
import sys
from pathlib import Path

project = Path(__file__).resolve().parents[1]
if len(sys.argv) < 2:
    raise SystemExit("Usage: build_android.py <toolchain-root>")

chain = Path(sys.argv[1]).resolve()
godot = chain / "godot/Godot_v4.7.2-stable_linux.x86_64"
sdk = chain / "android-sdk"
buildtools = sdk / "build-tools/36.0.0"
java_home = Path(os.environ.get("JAVA_HOME", "/usr/lib/jvm/java-17-openjdk-amd64"))

if not (java_home / "bin/java").exists():
    javac = Path(
        subprocess.check_output(
            ["bash", "-lc", "readlink -f $(command -v javac)"],
            text=True,
        ).strip()
    )
    java_home = javac.parent.parent

required = [
    godot,
    buildtools / "zipalign",
    buildtools / "apksigner",
    buildtools / "aapt",
    sdk / "platform-tools/adb",
    java_home / "bin/java",
    java_home / "bin/keytool",
]
for tool in required:
    if not tool.exists():
        raise SystemExit(f"Missing build tool: {tool}")

for tool in [godot, buildtools / "zipalign", buildtools / "apksigner", buildtools / "aapt", sdk / "platform-tools/adb"]:
    tool.chmod(0o755)

env = os.environ.copy()
env.update(
    {
        "ANDROID_HOME": str(sdk),
        "ANDROID_SDK_ROOT": str(sdk),
        "JAVA_HOME": str(java_home),
        "PATH": f"{java_home / 'bin'}:{sdk / 'platform-tools'}:{buildtools}:{env.get('PATH', '')}",
    }
)

def run(*args: object) -> None:
    subprocess.run([str(x) for x in args], cwd=project, env=env, check=True)

build = project / "builds"
build.mkdir(exist_ok=True)
support = project / "build_support"
support.mkdir(exist_ok=True)
keystore = support / "debug.keystore"

if not keystore.exists():
    subprocess.run(
        [
            str(java_home / "bin/keytool"),
            "-genkeypair",
            "-keystore",
            str(keystore),
            "-storepass",
            "android",
            "-alias",
            "androiddebugkey",
            "-keypass",
            "android",
            "-keyalg",
            "RSA",
            "-keysize",
            "2048",
            "-validity",
            "10000",
            "-dname",
            "CN=Android Debug,O=World Defense,C=TR",
        ],
        check=True,
    )

settings_dir = Path.home() / ".config/godot"
settings_dir.mkdir(parents=True, exist_ok=True)
(settings_dir / "editor_settings-4.7.tres").write_text(
    '[gd_resource type="EditorSettings" format=3]\n\n'
    "[resource]\n"
    f'export/android/android_sdk_path = "{sdk}"\n'
    f'export/android/java_sdk_path = "{java_home}"\n',
    encoding="utf-8",
)

raw = build / "raw.apk"
final = build / "World-Defense-dev.apk"
for artifact in (raw, final):
    if artifact.exists():
        artifact.unlink()

run(godot, "--headless", "--editor", "--path", project, "--import", "--quit")
run(godot, "--headless", "--path", project, "--export-debug", "Android", raw)
run(buildtools / "zipalign", "-f", "-P", "16", "4", raw, final)
run(
    buildtools / "apksigner",
    "sign",
    "--ks",
    keystore,
    "--ks-key-alias",
    "androiddebugkey",
    "--ks-pass",
    "pass:android",
    "--key-pass",
    "pass:android",
    final,
)
run(buildtools / "apksigner", "verify", "--verbose", "--print-certs", final)
run(buildtools / "zipalign", "-c", "-P", "16", "4", final)
run(buildtools / "aapt", "dump", "badging", final)

digest = hashlib.sha256(final.read_bytes()).hexdigest()
print(f"VERIFIED_APK {final}")
print(f"SIZE_BYTES {final.stat().st_size}")
print(f"SHA256 {digest}")
