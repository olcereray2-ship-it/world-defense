#!/usr/bin/env python3
"""Reproducible Godot 4.7.2 Android debug build and verification for World Defense."""
from __future__ import annotations
import hashlib, os, subprocess, sys
from pathlib import Path

project=Path(__file__).resolve().parents[1]
chain=Path(sys.argv[1]).resolve()
godot=chain/"godot/Godot_v4.7.2-stable_linux.x86_64"
sdk=chain/"android-sdk"
buildtools=sdk/"build-tools/36.0.0"
java_home=Path(os.environ.get("JAVA_HOME","/usr/lib/jvm/java-17-openjdk-amd64"))
if not (java_home/"bin/java").exists():
    javac=Path(subprocess.check_output(["bash","-lc","readlink -f $(command -v javac)"],text=True).strip())
    java_home=javac.parent.parent
required=[godot,buildtools/"zipalign",buildtools/"apksigner",buildtools/"aapt",buildtools/"aapt2",sdk/"platform-tools/adb",java_home/"bin/java"]
for p in required:
    if not p.exists(): raise SystemExit(f"Missing build tool: {p}")
for p in [godot,buildtools/"zipalign",buildtools/"apksigner",buildtools/"aapt",buildtools/"aapt2",sdk/"platform-tools/adb"]:
    p.chmod(0o755)
env=os.environ.copy()
env.update({"ANDROID_HOME":str(sdk),"ANDROID_SDK_ROOT":str(sdk),"JAVA_HOME":str(java_home),"PATH":f"{java_home/'bin'}:{sdk/'platform-tools'}:{buildtools}:{env.get('PATH','')}"})
def run(*args): subprocess.run([str(x) for x in args],cwd=project,env=env,check=True)
build=project/"builds"; build.mkdir(exist_ok=True)
support=project/"build_support"; support.mkdir(exist_ok=True)
keystore=support/"debug.keystore"
if not keystore.exists():
    subprocess.run([str(java_home/"bin/keytool"),"-genkeypair","-keystore",str(keystore),"-storepass","android","-alias","androiddebugkey","-keypass","android","-keyalg","RSA","-keysize","2048","-validity","10000","-dname","CN=Android Debug,O=World Defense,C=TR"],check=True)
raw=build/"raw.apk"; final=build/"World-Defense-dev.apk"
run(godot,"--headless","--editor","--path",project,"--script",project/"tools/configure_android.gd","--",sdk,java_home)
run(godot,"--headless","--path",project,"--editor","--import","--quit")
run(godot,"--headless","--path",project,"--export-debug","Android",raw)
run(buildtools/"zipalign","-f","-P","16","4",raw,final)
run(java_home/"bin/java","-jar",buildtools/"lib/apksigner.jar","sign","--ks",project/"build_support/debug.keystore","--ks-key-alias","androiddebugkey","--ks-pass","pass:android","--key-pass","pass:android",final)
run(java_home/"bin/java","-jar",buildtools/"lib/apksigner.jar","verify","--verbose","--print-certs",final)
run(buildtools/"zipalign","-c","-P","16","4",final)
run(buildtools/"aapt","dump","badging",final)
digest=hashlib.sha256(final.read_bytes()).hexdigest()
print(f"VERIFIED_APK {final}")
print(f"SIZE_BYTES {final.stat().st_size}")
print(f"SHA256 {digest}")
