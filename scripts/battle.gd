extends Node2D
var wave:=1
var enemies_alive:=0
var elapsed:=0.0
func _ready(): queue_redraw()
func _process(delta):
    elapsed+=delta
    if elapsed>5.0 and wave<=5:
        enemies_alive=6+wave*3
        elapsed=0.0
        wave+=1
        queue_redraw()
func _draw():
    draw_rect(Rect2(0,0,1080,1920),Color("#20392d"))
    draw_polyline(PackedVector2Array([Vector2(0,1200),Vector2(350,1050),Vector2(650,1250),Vector2(1080,900)]),Color("#82705a"),150)
    for i in range(5):
        draw_circle(Vector2(170+i*180,900-(i%2)*170),52,Color("#304b65"))
