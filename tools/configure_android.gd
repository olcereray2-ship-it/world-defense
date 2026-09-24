extends SceneTree

func _initialize() -> void:
	call_deferred("configure")

func configure() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() < 2:
		push_error("Usage: configure_android.gd -- <android-sdk> <java-sdk>")
		quit(2)
		return
	var settings: EditorSettings = EditorInterface.get_editor_settings()
	settings.set_setting("export/android/android_sdk_path",args[0])
	settings.set_setting("export/android/java_sdk_path",args[1])
	print("Android editor settings configured.")
	await create_timer(0.5).timeout
	quit()
