class_name EnemyUnit
extends Node2D

var kind:="assault"
var hp:=100.0
var speed:=80.0
var armor:=0.0

func configure(t:String,power:float):
 kind=t if EnemyCatalog.TYPES.has(t) else "assault"
 var data:Dictionary=EnemyCatalog.TYPES.get(kind,EnemyCatalog.TYPES["assault"])
 var scale=maxf(1.0,maxf(0.0,power)/1000.0)
 hp=maxf(1.0,float(data.get("hp",90.0))*scale)
 speed=maxf(1.0,float(data.get("speed",80.0)))
 armor=maxf(0.0,float(data.get("armor",0.0)))
