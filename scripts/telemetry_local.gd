class_name LocalTelemetry

static func event(log:Array,name:String,data:Dictionary={}):
 var event_name=name.strip_edges()
 if event_name.is_empty():return
 log.append({
  "event":event_name,
  "data":data.duplicate(true),
  "ts":Time.get_unix_time_from_system()
 })
 while log.size()>200:log.pop_front()
