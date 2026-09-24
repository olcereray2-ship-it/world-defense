extends Control
var elapsed := 0.0
var transitioned := false
@onready var title: Label = $Name
func _ready():
    print("WORLD_DEFENSE_BOOT_READY")
    if FileAccess.file_exists("user://qa.flag"):
        print("WORLD_DEFENSE_QA_BOOT")
        call_deferred("_start_qa")
        return
    title.modulate.a = 0.0
    title.scale = Vector2(0.96,0.96)
    title.pivot_offset = title.size / 2.0
func _start_qa():
    get_tree().change_scene_to_file("res://scenes/QARunner.tscn")
func _process(delta):
    if FileAccess.file_exists("user://qa.flag"):
        return
    elapsed += delta
    if elapsed < 0.65:
        var t=elapsed/0.65
        title.modulate.a=t
        title.scale=Vector2.ONE*(0.96+0.04*t)
    elif elapsed < 2.25:
        title.modulate.a=1.0
        var pulse=1.0+sin((elapsed-0.65)*2.0)*0.006
        title.scale=Vector2.ONE*pulse
    elif elapsed < 3.0:
        title.modulate.a=max(0.0,(3.0-elapsed)/0.75)
    elif not transitioned:
        transitioned = true
        print("WORLD_DEFENSE_BOOT_TO_MENU")
        var err = get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
        if err != OK:
            push_error("WORLD_DEFENSE_MENU_CHANGE_FAILED:%s" % err)
