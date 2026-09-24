class_name BattleVFX
static func explosion(canvas:CanvasItem,pos:Vector2,age:float):
 var radius=18.0+age*130.0
 canvas.draw_circle(pos,radius,Color(1.0,0.55,0.16,max(0.0,1.0-age*2.0)))
 canvas.draw_circle(pos,radius*0.45,Color(1.0,0.9,0.55,max(0.0,1.0-age*2.5)))
static func warning(canvas:CanvasItem,pos:Vector2,pulse:float):
 canvas.draw_arc(pos,55.0,0,TAU,32,Color(1.0,0.25,0.18,0.45+0.4*pulse),6.0)
