class_name LuckyWheel
const PRIZES=[{"gold":500},{"gold":900},{"gems":2},{"gold":1400},{"gems":4},{"gold":2200},{"gems":8},{"gold":700}]
static func spin(seed:int)->Dictionary:
 var rng=RandomNumberGenerator.new();rng.seed=seed
 return PRIZES[rng.randi_range(0,PRIZES.size()-1)].duplicate()
