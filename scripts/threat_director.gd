class_name ThreatDirector

static func plan(stage:int,wave:int,player_power:int,history:Array,loadout:Dictionary)->Dictionary:
 var s=clampi(stage,1,250)
 var w=clampi(wave,1,5)
 var total=StageGenerator.threat(s,maxi(0,player_power))
 var budget=StageGenerator.wave_budget(total,w)
 var adaptive=AdaptiveAI.composition(history,loadout)
 var air_ratio=0.08 if w<3 else 0.18
 if str(adaptive.get("counter",""))=="sam":air_ratio=maxf(0.05,air_ratio-0.05)
 if s%10==0 and w==5:
  return {
   "budget":budget,
   "boss":BossSystem.profile(s),
   "air_ratio":air_ratio,
   "counter":str(adaptive.get("counter",""))
  }
 return {
  "budget":budget,
  "boss":null,
  "air_ratio":air_ratio,
  "counter":str(adaptive.get("counter",""))
 }
