class_name BattleVFX

static func explosion(canvas:CanvasItem,pos:Vector2,age:float):
 if canvas==null:return
 var a=maxf(0.0,age)
 var radius=18.0+a*130.0
 canvas.draw_circle(pos,radius,Color(1.0,0.55,0.16,clampf(1.0-a*2.0,0.0,1.0)))
 canvas.draw_circle(pos,radius*0.45,Color(1.0,0.9,0.55,clampf(1.0-a*2.5,0.0,1.0)))

static func warning(canvas:CanvasItem,pos:Vector2,pulse:float):
 if canvas==null:return
 var alpha=clampf(0.45+0.4*pulse,0.0,1.0)
 canvas.draw_arc(pos,55.0,0,TAU,32,Color(1.0,0.25,0.18,alpha),6.0)
