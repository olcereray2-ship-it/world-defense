class_name MissionSystem
static func update(progress:Dictionary,event:String,amount:int=1)->Dictionary:
 progress[event]=int(progress.get(event,0))+amount
 return progress
static func daily_seed()->int:
 var d=Time.get_date_dict_from_system()
 return int(d.year)*10000+int(d.month)*100+int(d.day)
