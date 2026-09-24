extends Node
var errors:Array=[]

func _ready():
 call_deferred("_run")

func _fail(code:String):
 errors.append(code)
 push_error(code)

func _button_ok(root:Node,path:String):
 if not root.has_node(path):
  _fail("button_missing_"+path)
  return
 var b=root.get_node(path) as Button
 if b==null:_fail("button_type_"+path)
 elif b.pressed.get_connections().is_empty():_fail("button_unwired_"+path)

func _run():
 print("WORLD_DEFENSE_DEEP_QA_BEGIN")
 errors=QAChecks.run()

 var menu_scene=load("res://scenes/MainMenu.tscn") as PackedScene
 if menu_scene==null:_fail("menu_scene_load")
 else:
  var menu=menu_scene.instantiate()
  add_child(menu)
  await get_tree().process_frame
  for path in ["Play","Cards/Defense","Cards/Army","Cards/Base","Cards/Intel"]:_button_ok(menu,path)
  for path in ["Play","Cards/Defense","Cards/Army","Cards/Base","Cards/Intel"]:
   if menu.has_node(path):
    var control=menu.get_node(path) as Control
    var rect=control.get_global_rect()
    if rect.position.x<0 or rect.position.y<0 or rect.end.x>1080 or rect.end.y>1920:_fail("button_offscreen_"+path)
  GameState.gold=99999999
  GameState.tower_levels["machine_gun"]=1
  GameState.unit_levels["infantry"]=1
  menu.get_node("Cards/Defense").emit_signal("pressed")
  menu.get_node("Cards/Army").emit_signal("pressed")
  menu.get_node("Cards/Base").emit_signal("pressed")
  var old_text=str(menu.get_node("Offline").text)
  menu.get_node("Cards/Intel").emit_signal("pressed")
  await get_tree().process_frame
  if int(GameState.tower_levels["machine_gun"])!=2:_fail("button_defense_effect")
  if int(GameState.unit_levels["infantry"])!=2:_fail("button_army_effect")
  if str(menu.get_node("Offline").text)==old_text:_fail("button_intel_effect")
  menu.queue_free()

 var battle_scene=load("res://scenes/Battle.tscn") as PackedScene
 if battle_scene==null:_fail("battle_scene_load")
 else:
  var seen_battle_enemy={}
  for stage in range(1,251):
   GameState.stage=stage
   var battle=battle_scene.instantiate()
   add_child(battle)
   battle.set_process(false)
   if battle.route.size()<4:_fail("battle_route_%d"%stage)
   if battle.towers.size()!=5:_fail("battle_tower_count_%d"%stage)
   var tower_kinds={}
   for t in battle.towers:tower_kinds[str(t.kind)]=true
   for kind in ContentCatalog.TOWERS:
    if not tower_kinds.has(kind):_fail("battle_tower_missing_%s_stage_%d"%[kind,stage])

   var expected_friendly=1
   if stage>=10:expected_friendly+=1
   if stage>=20:expected_friendly+=1
   if stage>=30:expected_friendly+=1
   if stage>=50:expected_friendly+=1
   if battle.friendly_units.size()!=expected_friendly:_fail("battle_friendly_count_%d"%stage)
   var friendly_kinds={}
   for u in battle.friendly_units:friendly_kinds[str(u.kind)]=true
   if not friendly_kinds.has("infantry"):_fail("battle_infantry_missing_%d"%stage)
   if stage>=10 and not friendly_kinds.has("tank"):_fail("battle_tank_missing_%d"%stage)
   if stage>=20 and not friendly_kinds.has("artillery"):_fail("battle_artillery_missing_%d"%stage)
   if stage>=30 and not friendly_kinds.has("helicopter"):_fail("battle_helicopter_missing_%d"%stage)
   if stage>=50 and not friendly_kinds.has("fighter"):_fail("battle_fighter_missing_%d"%stage)

   for path in ["BattleHUD/Airstrike","BattleHUD/Reinforcement","BattleHUD/EMP"]:_button_ok(battle,path)
   if stage==50:
    var before=battle.friendly_units.size()
    battle.get_node("BattleHUD/Reinforcement").emit_signal("pressed")
    if battle.friendly_units.size()!=before+2:_fail("battle_reinforcement_effect")
    battle.get_node("BattleHUD/Airstrike").emit_signal("pressed")
    battle.get_node("BattleHUD/EMP").emit_signal("pressed")
    if float(battle.ability_cd.airstrike)<=0.0:_fail("battle_airstrike_cooldown")
    if float(battle.ability_cd.reinforcement)<=0.0:_fail("battle_reinforcement_cooldown")
    if float(battle.ability_cd.emp)<=0.0:_fail("battle_emp_cooldown")

   for w in range(1,6):
    battle.wave=w
    battle.enemies.clear()
    battle.spawn_wave()
    if battle.enemies.is_empty():_fail("battle_stage_%d_wave_%d_empty"%[stage,w])
    var air_count=0
    for e in battle.enemies:
     var kind=str(e.get("kind",""))
     if bool(e.get("boss",false)):
      if kind!="boss":_fail("battle_stage_%d_wave_%d_boss_kind"%[stage,w])
     else:
      if not EnemyCatalog.TYPES.has(kind):_fail("battle_stage_%d_wave_%d_unknown_%s"%[stage,w,kind])
      else:
       seen_battle_enemy[kind]=true
       var expected_air=str(EnemyCatalog.TYPES[kind].get("class",""))=="air"
       if bool(e.get("air",false))!=expected_air:_fail("battle_stage_%d_wave_%d_air_class_%s"%[stage,w,kind])
       if expected_air:air_count+=1
     if float(e.get("hp",0.0))<=0.0 or float(e.get("speed",0.0))<=0.0:_fail("battle_stage_%d_wave_%d_invalid_stats"%[stage,w])
    if stage>=30 and w>=3 and air_count==0:_fail("battle_stage_%d_wave_%d_air_missing"%[stage,w])
    if w==5 and stage%10==0:
     var boss_found=false
     for e in battle.enemies:
      if bool(e.get("boss",false)):boss_found=true;break
     if not boss_found:_fail("battle_stage_%d_boss_missing"%stage)
   battle.free()
  for kind in EnemyCatalog.TYPES.keys():
   if not seen_battle_enemy.has(kind):_fail("battle_enemy_never_spawned_"+str(kind))

 GameState.stage=77
 GameState.gold=123456
 GameState.gems=42
 GameState.xp=9876
 GameState.tower_levels["cannon"]=17
 GameState.unit_levels["fighter"]=23
 GameState.save_game()
 GameState.stage=1
 GameState.gold=0
 GameState.gems=0
 GameState.xp=0
 GameState.tower_levels["cannon"]=1
 GameState.unit_levels["fighter"]=1
 GameState.load_game()
 if GameState.stage!=77 or GameState.gold!=123456 or GameState.gems!=42 or GameState.xp!=9876:_fail("save_roundtrip_core")
 if int(GameState.tower_levels["cannon"])!=17 or int(GameState.unit_levels["fighter"])!=23:_fail("save_roundtrip_levels")

 if errors.is_empty():
  print("WORLD_DEFENSE_DEEP_QA_OK")
  print("WORLD_DEFENSE_QA_OK")
  get_tree().quit(0)
 else:
  print("WORLD_DEFENSE_DEEP_QA_FAIL_COUNT_%d"%errors.size())
  for e in errors:print("WORLD_DEFENSE_QA_ERROR:"+str(e))
  get_tree().quit(1)
