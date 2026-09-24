class_name QAChecks
static func _expect(errors:Array,ok:bool,code:String):
 if not ok:errors.append(code)
static func _json(path:String):
 var text=FileAccess.get_file_as_string(path)
 return JSON.parse_string(text)
static func run()->Array:
 var errors:Array=[]
 var campaign=_json("res://data/campaign_250.json")
 var events=_json("res://data/events_365.json")
 var towers_data=_json("res://data/towers.json")
 var units_data=_json("res://data/units.json")
 var abilities_data=_json("res://data/abilities.json")
 var facilities_data=_json("res://data/facilities.json")
 var biomes_data=_json("res://data/biomes.json")
 _expect(errors,campaign is Array and campaign.size()==250,"campaign_count")
 _expect(errors,events is Array and events.size()==365,"events_count")
 _expect(errors,towers_data is Dictionary and towers_data.size()==5,"tower_data_count")
 _expect(errors,abilities_data is Dictionary and abilities_data.size()==3,"ability_data_count")
 _expect(errors,facilities_data is Dictionary and facilities_data.size()==6,"facility_data_count")
 _expect(errors,biomes_data is Dictionary and biomes_data.size()==5,"biome_data_count")
 _expect(errors,units_data is Dictionary and units_data.get("player",[]).size()==5,"player_unit_data_count")
 _expect(errors,LocalizationManager.supported()==["en","de","fr","ko","ja"],"locales")
 var last_threat=0
 var last_diff=0.0
 for s in range(1,251):
  var d=StageGenerator.data(s)
  _expect(errors,int(d.get("stage",0))==s,"stage_%d_id"%s)
  _expect(errors,str(d.get("biome","")) in ContentCatalog.BIOMES,"stage_%d_biome"%s)
  var route=StageGenerator.route(str(d.get("route","single")))
  _expect(errors,route.size()>=4,"stage_%d_route"%s)
  _expect(errors,MapRules.build_zones(route).size()>=6,"stage_%d_build_zones"%s)
  var threat=StageGenerator.threat(s,0)
  _expect(errors,threat>0,"stage_%d_threat"%s)
  _expect(errors,threat>=last_threat,"stage_%d_threat_regression"%s)
  last_threat=threat
  var diff=DifficultyCurve.multiplier(s)
  _expect(errors,diff>=last_diff,"stage_%d_diff_regression"%s)
  last_diff=diff
  var total=0
  for w in range(1,6):
   var b=StageGenerator.wave_budget(10000,w)
   _expect(errors,b>0,"stage_%d_wave_%d_budget"%[s,w])
   total+=b
   var plan=ThreatDirector.plan(s,w,1000,[],{"infantry":1.0,"armor":0.5,"air":0.2,"tower":0.8})
   _expect(errors,int(plan.get("budget",0))>0,"stage_%d_wave_%d_plan"%[s,w])
  _expect(errors,total>=9900 and total<=10100,"stage_%d_wave_total"%s)
  var pool=EnemyCatalog.stage_pool(s)
  _expect(errors,pool.size()>=2,"stage_%d_enemy_pool"%s)
  for kind in pool:_expect(errors,EnemyCatalog.TYPES.has(kind),"stage_%d_enemy_%s"%[s,kind])
  if s%10==0:_expect(errors,not BossSystem.profile(s).is_empty(),"boss_%d"%s)
 if campaign is Array:
  for i in range(campaign.size()):
   var row=campaign[i]
   _expect(errors,int(row.get("stage",0))==i+1,"campaign_stage_%d"%(i+1))
   _expect(errors,int(row.get("waves",0))==5,"campaign_waves_%d"%(i+1))
   _expect(errors,bool(row.get("boss",false))==((i+1)%10==0),"campaign_boss_%d"%(i+1))
 if events is Array:
  for i in range(events.size()):
   _expect(errors,int(events[i].get("day",0))==i+1,"event_day_%d"%(i+1))
 for k in UnitCatalog.TOWERS.keys():
  for lv in range(1,101):
   var st=UnitCatalog.scaled(UnitCatalog.TOWERS[k],lv)
   _expect(errors,float(st.get("damage",0))>0.0,"tower_%s_lv_%d_damage"%[k,lv])
   _expect(errors,float(st.get("range",0))>0.0,"tower_%s_lv_%d_range"%[k,lv])
 for u in UnitCatalog.ARMY.keys():
  for lv in range(1,101):
   var st=MobileArmy.stats(u,lv)
   _expect(errors,float(st.get("hp",0))>0.0 and float(st.get("damage",0))>0.0 and float(st.get("speed",0))>0.0,"unit_%s_lv_%d"%[u,lv])
 for e in EnemyCatalog.TYPES.keys():
  var st=EnemyCatalog.TYPES[e]
  _expect(errors,float(st.get("hp",0))>0.0 and float(st.get("speed",0))>0.0 and float(st.get("damage",0))>=0.0,"enemy_%s"%e)
 for route_name in ["single","double","y","x","ring","spiral","parallel","bridge","central"]:
  _expect(errors,StageGenerator.route(route_name).size()>=4,"route_"+route_name)
 _expect(errors,not BridgeRules.can_place_fixed({"bridge":true},Vector2(500,1200)),"bridge_build_rule")
 _expect(errors,BaseEconomy.offline_reward({"factory":1,"ammo":1,"warehouse":1},12.0).get("hours",0.0)==6.0,"offline_cap")
 for lang in ["en","de","fr","ko","ja"]:_expect(errors,LocalizationManager.normalize(lang)==lang,"locale_"+lang)
 _expect(errors,LocalizationManager.normalize("tr")=="en","locale_fallback")
 for t in ThemeSystem.THEMES:_expect(errors,ThemeSystem.palette(t).has("accent"),"theme_"+t)
 _expect(errors,not AdPolicy.can_show_interstitial(true,99),"battle_interstitial_block")
 _expect(errors,not AdPolicy.banner_allowed("battle"),"battle_banner_block")
 var migrated=SaveMigration.migrate({"save_version":1})
 _expect(errors,int(migrated.get("save_version",0))==SaveMigration.VERSION,"save_migration")
 _expect(errors,AchievementSystem.evaluate(250,1000,100).has("world_defender"),"achievement_250")
 _expect(errors,LuckyWheel.spin(1234)==LuckyWheel.spin(1234),"wheel_deterministic")
 _expect(errors,LuckyBox.open_box(50,99)==LuckyBox.open_box(50,99),"box_deterministic")
 _expect(errors,VIPSystem.bonus(999999)<=0.15,"vip_cap")
 _expect(errors,GeneralSystem.bonus(50,"legendary")<=0.20,"general_cap")
 var q:Array=[]
 _expect(errors,ProductionQueue.enqueue(q,"infantry",10),"queue_1")
 _expect(errors,ProductionQueue.enqueue(q,"tank",20),"queue_2")
 _expect(errors,ProductionQueue.enqueue(q,"fighter",30),"queue_3")
 _expect(errors,not ProductionQueue.enqueue(q,"extra",40),"queue_cap")
 _expect(errors,ProductionQueue.collect_ready(q,20).size()==2,"queue_collect")
 var a={"p":Vector2.ZERO,"hp":500.0,"speed":100.0}
 AbilitySystem.airstrike([a],Vector2.ZERO)
 _expect(errors,float(a.hp)<500.0,"ability_airstrike")
 AbilitySystem.emp([a],Vector2.ZERO)
 _expect(errors,float(a.speed)<100.0,"ability_emp")
 for dominant in ["air","armor","ground","tower"]:
  var p={dominant:10.0}
  _expect(errors,AdaptiveDirector.composition(120,p,77).size()==20,"adaptive_"+dominant)
 return errors
