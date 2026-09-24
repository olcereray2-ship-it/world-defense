class_name Progression
static func upgrade_cost(level:int,category:String)->int:
 var base=220 if category=="tower" else 280
 return int(base*pow(1.085,max(0,level-1)))
static func stage_reward(stage:int)->Dictionary:
 return {"gold":450+stage*38,"xp":90+stage*12,"gems":1 if stage%5==0 else 0}
static func stars(hp_ratio:float)->int:
 return 3 if hp_ratio>=0.8 else (2 if hp_ratio>=0.45 else 1)
