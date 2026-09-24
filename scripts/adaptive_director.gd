class_name AdaptiveDirector
static func composition(stage:int,power:Dictionary,seed:int)->Array:
 var pool=EnemyCatalog.stage_pool(stage);var rng=RandomNumberGenerator.new();rng.seed=seed
 var out:Array=[]
 for i in range(20):out.append(pool[rng.randi_range(0,pool.size()-1)])
 var dominant="ground";var best=-1.0
 for k in power:
  if float(power[k])>best:best=float(power[k]);dominant=str(k)
 var counter={"air":"sam","armor":"anti_tank","ground":"heavy","tower":"artillery"}.get(dominant,"assault")
 for i in range(5):out[rng.randi_range(0,out.size()-1)]=counter
 return out
