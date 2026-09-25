class_name AdaptiveAI

static func composition(history:Array,loadout:Dictionary)->Dictionary:
 var normal:=0.75
 var counter_ratio:=0.25
 var scores={"infantry":0.0,"armor":0.0,"air":0.0,"tower":0.0}
 for k in scores.keys():scores[k]=maxf(0.0,float(loadout.get(k,0.0)))
 var start=maxi(0,history.size()-10)
 for i in range(start,history.size()):
  var b=history[i]
  if not b is Dictionary:continue
  var dom=str(b.get("dominant",""))
  if scores.has(dom):scores[dom]=float(scores[dom])+0.15
 var dominant="infantry"
 var best=-INF
 for k in scores:
  if float(scores[k])>best:
   best=float(scores[k])
   dominant=str(k)
 var counters={"infantry":"aoe","armor":"anti_tank","air":"sam","tower":"artillery"}
 return {"normal":normal,"adaptive":counter_ratio,"dominant":dominant,"counter":counters[dominant]}
