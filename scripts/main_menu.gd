extends Control

func _ready():
 print("WORLD_DEFENSE_MAIN_MENU_READY")
 $Play.pressed.connect(_battle)
 $Cards/Defense.pressed.connect(func():_upgrade("tower","machine_gun"))
 $Cards/Army.pressed.connect(func():_upgrade("unit","infantry"))
 $Cards/Base.pressed.connect(_collect)
 $Cards/Intel.pressed.connect(_intel)
 _apply_text()
 _refresh()

func _apply_text():
 $Cards/Defense.text=LocalizationManager.text("defense")
 $Cards/Army.text=LocalizationManager.text("army")
 $Cards/Base.text=LocalizationManager.text("base")
 $Cards/Intel.text=LocalizationManager.text("intel")
 $Play.text=LocalizationManager.text("play")

func _battle():
 print("WORLD_DEFENSE_BUTTON_PLAY")
 var err=get_tree().change_scene_to_file("res://scenes/Battle.tscn")
 if err!=OK:push_error("WORLD_DEFENSE_BATTLE_CHANGE_FAILED:%s"%err)

func _upgrade(group:String,key:String):
 print("WORLD_DEFENSE_BUTTON_DEFENSE" if group=="tower" else "WORLD_DEFENSE_BUTTON_ARMY")
 var levels=GameState.tower_levels if group=="tower" else GameState.unit_levels
 if not levels.has(key):return
 var lv=clampi(int(levels[key]),1,100)
 if lv>=100:return
 var cost=Progression.upgrade_cost(lv,group)
 if GameState.gold>=cost:
  GameState.gold-=cost
  levels[key]=lv+1
  GameState.save_game()
  _refresh()

func _collect():
 print("WORLD_DEFENSE_BUTTON_BASE")
 var r=BaseEconomy.offline_reward(GameState.facility_levels,GameState.offline_hours())
 GameState.gold+=int(r.get("gold",0))
 GameState.supplies+=int(r.get("supplies",0))
 GameState.mark_offline_claimed()
 GameState.save_game()
 _refresh()

func _intel():
 print("WORLD_DEFENSE_BUTTON_INTEL")
 $Offline.text=RadarSystem.intel(mini(100,GameState.stage),1)

func _refresh():
 $Stats.text="%s %d   %s %d   %s %d   %s %d   %s %d"%[
  LocalizationManager.text("stage"),GameState.stage,
  LocalizationManager.text("power"),GameState.power(),
  LocalizationManager.text("gold"),GameState.gold,
  LocalizationManager.text("gems"),GameState.gems,
  LocalizationManager.text("supplies"),GameState.supplies]
 $Offline.text=LocalizationManager.text("offline_cap")
