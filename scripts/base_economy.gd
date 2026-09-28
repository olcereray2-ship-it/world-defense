class_name BaseEconomy

static func production_per_hour(levels:Dictionary)->Dictionary:
 var factory=clampi(int(levels.get("factory",1)),1,100)
 var ammo=clampi(int(levels.get("ammo",1)),1,100)
 var warehouse=clampi(int(levels.get("warehouse",1)),1,100)
 return {"gold":300+factory*75,"supplies":120+ammo*40,"capacity":2000+warehouse*500}

static func offline_reward(levels:Dictionary,hours:float)->Dictionary:
 var h=clampf(hours,0.0,6.0)
 var p=production_per_hour(levels)
 var cap=int(p.get("capacity",0))
 return {
  "gold":mini(cap,int(float(p.get("gold",0))*h)),
  "supplies":mini(cap,int(float(p.get("supplies",0))*h)),
  "hours":h
 }
