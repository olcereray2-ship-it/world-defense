class_name AbilitySystem

const COOLDOWNS={"airstrike":45.0,"reinforcement":60.0,"emp":55.0}

static func airstrike(enemies:Array,center:Vector2)->Array:
 var killed:Array=[]
 for e in enemies.duplicate():
  var pos:Vector2=e.get("p",Vector2.ZERO)
  if pos.distance_to(center)<210.0:
   e["hp"]=float(e.get("hp",0.0))-240.0
   if float(e.get("hp",0.0))<=0.0:
    killed.append(e)
    enemies.erase(e)
 return killed

static func emp(enemies:Array,center:Vector2)->int:
 var affected:=0
 for e in enemies:
  var pos:Vector2=e.get("p",Vector2.ZERO)
  if pos.distance_to(center)<280.0:
   e["speed"]=maxf(1.0,float(e.get("speed",0.0))*0.55)
   affected+=1
 return affected
