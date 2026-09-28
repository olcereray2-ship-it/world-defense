class_name AdaptiveDirector

const COUNTERS={
 "air":["sam","aa_vehicle"],
 "armor":["anti_tank","heavy_tank"],
 "ground":["heavy","artillery"],
 "tower":["artillery","ew"]
}

static func composition(stage:int,power:Dictionary,seed:int)->Array:
 var pool=EnemyCatalog.stage_pool(stage)
 if pool.is_empty():return []
 var rng=RandomNumberGenerator.new()
 rng.seed=seed
 var out:Array=[]
 for i in range(20):out.append(pool[rng.randi_range(0,pool.size()-1)])
 var dominant="ground"
 var best=-INF
 for k in power:
  if float(power[k])>best:
   best=float(power[k])
   dominant=str(k)
 var counter=str(pool[0])
 for candidate in COUNTERS.get(dominant,[]):
  if candidate in pool:
   counter=str(candidate)
   break
 for i in range(mini(5,out.size())):
  out[rng.randi_range(0,out.size()-1)]=counter
 return out
