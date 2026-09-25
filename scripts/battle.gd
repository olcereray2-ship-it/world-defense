extends Node2D

var wave:=0
var timer:=0.0
var hp:=1000.0
var credits:=500
var enemies:Array=[]
var shots:Array=[]
var friendly_shots:Array=[]
var explosions:Array=[]
var friendly_units:Array=[]
var done:=false
var route:PackedVector2Array
var towers:Array=[
 {"p":Vector2(150,980),"kind":"machine_gun"},
 {"p":Vector2(350,820),"kind":"cannon"},
 {"p":Vector2(540,1080),"kind":"missile"},
 {"p":Vector2(735,860),"kind":"laser"},
 {"p":Vector2(900,1110),"kind":"tesla"}]
var stage_data:Dictionary
var qa_fast:=false
var ability_cd={"airstrike":0.0,"reinforcement":0.0,"emp":0.0}

func _ready():
 qa_fast=FileAccess.file_exists("user://qa_fast.flag")
 stage_data=StageGenerator.data(GameState.stage)
 route=StageGenerator.route(str(stage_data.get("route","single")))
 if route.is_empty():
  push_error("WORLD_DEFENSE_ROUTE_EMPTY_STAGE_%d"%GameState.stage)
  route=RouteFactory.points("single")
 _spawn_initial_friendly_units()
 _make_hud()
 print("WORLD_DEFENSE_BATTLE_READY_STAGE_%d"%GameState.stage)
 print("WORLD_DEFENSE_FRIENDLY_COUNT_%d_STAGE_%d"%[friendly_units.size(),GameState.stage])
 queue_redraw()

func _base_position()->Vector2:
 return route[route.size()-1] if not route.is_empty() else Vector2(1080,960)

func _spawn_initial_friendly_units():
 friendly_units.clear()
 _add_friendly("infantry",Vector2(480,1470))
 if GameState.stage>=10:_add_friendly("tank",Vector2(600,1490))
 if GameState.stage>=20:_add_friendly("artillery",Vector2(410,1560))
 if GameState.stage>=30:_add_friendly("helicopter",Vector2(690,1380))
 if GameState.stage>=50:_add_friendly("fighter",Vector2(780,1320))

func _add_friendly(kind:String,pos:Vector2):
 if not UnitCatalog.ARMY.has(kind):return
 var lv=int(GameState.unit_levels.get(kind,1))
 var st=MobileArmy.stats(kind,lv)
 friendly_units.append({
  "kind":kind,
  "p":pos,
  "hp":float(st.get("hp",1.0)),
  "max":float(st.get("hp",1.0)),
  "damage":float(st.get("damage",1.0)),
  "speed":float(st.get("speed",1.0)),
  "cool":0.0
 })

func _make_hud():
 var hud=CanvasLayer.new()
 hud.name="BattleHUD"
 add_child(hud)
 var names=["Airstrike","Reinforcement","EMP"]
 var labels=[
  LocalizationManager.text("airstrike"),
  LocalizationManager.text("reinforcement"),
  LocalizationManager.text("emp")]
 var xs=[35.0,365.0,695.0]
 for i in range(3):
  var b=Button.new()
  b.name=names[i]
  b.text=labels[i]
  b.position=Vector2(xs[i],1740)
  b.size=Vector2(300,110)
  hud.add_child(b)
 hud.get_node("Airstrike").pressed.connect(_on_airstrike)
 hud.get_node("Reinforcement").pressed.connect(_on_reinforcement)
 hud.get_node("EMP").pressed.connect(_on_emp)

func _on_airstrike():
 if float(ability_cd.get("airstrike",0.0))>0.0:return
 var killed=AbilitySystem.airstrike(enemies,Vector2(540,980))
 for e in killed:
  explosions.append({"p":e.get("p",Vector2.ZERO),"age":0.0})
  credits+=12
 ability_cd["airstrike"]=float(AbilitySystem.COOLDOWNS["airstrike"])
 print("WORLD_DEFENSE_ABILITY_AIRSTRIKE")

