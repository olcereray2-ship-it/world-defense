class_name StageGenerator
static func stage_data(stage:int)->Dictionary:
 var biomes=["desert","city","snow","mountain","coast"]
 var routes=["single","double","triple","y","x","ring","spiral","parallel","bridge","central"]
 var baseline=900+stage*520+int(pow(stage,1.45)*90.0)
 return {"stage":stage,"biome":biomes[(stage-1)%biomes.size()],"route":routes[(stage*7)%routes.size()],"bridge":stage%4==0 or stage%9==0,"baseline":baseline,"boss":stage%10==0}
static func threat(stage:int,player_power:int)->int:
 var base=int(stage_data(stage).baseline)
 var soft=int(base+(max(0,player_power-base)*0.38))
 return max(int(base*0.92),soft)
static func wave_budget(total:int,wave:int)->int:
 var weights=[0.12,0.17,0.21,0.23,0.27]
 return int(total*weights[clamp(wave-1,0,4)])
