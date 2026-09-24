class_name BridgeRules
static func can_place_fixed(stage_data:Dictionary,pos:Vector2)->bool:
 if not stage_data.get("bridge",false):return true
 var bridge=Rect2(420,1100,270,230)
 return not bridge.has_point(pos)
static func mobile_hold_bonus(unit:String)->float:
 return {"infantry":1.10,"tank":1.18,"artillery":0.85,"helicopter":1.0,"fighter":1.0}.get(unit,1.0)
