class_name CombatMath

static func damage(raw:float,armor:float,mult:float=1.0)->float:
 return maxf(1.0,maxf(0.0,raw)*maxf(0.0,mult)*(100.0/(100.0+maxf(0.0,armor))))

static func crit(raw:float,chance:float,rng:RandomNumberGenerator)->float:
 if rng==null:return maxf(0.0,raw)
 return maxf(0.0,raw)*1.75 if rng.randf()<clampf(chance,0.0,1.0) else maxf(0.0,raw)

static func dps(damage_value:float,cooldown:float)->float:
 return maxf(0.0,damage_value)/maxf(0.05,cooldown)
