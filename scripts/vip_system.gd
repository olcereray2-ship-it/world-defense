class_name VIPSystem
static func level(xp:int)->int:
 var thresholds=[0,100,300,700,1400,2500,4000,6500,10000,15000,22000]
 var l=0
 for i in thresholds.size():
  if xp>=thresholds[i]:l=i
 return l
static func bonus(xp:int)->float:return min(0.15,level(xp)*0.015)
