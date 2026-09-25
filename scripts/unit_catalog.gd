class_name UnitCatalog

const TOWERS={
 "machine_gun":{"damage":18.0,"range":260.0,"cooldown":0.18,"role":"anti_infantry"},
 "cannon":{"damage":55.0,"range":310.0,"cooldown":0.75,"role":"anti_armor"},
 "missile":{"damage":78.0,"range":390.0,"cooldown":1.05,"role":"anti_air"},
 "laser":{"damage":34.0,"range":300.0,"cooldown":0.28,"role":"precision"},
 "tesla":{"damage":42.0,"range":270.0,"cooldown":0.55,"role":"crowd_control"}
}

const ARMY={
 "infantry":{"hp":120.0,"damage":18.0,"speed":105.0},
 "tank":{"hp":520.0,"damage":62.0,"speed":62.0},
 "artillery":{"hp":230.0,"damage":95.0,"speed":48.0},
 "helicopter":{"hp":260.0,"damage":74.0,"speed":120.0},
 "fighter":{"hp":210.0,"damage":110.0,"speed":180.0}
}

static func visual_tier(level:int)->int:
 var lv=clampi(level,1,100)
 if lv>=100:return 5
 if lv>=75:return 4
 if lv>=50:return 3
 if lv>=25:return 2
 if lv>=10:return 1
 return 0

static func tower_stats(kind:String,level:int)->Dictionary:
 var base:Dictionary=TOWERS.get(kind,TOWERS["machine_gun"])
 var lv=clampi(level,1,100)
 var damage_scale=1.0+float(lv-1)*0.065
 return {
  "damage":float(base["damage"])*damage_scale,
  "range":float(base["range"])*(1.0+float(visual_tier(lv))*0.025),
  "cooldown":maxf(0.08,float(base["cooldown"])*(1.0-float(lv-1)*0.0025)),
  "role":str(base["role"])
 }

static func army_stats(kind:String,level:int)->Dictionary:
 var base:Dictionary=ARMY.get(kind,ARMY["infantry"])
 var lv=clampi(level,1,100)
 var power_scale=1.0+float(lv-1)*0.06
 return {
  "hp":float(base["hp"])*power_scale,
  "damage":float(base["damage"])*power_scale,
  "speed":float(base["speed"])*(1.0+float(lv-1)*0.0015)
 }

static func scaled(base:Dictionary,level:int)->Dictionary:
 var lv=clampi(level,1,100)
 if base.has("cooldown"):
  for kind in TOWERS:
   if TOWERS[kind] == base:return tower_stats(kind,lv)
 var x=base.duplicate(true)
 var m=1.0+0.06*float(lv-1)
 for k in ["hp","damage"]:
  if x.has(k):x[k]=float(x[k])*m
 if x.has("speed"):x["speed"]=float(x["speed"])*(1.0+float(lv-1)*0.0015)
 return x

static func milestone(level:int)->int:
 var lv=clampi(level,1,100)
 for x in [100,75,50,25,10]:
  if lv>=x:return x
 return 1
