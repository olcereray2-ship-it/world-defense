class_name ProductionQueue
const MAX_SLOTS=3
static func enqueue(q:Array,item:String,finish_at:int)->bool:
 if q.size()>=MAX_SLOTS:return false
 q.append({"item":item,"finish_at":finish_at});return true
static func collect_ready(q:Array,now:int)->Array:
 var ready:Array=[]
 for x in q.duplicate():
  if int(x.finish_at)<=now:ready.append(x);q.erase(x)
 return ready
