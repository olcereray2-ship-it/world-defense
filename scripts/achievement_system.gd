class_name AchievementSystem
static func evaluate(stage:int,kills:int,upgrades:int)->Array:
 var out:Array=[]
 if stage>=25:out.append("frontier_25")
 if stage>=100:out.append("centurion")
 if stage>=250:out.append("world_defender")
 if kills>=1000:out.append("destroyer")
 if upgrades>=100:out.append("engineer")
 return out
