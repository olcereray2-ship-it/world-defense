class_name VIPSystem

const THRESHOLDS=[0,100,300,700,1400,2500,4000,6500,10000,15000,22000]

static func level(xp:int)->int:
 var safe_xp=maxi(0,xp)
 var result=0
 for i in range(THRESHOLDS.size()):
  if safe_xp>=THRESHOLDS[i]:result=i
 return result

static func bonus(xp:int)->float:
 return minf(0.15,float(level(xp))*0.015)
