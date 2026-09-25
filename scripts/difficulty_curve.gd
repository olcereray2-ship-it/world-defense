class_name DifficultyCurve

static func multiplier(stage:int)->float:
 var s=clampi(stage,1,250)
 var t=clampf(float(s-1)/249.0,0.0,1.0)
 return 1.0+4.0*pow(t,1.18)

static func enemy_health(stage:int,wave:int)->float:
 var w=clampi(wave,1,5)
 return multiplier(stage)*(0.85+float(w)*0.12)

static func enemy_damage(stage:int,wave:int)->float:
 var s=clampi(stage,1,250)
 var w=clampi(wave,1,5)
 var t=float(s-1)/249.0
 return (0.9+3.2*pow(t,1.12))*(0.9+float(w)*0.08)
