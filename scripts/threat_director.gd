class_name ThreatDirector
static func plan(stage:int,wave:int,player_power:int,history:Array,loadout:Dictionary)->Dictionary:
 var total=StageGenerator.threat(stage,player_power)
 var budget=StageGenerator.wave_budget(total,wave)
 var adaptive=AdaptiveAI.composition(history,loadout)
 var air_ratio=0.08 if wave<3 else 0.18
 if adaptive.counter=="sam":air_ratio=max(0.05,air_ratio-0.05)
 if stage%10==0 and wave==5:return {"budget":budget,"boss":BossSystem.profile(stage),"air_ratio":air_ratio,"counter":adaptive.counter}
 return {"budget":budget,"boss":null,"air_ratio":air_ratio,"counter":adaptive.counter}