func _on_reinforcement():
 if float(ability_cd.get("reinforcement",0.0))>0.0:return
 _add_friendly("infantry",Vector2(455,1510))
 _add_friendly("infantry",Vector2(625,1510))
 ability_cd["reinforcement"]=float(AbilitySystem.COOLDOWNS["reinforcement"])
 print("WORLD_DEFENSE_ABILITY_REINFORCEMENT")

func _on_emp():
 if float(ability_cd.get("emp",0.0))>0.0:return
 AbilitySystem.emp(enemies,Vector2(540,1050))
 ability_cd["emp"]=float(AbilitySystem.COOLDOWNS["emp"])
 print("WORLD_DEFENSE_ABILITY_EMP")

func _process(d:float):
 if done:return
 timer+=d*(15.0 if qa_fast else 1.0)
 for k in ability_cd.keys():
  ability_cd[k]=maxf(0.0,float(ability_cd[k])-d)
 if wave<5 and timer>=4.0:
  wave+=1
  timer=0.0
  spawn_wave()
 move_enemies(d)
 fire(d)
 friendly_fire(d)
 update_vfx(d)
 if wave==5 and enemies.is_empty() and timer>2.0:win()
 queue_redraw()

func spawn_wave():
 var plan=ThreatDirector.plan(
  GameState.stage,
  wave,
  GameState.power(),
  GameState.battle_history,
  GameState.loadout_profile())
 var budget=maxi(1,int(plan.get("budget",1)))
 var count:int=clampi(5+wave*3+int(GameState.stage/8),8,36)
 var pool=EnemyCatalog.stage_pool(GameState.stage)
 if pool.is_empty():
  push_error("WORLD_DEFENSE_ENEMY_POOL_EMPTY_STAGE_%d"%GameState.stage)
  return
 var air_count:=0
 for i in range(count):
  var kind=str(pool[(i+wave+GameState.stage)%pool.size()])
  var base:Dictionary=EnemyCatalog.TYPES.get(kind,{})
  if base.is_empty():continue
  var hp_scale=DifficultyCurve.enemy_health(GameState.stage,wave)
  var ehp=maxf(float(base.get("hp",1.0))*hp_scale,float(budget)/float(count)*0.55)
  var is_air=str(base.get("class",""))=="air"
  if is_air:air_count+=1
  enemies.append({
   "kind":kind,
   "p":route[0]-Vector2(i*22,0),
   "seg":0,
   "hp":ehp,
   "max":ehp,
   "speed":maxf(1.0,float(base.get("speed",1.0))*(0.92+wave*0.02)),
   "armor":maxf(0.0,float(base.get("armor",0.0))),
   "air":is_air})
 if wave==5 and GameState.stage%10==0:
  var boss=BossSystem.profile(GameState.stage)
  var bhp=maxf(1200.0,float(budget)*float(boss.get("hp",7.0))*0.22)
  var boss_air=str(boss.get("rule",""))=="air"
  enemies.append({
   "kind":"boss",
   "p":route[0]-Vector2(80,0),
   "seg":0,
   "hp":bhp,
   "max":bhp,
   "speed":42.0,
   "armor":65.0,
   "air":boss_air,
   "boss":true})
  if boss_air:air_count+=1
  print("WORLD_DEFENSE_BOSS_STAGE_%d"%GameState.stage)
 print("WORLD_DEFENSE_WAVE_%d_STAGE_%d_ENEMIES_%d_AIR_%d"%[wave,GameState.stage,enemies.size(),air_count])

func move_enemies(d:float):
 var base_pos=_base_position()
 for e in enemies.duplicate():
  if float(e.get("hp",0.0))<=0.0:
   enemies.erase(e)
   continue
  if bool(e.get("air",false)):
   e["p"]=e.get("p",Vector2.ZERO).move_toward(base_pos,float(e.get("speed",1.0))*d)
   if e.get("p",Vector2.ZERO).distance_to(base_pos)<25.0:hit_base(e,34.0)
  else:
   var n=int(e.get("seg",0))+1
   if n>=route.size():
    hit_base(e,28.0)
    continue
   e["p"]=e.get("p",Vector2.ZERO).move_toward(route[n],float(e.get("speed",1.0))*d)
   if e.get("p",Vector2.ZERO).distance_to(route[n])<10.0:e["seg"]=n
 if hp<=0.0:lose()

