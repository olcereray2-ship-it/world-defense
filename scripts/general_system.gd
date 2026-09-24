class_name GeneralSystem
static func bonus(level:int,rarity:String)->float:
 var cap={"common":0.08,"rare":0.12,"epic":0.16,"legendary":0.20}.get(rarity,0.08)
 return cap*clamp(float(level)/50.0,0.0,1.0)
static func xp_needed(level:int)->int:return int(180*pow(1.11,max(0,level-1)))
