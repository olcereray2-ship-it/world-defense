class_name StageGenerator
static func data(stage:int)->Dictionary:
 var biomes=["desert","city","snow","mountain","coast"];var routes=["single","double","y","x","ring","spiral","parallel","bridge","central"]
 return {"stage":stage,"biome":biomes[(stage-1)%biomes.size()],"route":routes[(stage*7)%routes.size()],"bridge":stage%4==0 or stage%9==0,"boss":stage%10==0}
static func threat(stage:int,player_power:int)->int:
 var baseline=900+stage*520+int(pow(stage,1.45)*90.0);return max(int(baseline*0.92),int(baseline+max(0,player_power-baseline)*0.38))
static func wave_budget(total:int,wave:int)->int:
 var weights=[0.12,0.17,0.21,0.23,0.27];return int(total*weights[clampi(wave-1,0,4)])
static func route(kind:String)->PackedVector2Array:
 var r={"single":[Vector2(-50,1280),Vector2(260,1110),Vector2(520,1280),Vector2(790,1040),Vector2(1140,920)],"double":[Vector2(-50,1050),Vector2(300,970),Vector2(600,1160),Vector2(1140,920)],"y":[Vector2(-50,1450),Vector2(350,1240),Vector2(540,1100),Vector2(1140,920)],"x":[Vector2(-50,900),Vector2(420,1180),Vector2(700,1080),Vector2(1140,920)],"ring":[Vector2(-50,1200),Vector2(250,1000),Vector2(540,900),Vector2(800,1100),Vector2(1140,920)],"spiral":[Vector2(-50,1500),Vector2(250,1350),Vector2(780,1380),Vector2(800,900),Vector2(420,850),Vector2(1140,920)],"parallel":[Vector2(-50,1150),Vector2(350,1150),Vector2(700,1000),Vector2(1140,920)],"bridge":[Vector2(-50,1350),Vector2(320,1200),Vector2(550,1180),Vector2(760,1050),Vector2(1140,920)],"central":[Vector2(-50,950),Vector2(300,1050),Vector2(540,1200),Vector2(800,1050),Vector2(1140,920)]}
 return PackedVector2Array(r.get(kind,r["single"]))
