class_name DailyReward
static func claimable(last_claim:int)->bool:
 return Time.get_unix_time_from_system()-last_claim>=20*3600
static func reward(streak:int)->Dictionary:
 var day=(streak%7)+1
 return {"day":day,"gold":400+day*180,"gems":5 if day==7 else (1 if day>=4 else 0)}
