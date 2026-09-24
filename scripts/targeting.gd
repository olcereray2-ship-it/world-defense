class_name Targeting
static func priority(tower:String,enemy:String)->float:
 var table={"machine_gun":{"assault":1.5,"heavy":1.25},"cannon":{"heavy_tank":1.6,"fast_armor":1.4},"missile":{"helicopter":1.55,"fighter":1.6,"bomber":1.7},"laser":{"ew":1.4,"support":1.45},"tesla":{"fast_armor":1.35,"support":1.3}}
 return float(table.get(tower,{}).get(enemy,1.0))
