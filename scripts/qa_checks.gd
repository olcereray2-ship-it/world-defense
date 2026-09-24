class_name QAChecks
static func run()->Array:
 var errors:Array=[]
 var last_threat=0
 for s in range(1,251):
  var d=StageGenerator.stage_data(s)
  if int(d.stage)!=s:errors.append("stage_%d_id"%s)
  var threat=StageGenerator.threat(s,0)
  if threat<=0:errors.append("stage_%d_threat"%s)
  if threat<last_threat:errors.append("stage_%d_regression"%s)
  last_threat=threat
  var total=0
  for w in range(1,6):
   var b=StageGenerator.wave_budget(10000,w)
   if b<=0:errors.append("stage_%d_wave_%d"%[s,w])
   total+=b
  if total<9900 or total>10100:errors.append("wave_budget_%d"%s)
  if s%10==0 and BossSystem.profile(s).is_empty():errors.append("boss_%d"%s)
 for l in [1,10,25,50,75,100]:
  if ContentCatalog.visual_tier(l)<0:errors.append("tier_%d"%l)
 for k in ContentCatalog.TOWERS:
  var st=ContentCatalog.tower_stats(k,100)
  if st.damage<=0 or st.range<=0:errors.append("tower_"+k)
 for u in ContentCatalog.UNITS:
  if MobileArmy.stats(u,100).hp<=0:errors.append("unit_"+u)
 var bridge_stage={"bridge":true}
 if BridgeRules.can_place_fixed(bridge_stage,Vector2(500,1200)):errors.append("bridge_build_rule")
 if BaseEconomy.offline_reward({"factory":1,"ammo":1,"warehouse":1},12.0).hours!=6.0:errors.append("offline_cap")
 return errors
