class_name LuckyBox

static func open_box(stage:int,seed:int)->Dictionary:
 var rng=RandomNumberGenerator.new()
 rng.seed=seed+clampi(stage,1,250)*7919
 var roll=rng.randf()
 if roll<0.05:return {"rarity":"legendary","gems":12}
 if roll<0.20:return {"rarity":"epic","gold":3500}
 if roll<0.50:return {"rarity":"rare","gold":1800}
 return {"rarity":"common","gold":800}
