class_name AdaptiveAI
static func composition(history:Array,loadout:Dictionary)->Dictionary:
 var normal:=0.75; var counter:=0.25
 var scores={"infantry":0.0,"armor":0.0,"air":0.0,"tower":0.0}
 for k in scores.keys(): scores[k]=float(loadout.get(k,0.0))
 for b in history.slice(max(0,history.size()-10)):
  var dom=str(b.get("dominant","")); if scores.has(dom): scores[dom]+=0.15
 var dominant="infantry"; var best=-1.0
 for k in scores:
  if scores[k]>best: best=scores[k]; dominant=k
 var counters={"infantry":"aoe","armor":"anti_tank","air":"sam","tower":"artillery"}
 return {"normal":normal,"adaptive":counter,"dominant":dominant,"counter":counters[dominant]}
