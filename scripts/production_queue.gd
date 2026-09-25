class_name ProductionQueue

const MAX_SLOTS=3

static func enqueue(q:Array,item:String,finish_at:int)->bool:
 var id=item.strip_edges()
 if id.is_empty() or q.size()>=MAX_SLOTS:return false
 q.append({"item":id,"finish_at":maxi(0,finish_at)})
 return true

static func collect_ready(q:Array,now:int)->Array:
 var ready:Array=[]
 var t=maxi(0,now)
 for x in q.duplicate():
  if not x is Dictionary:
   q.erase(x)
   continue
  if int(x.get("finish_at",0))<=t:
   ready.append(x)
   q.erase(x)
 return ready