func hit_base(e:Dictionary,damage:float):
 hp=maxf(0.0,hp-maxf(0.0,damage))
 enemies.erase(e)
 explosions.append({"p":_base_position(),"age":0.0})

func fire(d:float):
 for t in towers:
  var kind=str(t.get("kind","machine_gun"))
  var pos:Vector2=t.get("p",Vector2.ZERO)
  var lv=int(GameState.tower_levels.get(kind,1))
  var st=ContentCatalog.tower_stats(kind,lv)
  var target=null
  var best:=INF
  for e in enemies:
   if float(e.get("hp",0.0))<=0.0:continue
   var ep:Vector2=e.get("p",Vector2.ZERO)
   var dist=pos.distance_to(ep)
   if dist>float(st.get("range",0.0)):continue
   var score=dist/maxf(0.25,Targeting.priority(kind,str(e.get("kind","assault"))))
   if score<best:
    target=e
    best=score
  if target!=null and randf()<d/maxf(0.08,float(st.get("cooldown",1.0))):
   var dmg=CombatMath.damage(
    float(st.get("damage",1.0)),
    float(target.get("armor",0.0)),
    Targeting.priority(kind,str(target.get("kind","assault"))))
   target["hp"]=float(target.get("hp",0.0))-dmg
   shots.append({"a":pos,"b":target.get("p",Vector2.ZERO),"life":0.08})
   if float(target.get("hp",0.0))<=0.0:
    explosions.append({"p":target.get("p",Vector2.ZERO),"age":0.0})
    enemies.erase(target)
    credits+=8
 for s in shots.duplicate():
  s["life"]=float(s.get("life",0.0))-d
  if float(s.get("life",0.0))<=0.0:shots.erase(s)

func friendly_fire(d:float):
 var ranges={"infantry":230.0,"tank":300.0,"artillery":430.0,"helicopter":350.0,"fighter":470.0}
 var rates={"infantry":1.6,"tank":0.7,"artillery":0.45,"helicopter":1.2,"fighter":0.9}
 for u in friendly_units:
  var kind=str(u.get("kind","infantry"))
  u["cool"]=maxf(0.0,float(u.get("cool",0.0))-d)
  if float(u.get("cool",0.0))>0.0:continue
  var pos:Vector2=u.get("p",Vector2.ZERO)
  var target=null
  var best:=INF
  for e in enemies:
   if float(e.get("hp",0.0))<=0.0:continue
   var dist=pos.distance_to(e.get("p",Vector2.ZERO))
   if dist<=float(ranges.get(kind,200.0)) and dist<best:
    target=e
    best=dist
  if target!=null:
   var dmg=CombatMath.damage(
    float(u.get("damage",1.0)),
    float(target.get("armor",0.0)),
    MobileArmy.matchup(kind,str(target.get("kind",""))))
   target["hp"]=float(target.get("hp",0.0))-dmg
   friendly_shots.append({"a":pos,"b":target.get("p",Vector2.ZERO),"life":0.10,"kind":kind})
   u["cool"]=1.0/maxf(0.05,float(rates.get(kind,1.0)))
   if float(target.get("hp",0.0))<=0.0:
    explosions.append({"p":target.get("p",Vector2.ZERO),"age":0.0})
    enemies.erase(target)
    credits+=10
 for s in friendly_shots.duplicate():
  s["life"]=float(s.get("life",0.0))-d
  if float(s.get("life",0.0))<=0.0:friendly_shots.erase(s)

func update_vfx(d:float):
 for x in explosions.duplicate():
  x["age"]=float(x.get("age",0.0))+d
  if float(x.get("age",0.0))>0.45:explosions.erase(x)

