extends Control
func _ready():
    $Play.pressed.connect(_battle)
func _battle():
    get_tree().change_scene_to_file("res://scenes/Battle.tscn")
