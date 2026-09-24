class_name AbilitySystem
const COOLDOWNS={"airstrike":45.0,"reinforcement":60.0,"emp":55.0}
static func airstrike(enemies:Array,center:Vector2):
 for e in enemies.duplicate():
  if e.p.distance_to(center)<210:e.hp-=240.0
static func emp(enemies:Array,center:Vector2):
 for e in enemies:
  if e.p.distance_to(center)<280:e.speed*=0.55
