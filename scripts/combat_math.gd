class_name CombatMath
static func damage(raw:float,armor:float,mult:float=1.0)->float:return max(1.0,raw*mult*(100.0/(100.0+max(0.0,armor))))
static func crit(raw:float,chance:float,rng:RandomNumberGenerator)->float:return raw*1.75 if rng.randf()<chance else raw
static func dps(damage:float,cooldown:float)->float:return damage/max(0.05,cooldown)
