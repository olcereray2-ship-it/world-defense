class_name PlayerProfile
static func defaults()->Dictionary:
 return {"name":"Commander","level":1,"xp":0,"vip_xp":0,"ads":0,"themes":["command_navy"],"selected_theme":"command_navy","language":"en","daily_streak":0,"last_daily":0,"achievements":[],"mission_progress":{}}
static func level_from_xp(xp:int)->int:return min(100,1+int(sqrt(max(0,xp)/180.0)))
