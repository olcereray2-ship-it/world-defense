extends Control
func _ready():
 $Play.pressed.connect(_battle)
 $Cards/Defense.pressed.connect(func(): _upgrade("tower","machine_gun"))
 $Cards/Army.pressed.connect(func(): _upgrade("unit","infantry"))
 $Cards/Base.pressed.connect(_collect)
 _refresh()
func _battle(): get_tree().change_scene_to_file("res://scenes/Battle.tscn")
func _upgrade(group:String,key:String):
 var levels=GameState.tower_levels if group=="tower" else GameState.unit_levels
 var lv=int(levels[key]); var cost=Progression.upgrade_cost(lv,group)
 if lv<100 and GameState.gold>=cost:
  GameState.gold-=cost; levels[key]=lv+1; GameState.save_game(); _refresh()
func _collect():
 var r=BaseEconomy.offline_reward(GameState.facility_levels,GameState.offline_hours())
 GameState.gold+=int(r.gold); GameState.save_game(); _refresh()
func _refresh():
 $Stats.text="Bölüm %d   Güç %d   Altın %d   Elmas %d"%[GameState.stage,GameState.power(),GameState.gold,GameState.gems]
 $Offline.text="Üs çevrimdışı üretimi: en fazla 6 saat"
