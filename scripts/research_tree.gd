class_name ResearchTree

const BRANCHES={
 "defense":["reinforced_base","tower_range","repair_speed","barrier_hp"],
 "ground":["infantry_drill","tank_armor","artillery_guidance","mobile_speed"],
 "air":["rotor_training","fighter_payload","sam_tracking","radar_range"],
 "logistics":["production","warehouse","offline_rate","refund"]
}
const MULTIPLIERS={"defense":1.0,"ground":1.05,"air":1.20,"logistics":0.90}

static func cost(branch:String,level:int)->Dictionary:
 var lv=maxi(1,level)
 var mult=float(MULTIPLIERS.get(branch,1.0))
 return {
  "gold":int(900.0*pow(1.12,float(lv-1))*mult),
  "supplies":int(220.0*pow(1.09,float(lv-1))*mult)
 }

static func bonus(level:int)->float:
 return minf(0.30,float(maxi(0,level))*0.012)
