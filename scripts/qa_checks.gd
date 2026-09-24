class_name QAChecks
static func run()->Array:
 var errors:Array=[]
 for s in range(1,251):
  var d=StageGenerator.stage_data(s)
  if int(d.stage)!=s:errors.append("stage_%d_id"%s)
  if StageGenerator.threat(s,0)<=0:errors.append("stage_%d_threat"%s)
  var total=0
  for w in range(1,6):total+=StageGenerator.wave_budget(10000,w)
  if total<9900 or total>10100:errors.append("wave_budget_%d"%s)
 for l in [1,10,25,50,75,100]:
  if ContentCatalog.visual_tier(l)<0:errors.append("tier_%d"%l)
 return errors
