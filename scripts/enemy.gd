class_name EnemyUnit
extends Node2D
var kind:="assault"; var hp:=100.0; var speed:=80.0
var armor:=0.0
func configure(t:String,power:float):
 kind=t
 var mult={"assault":1.0,"heavy":1.4,"fast_armor":1.8,"heavy_tank":3.2,"anti_tank":2.0,"aa":1.9,"sam":2.1,"helicopter":1.7,"fighter":1.6,"bomber":2.4,"artillery":1.8,"ew":1.5,"support":1.3,"boss":8.0}.get(t,1.0)
 hp=100.0*mult*max(1.0,power/1000.0); speed=95.0/max(1.0,mult*0.45)
