class_name FacilitySystem

const FACILITIES=["hq","factory","hangar","airbase","ammo","warehouse"]

static func upgrade_cost(kind:String,level:int)->Dictionary:
 var lv=maxi(1,level)
 var mult={"hq":1.4,"factory":1.0,"hangar":1.1,"airbase":1.25,"ammo":0.9,"warehouse":0.85}.get(kind,1.0)
 return {
  "gold":int(700.0*pow(1.105,float(lv-1))*float(mult)),
  "supplies":int(150.0*pow(1.08,float(lv-1))*float(mult))
 }

static func unit_cap(levels:Dictionary,kind:String)->int:
 var gate="airbase" if kind in ["helicopter","fighter"] else ("hangar" if kind in ["tank","artillery"] else "factory")
 return mini(100,maxi(1,int(levels.get(gate,1)))*5+5)
