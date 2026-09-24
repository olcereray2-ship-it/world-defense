class_name DefenseTower
extends Node2D
var kind:="machine_gun"; var level:=1; var cooldown:=0.0
var ranges={"machine_gun":260.0,"cannon":310.0,"missile":390.0,"laser":300.0,"tesla":270.0}
func damage()->float:
 var base={"machine_gun":18.0,"cannon":55.0,"missile":78.0,"laser":34.0,"tesla":42.0}[kind]
 return base*(1.0+(level-1)*0.065)
func milestone()->int:
 for m in [100,75,50,25,10]:
  if level>=m:return m
 return 1
