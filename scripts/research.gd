class_name ResearchTree
const BRANCHES={"defense":["armor_plating","range","repair"],"ground":["infantry","armor","artillery"],"air":["helicopter","fighter","strike"],"logistics":["production","storage","offline"]}
static func cost(branch:String,level:int)->Dictionary:
 var mult={"defense":1.0,"ground":1.05,"air":1.2,"logistics":0.9}.get(branch,1.0)
 return {"gold":int(900*pow(1.12,level)*mult),"supplies":int(220*pow(1.09,level)*mult)}
static func bonus(level:int)->float:return min(0.30,level*0.012)
