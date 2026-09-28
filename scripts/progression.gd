class_name Progression

static func upgrade_cost(level:int,category:String)->int:
 var lv=clampi(level,1,100)
 var base=220 if category=="tower" else 280
 return int(float(base)*pow(1.085,float(lv-1)))

static func stage_reward(stage:int)->Dictionary:
 var s=clampi(stage,1,250)
 return {"gold":450+s*38,"xp":90+s*12,"gems":1 if s%5==0 else 0}

static func stars(hp_ratio:float)->int:
 var ratio=clampf(hp_ratio,0.0,1.0)
 return 3 if ratio>=0.8 else (2 if ratio>=0.45 else 1)
