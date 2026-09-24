class_name BaseEconomy
static func production_per_hour(levels:Dictionary)->Dictionary:
 var factory=int(levels.get("factory",1)); var ammo=int(levels.get("ammo",1)); var warehouse=int(levels.get("warehouse",1))
 return {"gold":300+factory*75,"supplies":120+ammo*40,"capacity":2000+warehouse*500}
static func offline_reward(levels:Dictionary,hours:float)->Dictionary:
 var h=min(6.0,max(0.0,hours)); var p=production_per_hour(levels)
 return {"gold":int(p.gold*h),"supplies":int(p.supplies*h),"hours":h}
