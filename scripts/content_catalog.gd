class_name ContentCatalog
const TOWERS=["machine_gun","cannon","missile","laser","tesla"]
const UNITS=["infantry","tank","artillery","helicopter","fighter"]
const DEFENSES=["wall","barbed_wire","minefield","bunker","aa_gun","sam","radar","repair","supply","command","emp","drone_interceptor","electronic_warfare"]
const ENEMIES=["assault","heavy","fast_armor","heavy_tank","anti_tank","aa_vehicle","sam","helicopter","fighter","bomber","artillery","ew","support","boss"]
const BIOMES=["desert","city","snow","mountain","coast"]
static func visual_tier(level:int)->int:
 if level>=100:return 5
 if level>=75:return 4
 if level>=50:return 3
 if level>=25:return 2
 if level>=10:return 1
 return 0
static func tower_stats(kind:String,level:int)->Dictionary:
 var base={"machine_gun":[18,260,0.18],"cannon":[55,310,0.75],"missile":[78,390,1.05],"laser":[34,300,0.28],"tesla":[42,270,0.55]}[kind]
 var scale=1.0+(level-1)*0.065
 return {"damage":base[0]*scale,"range":base[1]*(1.0+visual_tier(level)*0.025),"cooldown":max(0.08,base[2]*(1.0-(level-1)*0.0025))}
