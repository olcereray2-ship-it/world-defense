class_name ContentCatalog

const TOWERS=["machine_gun","cannon","missile","laser","tesla"]
const UNITS=["infantry","tank","artillery","helicopter","fighter"]
const DEFENSES=["wall","barbed_wire","minefield","bunker","aa_gun","sam","radar","repair","supply","command","emp","drone_interceptor","electronic_warfare"]
const ENEMIES=["assault","heavy","fast_armor","heavy_tank","anti_tank","aa_vehicle","sam","helicopter","fighter","bomber","artillery","ew","support","boss"]
const BIOMES=["desert","city","snow","mountain","coast"]

static func visual_tier(level:int)->int:
 return UnitCatalog.visual_tier(level)

static func tower_stats(kind:String,level:int)->Dictionary:
 return UnitCatalog.tower_stats(kind,level)
