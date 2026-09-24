class_name LocalTelemetry
static func event(log:Array,name:String,data:Dictionary={}):
 log.append({"event":name,"data":data,"ts":Time.get_unix_time_from_system()})
 while log.size()>200:log.pop_front()
