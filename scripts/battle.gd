extends Node2D
var wave:=0
var timer:=0.0
var hp:=1000.0
var credits:=500
var enemies:Array=[]
var shots:Array=[]
var explosions:Array=[]
var done:=false
var route:PackedVector2Array
var towers:Array[Vector2]=[Vector2(180,960),Vector2(510,850),Vector2(800,1100)]
var stage_data:Dictionary
func _ready():
 stage_data=StageGenerator.data(GameState.stage);route=StageGenerator.route(str(stage_data.get("route","single")));queue_redraw()
func _process(d:float):
 if done:return
 timer+=d
 if wave<5 and timer>=4.0:wave+=1;timer=0.0;spawn_wave()
 move_enemies(d);fire(d);update_vfx(d)
 if wave==5 and enemies.is_empty() and timer>2.0:win()
 queue_redraw()
func spawn_wave():
 var budget=StageGenerator.wave_budget(StageGenerator.threat(GameState.stage,GameState.power()),wave)
 var count:int=clampi(5+wave*3+GameState.stage/8,8,36)
 var ehp=maxf(65.0,float(budget)/float(count)*0.9)
 for i in range(count):enemies.append({"p":route[0]-Vector2(i*22,0),"seg":0,"hp":ehp,"max":ehp,"speed":65.0+wave*7+(i%4)*4,"air":wave>=3 and i%7==0})
 if wave==5 and GameState.stage%10==0:enemies.append({"p":route[0]-Vector2(80,0),"seg":0,"hp":ehp*8.0,"max":ehp*8.0,"speed":42.0,"air":false})
func move_enemies(d:float):
 for e in enemies.duplicate():
  if bool(e.air):
   e.p=e.p.move_toward(Vector2(540,1450),float(e.speed)*d)
   if e.p.distance_to(Vector2(540,1450))<25.0:hit_base(e,34.0)
  else:
   var n=int(e.seg)+1
   if n>=route.size():hit_base(e,28.0);continue
   e.p=e.p.move_toward(route[n],float(e.speed)*d)
   if e.p.distance_to(route[n])<10.0:e.seg=n
 if hp<=0.0:lose()
func hit_base(e:Dictionary,damage:float):hp-=damage;enemies.erase(e);explosions.append({"p":Vector2(540,1450),"age":0.0})
func fire(d:float):
 for t in towers:
  var target=null;var dist:=INF
  for e in enemies:
   var x=t.distance_to(e.p)
   if x<330.0 and x<dist:target=e;dist=x
  if target!=null and randf()<d*4.5:
   target.hp-=26.0+float(GameState.tower_levels.get("machine_gun",1))*2.5;shots.append({"a":t,"b":target.p,"life":0.08})
   if target.hp<=0.0:explosions.append({"p":target.p,"age":0.0});enemies.erase(target);credits+=8
 for s in shots.duplicate():
  s.life-=d
  if s.life<=0.0:shots.erase(s)
func update_vfx(d:float):
 for x in explosions.duplicate():
  x.age+=d
  if x.age>0.45:explosions.erase(x)
func win():
 if done:return
 done=true;GameState.gold+=450+GameState.stage*38;GameState.xp+=90+GameState.stage*12
 if GameState.stage%5==0:GameState.gems+=1
 GameState.stage=min(250,GameState.stage+1);GameState.save_game()
 await get_tree().create_timer(1.0).timeout;get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
func lose():
 if done:return
 done=true;GameState.save_game();await get_tree().create_timer(1.0).timeout;get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
func _draw():
 var c:Color={"desert":Color("#6d5c3d"),"city":Color("#39434b"),"snow":Color("#8ca4ac"),"mountain":Color("#3f5146"),"coast":Color("#386b68")}.get(stage_data.get("biome","desert"),Color("#20392d"))
 draw_rect(Rect2(0,0,1080,1920),c);draw_polyline(route,Color("#81715b"),150.0,true)
 if bool(stage_data.get("bridge",false)):draw_rect(Rect2(420,1120,260,180),Color("#49392c"))
 for t in towers:draw_circle(t,55,Color("#213b58"));draw_circle(t,25,Color("#aab5bd"))
 for e in enemies:draw_circle(e.p,24,Color("#7c318d") if e.air else Color("#ad4138"));draw_rect(Rect2(e.p+Vector2(-25,-38),Vector2(50.0*maxf(0.0,float(e.hp)/float(e.max)),5)),Color("#d8dd6d"))
 for s in shots:draw_line(s.a,s.b,Color.WHITE,5)
 for x in explosions:draw_circle(x.p,20.0+float(x.age)*110.0,Color(1.0,0.55,0.15,maxf(0.0,1.0-float(x.age)*2.2)))
 draw_rect(Rect2(30,35,1020,105),Color(0.02,0.04,0.07,.82));draw_string(ThemeDB.fallback_font,Vector2(60,100),"BÖLÜM %d   DALGA %d/5   ÜS %d   $%d"%[GameState.stage,wave,int(hp),credits],HORIZONTAL_ALIGNMENT_LEFT,900,34,Color.WHITE)
