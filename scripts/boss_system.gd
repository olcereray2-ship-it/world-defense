class_name BossSystem
static func profile(stage:int)->Dictionary:
 var cycle=(stage/10)%5
 var profiles=[
  {"name":"JUGGERNAUT","rule":"armor","hp":8.0,"support":"heavy"},
  {"name":"SKY REAPER","rule":"air","hp":6.5,"support":"fighter"},
  {"name":"SIEGE LORD","rule":"tower_suppression","hp":7.0,"support":"artillery"},
  {"name":"BLACKOUT","rule":"radar_jam","hp":6.0,"support":"ew"},
  {"name":"SWARM CORE","rule":"reinforcements","hp":9.0,"support":"support"}]
 return profiles[cycle]
