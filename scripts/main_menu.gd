extends Control
func _ready():
 print("WORLD_DEFENSE_MAIN_MENU_READY")
 $Play.pressed.connect(_battle)
 $Cards/Defense.pressed.connect(func(): _upgrade("tower","machine_gun"))
 $Cards/Army.pressed.connect(func(): _upgrade("unit","infantry"))
 $Cards/Base.pressed.connect(_collect)
 $Cards/Intel.pressed.connect(_intel)
 _refresh()
func _battle():
 print("WORLD_DEFENSE_BUTTON_PLAY")
 get_tree().change_scene_to_file("res://scenes/Battle.tscn")
func _upgrade(group:String,key:String):
 print("WORLD_DEFENSE_BUTTON_DEFENSE" if group=="tower" else "WORLD_DEFENSE_BUTTON_ARMY")
 var levels=GameState.tower_levels if group=="tower" else GameState.unit_levels
 var lv=int(levels[key]); var cost=Progression.upgrade_cost(lv,group)
 if lv<100 and GameState.gold>=cost:
  GameState.gold-=cost; levels[key]=lv+1; GameState.save_game(); _refresh()
func _collect():
 print("WORLD_DEFENSE_BUTTON_BASE")
 var r=BaseEconomy.offline_reward(GameState.facility_levels,GameState.offline_hours())
 GameState.gold+=int(r.gold); GameState.save_game(); _refresh()
func _intel():
 print("WORLD_DEFENSE_BUTTON_INTEL")
 $Offline.text=RadarSystem.intel(min(100,GameState.stage),1)
func _refresh():
 $Stats.text="Bölüm %d   Güç %d   Altın %d   Elmas %d"%[GameState.stage,GameState.power(),GameState.gold,GameState.gems]
 $Offline.text="Üs çevrimdışı üretimi: en fazla 6 saat"
