class_name DailyReward

static func claimable(last_claim:int)->bool:
 return Time.get_unix_time_from_system()-float(maxi(0,last_claim))>=20.0*3600.0

static func reward(streak:int)->Dictionary:
 var safe_streak=maxi(0,streak)
 var day=(safe_streak%7)+1
 return {"day":day,"gold":400+day*180,"gems":5 if day==7 else (1 if day>=4 else 0)}
