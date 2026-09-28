class_name BossSystem

const PROFILES=[
 {"name":"JUGGERNAUT","rule":"armor","hp":8.0,"support":"heavy"},
 {"name":"SKY REAPER","rule":"air","hp":6.5,"support":"fighter"},
 {"name":"SIEGE LORD","rule":"tower_suppression","hp":7.0,"support":"artillery"},
 {"name":"BLACKOUT","rule":"radar_jam","hp":6.0,"support":"ew"},
 {"name":"SWARM CORE","rule":"reinforcements","hp":9.0,"support":"support"}]

static func profile(stage:int)->Dictionary:
 var boss_number=maxi(0,floori(float(maxi(stage,10)-10)/10.0))
 return PROFILES[boss_number%PROFILES.size()].duplicate(true)
