extends Node
var errors:Array=[]
func _ready():
 call_deferred("_run")
func _fail(code:String):
 errors.append(code)
 push_error(code)
func _run():
 print("WORLD_DEFENSE_DEEP_QA_BEGIN")
 errors=QAChecks.run()
 var menu_scene=load("res://scenes/MainMenu.tscn") as PackedScene
 if menu_scene==null:_fail("menu_scene_load")
 else:
  var menu=menu_scene.instantiate()
  add_child(menu)
  await get_tree().process_frame
  for path in ["Play","Cards/Defense","Cards/Army","Cards/Base","Cards/Intel"]:
   if not menu.has_node(path):_fail("button_missing_"+path)
   else:
    var b=menu.get_node(path) as Button
    if b.pressed.get_connections().is_empty():_fail("button_unwired_"+path)
  GameState.gold=99999999
  GameState.tower_levels["machine_gun"]=1
  GameState.unit_levels["infantry"]=1
  menu.get_node("Cards/Defense").emit_signal("pressed")
  menu.get_node("Cards/Army").emit_signal("pressed")
  menu.get_node("Cards/Base").emit_signal("pressed")
  menu.get_node("Cards/Intel").emit_signal("pressed")
  await get_tree().process_frame
  if int(GameState.tower_levels["machine_gun"])!=2:_fail("button_defense_effect")
  if int(GameState.unit_levels["infantry"])!=2:_fail("button_army_effect")
  menu.queue_free()
 var battle_scene=load("res://scenes/Battle.tscn") as PackedScene
 if battle_scene==null:_fail("battle_scene_load")
 else:
  for stage in range(1,251):
   GameState.stage=stage
   var battle=battle_scene.instantiate()
   add_child(battle)
   battle.set_process(false)
   if battle.route.size()<4:_fail("battle_route_%d"%stage)
   for w in range(1,6):
    battle.wave=w
    battle.enemies.clear()
    battle.spawn_wave()
    if battle.enemies.is_empty():_fail("battle_stage_%d_wave_%d_empty"%[stage,w])
    if w>=3:
     var air_found=false
     for e in battle.enemies:
      if bool(e.get("air",false)):air_found=true;break
     if not air_found:_fail("battle_stage_%d_wave_%d_air_missing"%[stage,w])
    if w==5 and stage%10==0:
     var boss_found=false
     for e in battle.enemies:
      if bool(e.get("boss",false)):boss_found=true;break
     if not boss_found:_fail("battle_stage_%d_boss_missing"%stage)
   battle.free()
 if errors.is_empty():
  print("WORLD_DEFENSE_DEEP_QA_OK")
  print("WORLD_DEFENSE_QA_OK")
  get_tree().quit(0)
 else:
  print("WORLD_DEFENSE_DEEP_QA_FAIL_COUNT_%d"%errors.size())
  get_tree().quit(1)
