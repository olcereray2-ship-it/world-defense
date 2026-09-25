class_name GeneralSystem

static func bonus(level:int,rarity:String)->float:
 var cap=float({"common":0.08,"rare":0.12,"epic":0.16,"legendary":0.20}.get(rarity,0.08))
 return cap*clampf(float(clampi(level,0,50))/50.0,0.0,1.0)

static func xp_needed(level:int)->int:
 var lv=clampi(level,1,50)
 return int(180.0*pow(1.11,float(lv-1)))
