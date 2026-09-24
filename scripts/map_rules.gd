class_name MapRules
static func build_zones(route:PackedVector2Array)->Array:
 var zones:Array=[]
 for i in range(route.size()-1):
  var a=route[i];var b=route[i+1];var mid=(a+b)*0.5
  var n=(b-a).normalized().orthogonal()
  zones.append(mid+n*190);zones.append(mid-n*190)
 return zones
static func nearest_valid(pos:Vector2,zones:Array)->Vector2:
 var best=zones[0];var d=INF
 for z in zones:
  var nd=pos.distance_squared_to(z)
  if nd<d:d=nd;best=z
 return best
