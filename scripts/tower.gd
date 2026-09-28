class_name DefenseTower
extends Node2D

var kind:="machine_gun"
var level:=1
var cooldown:=0.0

func stats()->Dictionary:
 return UnitCatalog.tower_stats(kind,level)

func damage()->float:
 return float(stats().get("damage",0.0))

func attack_range()->float:
 return float(stats().get("range",0.0))

func attack_cooldown()->float:
 return float(stats().get("cooldown",1.0))

func milestone()->int:
 return UnitCatalog.milestone(level)
