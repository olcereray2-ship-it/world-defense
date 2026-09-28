class_name StageGenerator

const BIOMES=["desert","city","snow","mountain","coast"]
const ROUTES=["single","double","y","x","ring","spiral","parallel","bridge","central"]

static func data(stage:int)->Dictionary:
 var s=clampi(stage,1,250)
 return {
  "stage":s,
  "biome":BIOMES[(s-1)%BIOMES.size()],
  "route":ROUTES[(s*7)%ROUTES.size()],
  "bridge":s%4==0 or s%9==0,
  "boss":s%10==0
 }

static func threat(stage:int,player_power:int)->int:
 var s=clampi(stage,1,250)
 var baseline=900+s*520+int(pow(float(s),1.45)*90.0)
 var delta=player_power-baseline
 var factor=0.38 if delta>0 else 0.08
 var adjusted=baseline+int(float(delta)*factor)
 return maxi(int(float(baseline)*0.92),adjusted)

static func wave_budget(total:int,wave:int)->int:
 var weights=[0.12,0.17,0.21,0.23,0.27]
 return int(maxi(0,total)*float(weights[clampi(wave-1,0,4)]))

static func route(kind:String)->PackedVector2Array:
 return RouteFactory.points(kind)
