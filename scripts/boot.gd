extends Control
var elapsed := 0.0
@onready var title: Label = $Name
func _ready():
    title.modulate.a = 0.0
    title.scale = Vector2(0.96,0.96)
    title.pivot_offset = title.size / 2.0
func _process(delta):
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
    else:
        get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
