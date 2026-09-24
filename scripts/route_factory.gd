class_name RouteFactory
static func points(route:String)->PackedVector2Array:
 var r={
 "single":[Vector2(-50,1250),Vector2(260,1120),Vector2(540,1280),Vector2(820,1030),Vector2(1130,930)],
 "double":[Vector2(-50,1050),Vector2(300,970),Vector2(600,1160),Vector2(1130,930)],
 "triple":[Vector2(-50,1420),Vector2(300,1250),Vector2(590,1050),Vector2(1130,930)],
 "y":[Vector2(-50,1450),Vector2(350,1240),Vector2(540,1100),Vector2(1130,930)],
 "x":[Vector2(-50,900),Vector2(420,1180),Vector2(700,1080),Vector2(1130,930)],
 "ring":[Vector2(-50,1200),Vector2(250,1000),Vector2(540,900),Vector2(800,1100),Vector2(1130,930)],
 "spiral":[Vector2(-50,1500),Vector2(250,1350),Vector2(780,1380),Vector2(800,900),Vector2(420,850),Vector2(1130,930)],
 "parallel":[Vector2(-50,1150),Vector2(350,1150),Vector2(700,1000),Vector2(1130,930)],
 "bridge":[Vector2(-50,1350),Vector2(320,1200),Vector2(550,1180),Vector2(760,1050),Vector2(1130,930)],
 "central":[Vector2(-50,950),Vector2(300,1050),Vector2(540,1200),Vector2(800,1050),Vector2(1130,930)]}
 return PackedVector2Array(r.get(route,r.single))
