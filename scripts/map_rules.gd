class_name MapRules

static func build_zones(route:PackedVector2Array)->Array:
 var zones:Array=[]
 if route.size()<2:return zones
 for i in range(route.size()-1):
  var a:Vector2=route[i]
  var b:Vector2=route[i+1]
  var delta=b-a
  if delta.length_squared()<0.001:continue
  var mid=(a+b)*0.5
  var n=delta.normalized().orthogonal()
  zones.append(mid+n*190.0)
  zones.append(mid-n*190.0)
 return zones

static func nearest_valid(pos:Vector2,zones:Array)->Vector2:
 if zones.is_empty():return pos
 var best:Vector2=zones[0]
 var d:=INF
 for z in zones:
  var zv:Vector2=z
  var nd=pos.distance_squared_to(zv)
  if nd<d:
   d=nd
   best=zv
 return best
