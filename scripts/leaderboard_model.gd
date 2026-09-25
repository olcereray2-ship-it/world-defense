class_name LeaderboardModel

static func score(stage:int,xp:int,power:int)->int:
 return clampi(stage,1,250)*100000+maxi(0,xp)*10+maxi(0,power)

static func local_row(profile:Dictionary,stage:int,xp:int,power:int)->Dictionary:
 return {
  "name":str(profile.get("name","Commander")).strip_edges() if not str(profile.get("name","Commander")).strip_edges().is_empty() else "Commander",
  "stage":clampi(stage,1,250),
  "power":maxi(0,power),
  "score":score(stage,xp,power)
 }
