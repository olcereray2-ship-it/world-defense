class_name MobileArmy
static func stats(kind:String,level:int)->Dictionary:
 var b={"infantry":[120.0,18.0,105.0],"tank":[520.0,62.0,62.0],"artillery":[230.0,95.0,48.0],"helicopter":[260.0,74.0,120.0],"fighter":[210.0,110.0,180.0]}[kind]
 var s=1.0+(level-1)*0.06
 return {"hp":b[0]*s,"damage":b[1]*s,"speed":b[2]*(1.0+(level-1)*0.0015)}
static func matchup(attacker:String,target:String)->float:
 var key=attacker+":"+target
 return {"helicopter:tank":1.45,"tank:aa":1.35,"aa:helicopter":1.55,"artillery:heavy":1.45,"fighter:bomber":1.6,"sam:fighter":1.55}.get(key,1.0)
