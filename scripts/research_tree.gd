class_name ResearchTree
const BRANCHES={
"defense":["reinforced_base","tower_range","repair_speed","barrier_hp"],
"ground":["infantry_drill","tank_armor","artillery_guidance","mobile_speed"],
"air":["rotor_training","fighter_payload","sam_tracking","radar_range"],
"logistics":["production","warehouse","offline_rate","refund"]}
static func cost(branch:String,level:int)->Dictionary:
 return {"gold":int(900*pow(1.12,level)),"research":int(80*pow(1.09,level))}