func win():
 if done:return
 done=true
 print("WORLD_DEFENSE_BATTLE_WIN_STAGE_%d"%GameState.stage)
 GameState.record_battle("win")
 var reward=Progression.stage_reward(GameState.stage)
 GameState.gold+=int(reward.get("gold",0))
 GameState.xp+=int(reward.get("xp",0))
 GameState.gems+=int(reward.get("gems",0))
 GameState.stage=mini(250,GameState.stage+1)
 GameState.save_game()
 await get_tree().create_timer(1.0).timeout
 var err=get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
 if err!=OK:push_error("WORLD_DEFENSE_MENU_RETURN_FAILED:%s"%err)

func lose():
 if done:return
 done=true
 print("WORLD_DEFENSE_BATTLE_LOSE_STAGE_%d"%GameState.stage)
 GameState.record_battle("loss")
 GameState.save_game()
 await get_tree().create_timer(1.0).timeout
 var err=get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
 if err!=OK:push_error("WORLD_DEFENSE_MENU_RETURN_FAILED:%s"%err)

func _draw():
 var c:Color={
  "desert":Color("#6d5c3d"),
  "city":Color("#39434b"),
  "snow":Color("#8ca4ac"),
  "mountain":Color("#3f5146"),
  "coast":Color("#386b68")
 }.get(stage_data.get("biome","desert"),Color("#20392d"))
 draw_rect(Rect2(0,0,1080,1920),c)
 draw_polyline(route,Color("#81715b"),150.0,true)
 if bool(stage_data.get("bridge",false)):draw_rect(Rect2(420,1120,260,180),Color("#49392c"))
 for t in towers:
  var p:Vector2=t.get("p",Vector2.ZERO)
  draw_circle(p,48,Color("#213b58"))
  draw_circle(p,20,Color("#aab5bd"))
  draw_string(ThemeDB.fallback_font,p+Vector2(-44,78),str(t.get("kind","")),HORIZONTAL_ALIGNMENT_CENTER,88,16,Color.WHITE)
 for u in friendly_units:
  var p:Vector2=u.get("p",Vector2.ZERO)
  var kind=str(u.get("kind",""))
  var uc=Color("#8ad0ff") if kind in ["helicopter","fighter"] else Color("#8ee09a")
  draw_circle(p,22,uc)
  draw_string(ThemeDB.fallback_font,p+Vector2(-35,42),kind,HORIZONTAL_ALIGNMENT_CENTER,70,13,Color.WHITE)
 for e in enemies:
  var p:Vector2=e.get("p",Vector2.ZERO)
  draw_circle(p,28 if bool(e.get("boss",false)) else 22,Color("#7c318d") if e.get("air",false) else Color("#ad4138"))
  var ratio=clampf(float(e.get("hp",0.0))/maxf(1.0,float(e.get("max",1.0))),0.0,1.0)
  draw_rect(Rect2(p+Vector2(-25,-38),Vector2(50.0*ratio,5)),Color("#d8dd6d"))
 for s in shots:draw_line(s.get("a",Vector2.ZERO),s.get("b",Vector2.ZERO),Color.WHITE,5)
 for s in friendly_shots:draw_line(s.get("a",Vector2.ZERO),s.get("b",Vector2.ZERO),Color("#9ee8ff"),4)
 for x in explosions:
  draw_circle(x.get("p",Vector2.ZERO),20.0+float(x.get("age",0.0))*110.0,Color(1.0,0.55,0.15,maxf(0.0,1.0-float(x.get("age",0.0))*2.2)))
 draw_rect(Rect2(30,35,1020,105),Color(0.02,0.04,0.07,.82))
 var hud="%s %d   %s %d/5   %s %d   %s %d"%[
  LocalizationManager.text("stage"),GameState.stage,
  LocalizationManager.text("wave"),wave,
  LocalizationManager.text("base_hp"),int(hp),
  LocalizationManager.text("credits"),credits]
 draw_string(ThemeDB.fallback_font,Vector2(60,100),hud,HORIZONTAL_ALIGNMENT_LEFT,900,34,Color.WHITE)
