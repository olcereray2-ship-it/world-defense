class_name SaveMigration
const VERSION=3
static func migrate(d:Dictionary)->Dictionary:
 var v=int(d.get("save_version",1))
 if v<2:d["research"]={};d["generals"]={};v=2
 if v<3:d["events"]={};d["achievements"]=[];v=3
 d["save_version"]=VERSION
 return d
