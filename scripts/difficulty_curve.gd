class_name DifficultyCurve
static func multiplier(stage:int)->float:
 var t=clamp(float(stage-1)/249.0,0.0,1.0)
 return 1.0+4.0*pow(t,1.18)
static func enemy_health(stage:int,wave:int)->float:return multiplier(stage)*(0.85+wave*0.12)
static func enemy_damage(stage:int,wave:int)->float:return (0.9+3.2*pow(float(stage-1)/249.0,1.12))*(0.9+wave*0.08)
