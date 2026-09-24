extends Node2D
var wave:=0
var wave_time:=0.0
var base_hp:=1000.0
var credits:=500
var enemies:Array=[]
var bullets:Array=[]
var towers=[Vector2(190,980),Vector2(500,850),Vector2(790,1070)]
var path=PackedVector2Array([Vector2(-60,1260),Vector2(260,1110),Vector2(520,1280),Vector2(790,1040),Vector2(1140,920)])
var finished:=false
var stage:Dictionary
func _ready():
 stage=StageGenerator.stage_data(GameState.stage)
 queue_redraw()
func _process(delta):
 if finished:return
 wave_time+=delta
 if wave<5 and wave_time>=4.0:
  wave+=1; wave_time=0.0; _spawn_wave()
 _move_enemies(delta); _fire(delta)
 if wave==5 and enemies.is_empty() and wave_time>2.0:_victory()
 queue_redraw()
func _spawn_wave():
 var budget=StageGenerator.wave_budget(StageGenerator.threat(GameState.stage,GameState.power()),wave)
 var count=clamp(5+wave*3+GameState.stage/8,8,36)
 var hp=max(65.0,float(budget)/float(count)*0.9)
 for i in count:
  enemies.append({"p":path[0]-Vector2(i*24,0),"seg":0,"hp":hp,"max":hp,"speed":65.0+wave*7.0+(i%4)*4.0,"air":wave>=3 and i%7==0})
func _move_enemies(delta):
 for e in enemies.duplicate():
  if e.air:
   e.p=e.p.move_toward(Vector2(540,1450),e.speed*delta)
   if e.p.distance_to(Vector2(540,1450))<25:_hit_base(e,34)
  else:
   var n=int(e.seg)+1
   if n>=path.size():_hit_base(e,28);continue
   e.p=e.p.move_toward(path[n],e.speed*delta)
   if e.p.distance_to(path[n])<10:e.seg=n
 if base_hp<=0:_defeat()
func _hit_base(e,dmg):
 base_hp-=dmg
 enemies.erase(e)
func _fire(delta):
 for t in towers:
  var target=null; var dist=99999.0
  for e in enemies:
   var d=t.distance_to(e.p)
   if d<330 and d<dist:target=e;dist=d
  if target and randi()%max(1,int(9.0/max(delta*60.0,1.0)))==0:
   target.hp-=26.0+GameState.tower_levels.machine_gun*2.5
   bullets.append({"a":t,"b":target.p,"life":0.08})
   if target.hp<=0: enemies.erase(target);credits+=8
 for b in bullets.duplicate():
  b.life-=delta
  if b.life<=0:bullets.erase(b)
func _victory():
 finished=true
 var r=Progression.stage_reward(GameState.stage)
 GameState.gold+=r.gold;GameState.xp+=r.xp;GameState.gems+=r.gems
 GameState.battle_history.append({"dominant":"tower","stage":GameState.stage})
 if GameState.battle_history.size()>10:GameState.battle_history.pop_front()
 GameState.stage=min(250,GameState.stage+1);GameState.save_game()
 await get_tree().create_timer(1.2).timeout;get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
func _defeat():
 finished=true;GameState.save_game()
 await get_tree().create_timer(1.2).timeout;get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
func _draw():
 var biome={"desert":Color("#6d5c3d"),"city":Color("#39434b"),"snow":Color("#8ca4ac"),"mountain":Color("#3f5146"),"coast":Color("#386b68")}.get(stage.get("biome","desert"),Color("#20392d"))
 draw_rect(Rect2(0,0,1080,1920),biome)
 draw_polyline(path,Color("#81715b"),150,true)
 if stage.get("bridge",false):
  draw_rect(Rect2(420,1130,250,170),Color("#4a3a2c"))
 for t in towers:
  draw_circle(t,55,Color("#213b58"));draw_circle(t,26,Color("#9ba9b4"))
 for e in enemies:
  var col=Color("#a53d35") if not e.air else Color("#782f88")
  draw_circle(e.p,24,col)
  draw_rect(Rect2(e.p+Vector2(-25,-38),Vector2(50,5)),Color("#171717"))
  draw_rect(Rect2(e.p+Vector2(-25,-38),Vector2(50*max(0.0,e.hp/e.max),5)),Color("#d4d86a"))
 for b in bullets:draw_line(b.a,b.b,Color.WHITE,5)
 draw_rect(Rect2(30,35,1020,105),Color(0.02,0.04,0.07,0.82))
 draw_string(ThemeDB.fallback_font,Vector2(60,100),"BÖLÜM %d   DALGA %d/5   ÜS %d   $%d"%[GameState.stage,wave,int(base_hp),credits],HORIZONTAL_ALIGNMENT_LEFT,900,34,Color.WHITE)
