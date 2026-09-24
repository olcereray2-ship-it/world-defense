class_name LeaderboardModel
static func score(stage:int,xp:int,power:int)->int:return stage*100000+xp*10+power
static func local_row(profile:Dictionary,stage:int,xp:int,power:int)->Dictionary:
 return {"name":profile.get("name","Commander"),"stage":stage,"power":power,"score":score(stage,xp,power)}
