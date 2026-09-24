extends Node
var stage:=1
var gold:=2500
var gems:=20
var xp:=0
var tower_levels={"machine_gun":1,"cannon":1,"missile":1,"laser":1,"tesla":1}
var unit_levels={"infantry":1,"tank":1,"artillery":1,"helicopter":1,"fighter":1}
var facility_levels={"hq":1,"factory":1,"hangar":1,"airbase":1,"ammo":1,"warehouse":1}
var battle_history:Array=[]
const SAVE="user://world_defense.save"
func _ready(): load_game()
func save_game():
 var d={"stage":stage,"gold":gold,"gems":gems,"xp":xp,"tower_levels":tower_levels,"unit_levels":unit_levels,"facility_levels":facility_levels,"battle_history":battle_history,"saved_at":Time.get_unix_time_from_system()}
 var f=FileAccess.open(SAVE,FileAccess.WRITE); f.store_var(d)
func load_game():
 if not FileAccess.file_exists(SAVE): return
 var f=FileAccess.open(SAVE,FileAccess.READ); var d=f.get_var()
 stage=int(d.get("stage",1)); gold=int(d.get("gold",2500)); gems=int(d.get("gems",20)); xp=int(d.get("xp",0))
 tower_levels=d.get("tower_levels",tower_levels); unit_levels=d.get("unit_levels",unit_levels); facility_levels=d.get("facility_levels",facility_levels); battle_history=d.get("battle_history",[])
func power()->int:
 var s=0
 for v in tower_levels.values(): s+=int(v)*120
 for v in unit_levels.values(): s+=int(v)*145
 return s
func offline_hours()->float:
 if not FileAccess.file_exists(SAVE): return 0.0
 var f=FileAccess.open(SAVE,FileAccess.READ); var d=f.get_var()
 return min(6.0,max(0.0,(Time.get_unix_time_from_system()-float(d.get("saved_at",Time.get_unix_time_from_system())))/3600.0))
