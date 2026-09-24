class_name OfflineProduction
const CAP_SECONDS=21600
static func calculate(last_seen:int,now:int,rates:Dictionary)->Dictionary:
 var sec=clampi(now-last_seen,0,CAP_SECONDS);var out={"seconds":sec}
 for k in rates:out[k]=int(float(rates[k])*sec/3600.0)
 return out
