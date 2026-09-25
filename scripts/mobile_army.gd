class_name MobileArmy

static func stats(kind:String,level:int)->Dictionary:
 return UnitCatalog.army_stats(kind,level)

static func matchup(attacker:String,target:String)->float:
 var key=attacker+":"+target
 return {
  "infantry:assault":1.15,
  "infantry:heavy":1.10,
  "tank:fast_armor":1.30,
  "tank:aa_vehicle":1.20,
  "artillery:heavy":1.45,
  "artillery:heavy_tank":1.35,
  "helicopter:heavy_tank":1.45,
  "helicopter:artillery":1.35,
  "fighter:helicopter":1.35,
  "fighter:bomber":1.60
 }.get(key,1.0)
