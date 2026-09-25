class_name SaveMigration

const VERSION=4

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
 if v<4:
  if not d.has("supplies"):d["supplies"]=500
  if not d.has("last_offline_claim"):
   d["last_offline_claim"]=int(d.get("saved_at",Time.get_unix_time_from_system()))
  v=4
 if not d.has("research"):d["research"]={}
 if not d.has("generals"):d["generals"]={}
 if not d.has("events"):d["events"]={}
 if not d.has("achievements"):d["achievements"]=[]
 if not d.has("supplies"):d["supplies"]=500
 if not d.has("last_offline_claim"):
  d["last_offline_claim"]=int(d.get("saved_at",Time.get_unix_time_from_system()))
 d["save_version"]=VERSION
 return d
