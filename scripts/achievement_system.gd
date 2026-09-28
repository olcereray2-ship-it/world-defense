class_name AchievementSystem

static func evaluate(stage:int,kills:int,upgrades:int)->Array:
 var out:Array=[]
 var s=clampi(stage,1,250)
 var k=maxi(0,kills)
 var u=maxi(0,upgrades)
 if s>=25:out.append("frontier_25")
 if s>=100:out.append("centurion")
 if s>=250:out.append("world_defender")
 if k>=1000:out.append("destroyer")
 if u>=100:out.append("engineer")
 return out
