class_name SaveMigration

const VERSION=3

static func migrate(source:Dictionary)->Dictionary:
 var d=source.duplicate(true)
 var v=int(d.get("save_version",1))
 if v<2:
  if not d.has("research"):d["research"]={}
  if not d.has("generals"):d["generals"]={}
  v=2
 if v<3:
  if not d.has("events"):d["events"]={}
  if not d.has("achievements"):d["achievements"]=[]
  v=3
 if not d.has("research"):d["research"]={}
 if not d.has("generals"):d["generals"]={}
 if not d.has("events"):d["events"]={}
 if not d.has("achievements"):d["achievements"]=[]
 d["save_version"]=VERSION
 return d
