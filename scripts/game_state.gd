extends Node

const SAVE="user://world_defense.save"
const DEFAULT_TOWER_LEVELS={"machine_gun":1,"cannon":1,"missile":1,"laser":1,"tesla":1}
const DEFAULT_UNIT_LEVELS={"infantry":1,"tank":1,"artillery":1,"helicopter":1,"fighter":1}
const DEFAULT_FACILITY_LEVELS={"hq":1,"factory":1,"hangar":1,"airbase":1,"ammo":1,"warehouse":1}

var stage:=1
var gold:=2500
var gems:=20
var supplies:=500
var xp:=0
var tower_levels=DEFAULT_TOWER_LEVELS.duplicate(true)
var unit_levels=DEFAULT_UNIT_LEVELS.duplicate(true)
var facility_levels=DEFAULT_FACILITY_LEVELS.duplicate(true)
var battle_history:Array=[]
var last_offline_claim:=0

func _ready():
 load_game()
 if last_offline_claim<=0:last_offline_claim=int(Time.get_unix_time_from_system())

func _sanitize_levels(value:Variant,defaults:Dictionary,max_level:int)->Dictionary:
 var out=defaults.duplicate(true)
 if value is Dictionary:
  for k in out.keys():
   if value.has(k):out[k]=clampi(int(value[k]),1,max_level)
 return out

func save_game()->bool:
 var now=int(Time.get_unix_time_from_system())
 if last_offline_claim<=0:last_offline_claim=now
 var d={
  "save_version":SaveMigration.VERSION,
  "stage":clampi(stage,1,250),
  "gold":maxi(0,gold),
  "gems":maxi(0,gems),
  "supplies":maxi(0,supplies),
  "xp":maxi(0,xp),
  "tower_levels":tower_levels,
  "unit_levels":unit_levels,
  "facility_levels":facility_levels,
  "battle_history":battle_history,
  "last_offline_claim":last_offline_claim,
  "saved_at":now
 }
 var f=FileAccess.open(SAVE,FileAccess.WRITE)
 if f==null:
  push_error("WORLD_DEFENSE_SAVE_WRITE_FAILED:%s"%FileAccess.get_open_error())
  return false
 f.store_var(d)
 return true

func load_game()->bool:
 if not FileAccess.file_exists(SAVE):return false
 var f=FileAccess.open(SAVE,FileAccess.READ)
 if f==null:
  push_error("WORLD_DEFENSE_SAVE_READ_FAILED:%s"%FileAccess.get_open_error())
  return false
 var raw=f.get_var()
 if not (raw is Dictionary):
  push_error("WORLD_DEFENSE_SAVE_INVALID")
  return false
 var d=SaveMigration.migrate(raw)
 stage=clampi(int(d.get("stage",1)),1,250)
 gold=maxi(0,int(d.get("gold",2500)))
 gems=maxi(0,int(d.get("gems",20)))
 supplies=maxi(0,int(d.get("supplies",500)))
 xp=maxi(0,int(d.get("xp",0)))
 tower_levels=_sanitize_levels(d.get("tower_levels",{}),DEFAULT_TOWER_LEVELS,100)
 unit_levels=_sanitize_levels(d.get("unit_levels",{}),DEFAULT_UNIT_LEVELS,100)
 facility_levels=_sanitize_levels(d.get("facility_levels",{}),DEFAULT_FACILITY_LEVELS,100)
 var history=d.get("battle_history",[])
 battle_history=history.duplicate(true) if history is Array else []
 while battle_history.size()>10:battle_history.pop_front()
 var fallback_claim=int(d.get("saved_at",Time.get_unix_time_from_system()))
 last_offline_claim=maxi(0,int(d.get("last_offline_claim",fallback_claim)))
 return true

func power()->int:
 var s=0
 for v in tower_levels.values():s+=int(v)*120
 for v in unit_levels.values():s+=int(v)*145
 return s

func offline_hours()->float:
 if last_offline_claim<=0:return 0.0
 var seconds=maxf(0.0,Time.get_unix_time_from_system()-float(last_offline_claim))
 return minf(6.0,seconds/3600.0)

func mark_offline_claimed():
 last_offline_claim=int(Time.get_unix_time_from_system())

func loadout_profile()->Dictionary:
 return {
  "infantry":float(unit_levels.get("infantry",1)),
  "armor":float(unit_levels.get("tank",1))+float(unit_levels.get("artillery",1))*0.5,
  "air":float(unit_levels.get("helicopter",1))+float(unit_levels.get("fighter",1)),
  "tower":float(power())/500.0
 }

func record_battle(result:String):
 var p=loadout_profile()
 var dominant="infantry"
 var best=-INF
 for k in p:
  if float(p[k])>best:
   best=float(p[k])
   dominant=str(k)
 battle_history.append({"stage":stage,"result":result,"dominant":dominant})
 while battle_history.size()>10:battle_history.pop_front()
