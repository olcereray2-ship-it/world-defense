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
 var generals_data=_json("res://data/generals.json")
 var missions_data=_json("res://data/missions.json")
 var economy_data=_json("res://data/economy.json")
 var config_data=_json("res://data/game_config.json")
 var milestones_data=_json("res://data/stage_milestones.json")

 _expect(errors,campaign is Array and campaign.size()==250,"campaign_count")
 _expect(errors,events is Array and events.size()==365,"events_count")
 _expect(errors,towers_data is Dictionary and towers_data.size()==5,"tower_data_count")
 _expect(errors,abilities_data is Dictionary and abilities_data.size()==3,"ability_data_count")
 _expect(errors,facilities_data is Dictionary and facilities_data.size()==6,"facility_data_count")
 _expect(errors,biomes_data is Dictionary and biomes_data.size()==5,"biome_data_count")
 _expect(errors,generals_data is Dictionary and generals_data.get("generals",[]).size()==4,"generals_data")
 _expect(errors,missions_data is Dictionary and missions_data.get("daily",[]).size()==3 and missions_data.get("weekly",[]).size()==2,"missions_data")
 _expect(errors,economy_data is Dictionary and int(economy_data.get("offline",{}).get("cap_hours",0))==6,"economy_data")
 _expect(errors,config_data is Dictionary and int(config_data.get("stages",0))==250 and int(config_data.get("waves_per_stage",0))==5,"game_config")
 _expect(errors,milestones_data is Dictionary and float(milestones_data.get("difficulty_total_multiplier_at_250",0.0))==5.0,"milestones_data")
 _expect(errors,units_data is Dictionary and units_data.get("player",[])==ContentCatalog.UNITS,"player_unit_catalog")
 _expect(errors,units_data.get("towers",[])==ContentCatalog.TOWERS,"tower_catalog")
 _expect(errors,units_data.get("defenses",[])==ContentCatalog.DEFENSES,"defense_catalog")
 _expect(errors,config_data.get("languages",[])==LocalizationManager.supported(),"config_languages")
 _expect(errors,LocalizationManager.supported()==["en","de","fr","ko","ja"],"locales")

 for k in ContentCatalog.TOWERS:
  _expect(errors,towers_data.has(k),"tower_json_"+k)
 for u in ContentCatalog.UNITS:
  _expect(errors,u in units_data.get("player",[]),"unit_json_"+u)
 for e in ContentCatalog.ENEMIES:
  if e!="boss":_expect(errors,EnemyCatalog.TYPES.has(e),"enemy_catalog_"+e)
 for b in ContentCatalog.BIOMES:
  _expect(errors,biomes_data.has(b),"biome_json_"+b)

 var last_threat=0
 var last_diff=0.0
 var seen_enemy={}
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
  _expect(errors,DifficultyCurve.enemy_health(s,1)>0.0 and DifficultyCurve.enemy_damage(s,1)>0.0,"stage_%d_difficulty_stats"%s)
  var total=0
  for w in range(1,6):
   var b=StageGenerator.wave_budget(10000,w)
   _expect(errors,b>0,"stage_%d_wave_%d_budget"%[s,w])
   total+=b
   var plan=ThreatDirector.plan(s,w,1000,[],{"infantry":1.0,"armor":0.5,"air":0.2,"tower":0.8})
   _expect(errors,int(plan.get("budget",0))>0,"stage_%d_wave_%d_plan"%[s,w])
   _expect(errors,float(plan.get("air_ratio",-1.0))>=0.0,"stage_%d_wave_%d_air_ratio"%[s,w])
   if s%10==0 and w==5:_expect(errors,plan.get("boss",null)!=null,"stage_%d_wave_5_boss_plan"%s)
   else:_expect(errors,plan.get("boss",null)==null,"stage_%d_wave_%d_unexpected_boss"%[s,w])
  _expect(errors,total>=9900 and total<=10100,"stage_%d_wave_total"%s)
  var pool=EnemyCatalog.stage_pool(s)
  _expect(errors,pool.size()>=2,"stage_%d_enemy_pool"%s)
  for kind in pool:
   _expect(errors,EnemyCatalog.TYPES.has(kind),"stage_%d_enemy_%s"%[s,kind])
   seen_enemy[kind]=true
  if s%10==0:_expect(errors,not BossSystem.profile(s).is_empty(),"boss_%d"%s)

 if campaign is Array:
  for i in range(campaign.size()):
   var row=campaign[i]
   var s=i+1
   var generated=StageGenerator.data(s)
   _expect(errors,int(row.get("stage",0))==s,"campaign_stage_%d"%s)
   _expect(errors,int(row.get("waves",0))==5,"campaign_waves_%d"%s)
   _expect(errors,str(row.get("biome",""))==str(generated.get("biome","")),"campaign_biome_%d"%s)
   _expect(errors,str(row.get("route",""))==str(generated.get("route","")),"campaign_route_%d"%s)
   _expect(errors,bool(row.get("bridge",false))==bool(generated.get("bridge",false)),"campaign_bridge_%d"%s)
   _expect(errors,bool(row.get("boss",false))==(s%10==0),"campaign_boss_%d"%s)
 if events is Array:
  for i in range(events.size()):
   _expect(errors,int(events[i].get("day",0))==i+1,"event_day_%d"%(i+1))
   _expect(errors,int(events[i].get("daily_battles",0))>0,"event_battles_%d"%(i+1))
   _expect(errors,int(events[i].get("reward_gold",0))>0,"event_reward_%d"%(i+1))
 for e in EnemyCatalog.TYPES.keys():_expect(errors,seen_enemy.has(e),"enemy_never_unlocked_"+str(e))

 for k in ContentCatalog.TOWERS:
  var last_damage=0.0
  var last_range=0.0
  for lv in range(1,101):
   var st=ContentCatalog.tower_stats(k,lv)
   _expect(errors,float(st.damage)>0.0 and float(st.range)>0.0 and float(st.cooldown)>0.0,"tower_%s_lv_%d_stats"%[k,lv])
   _expect(errors,float(st.damage)>=last_damage,"tower_%s_lv_%d_damage_regression"%[k,lv])
   _expect(errors,float(st.range)>=last_range,"tower_%s_lv_%d_range_regression"%[k,lv])
   last_damage=float(st.damage)
   last_range=float(st.range)
   var ust=UnitCatalog.scaled(UnitCatalog.TOWERS[k],lv)
   _expect(errors,abs(float(ust.damage)-float(st.damage))<0.01,"tower_catalog_sync_%s_%d"%[k,lv])
  _expect(errors,UnitCatalog.milestone(100)==100,"tower_milestone_"+k)

 for u in ContentCatalog.UNITS:
  var last_hp=0.0
  var last_damage=0.0
  for lv in range(1,101):
   var st=MobileArmy.stats(u,lv)
   _expect(errors,float(st.hp)>0.0 and float(st.damage)>0.0 and float(st.speed)>0.0,"unit_%s_lv_%d"%[u,lv])
   _expect(errors,float(st.hp)>=last_hp and float(st.damage)>=last_damage,"unit_%s_lv_%d_regression"%[u,lv])
   last_hp=float(st.hp)
   last_damage=float(st.damage)
   var ust=UnitCatalog.scaled(UnitCatalog.ARMY[u],lv)
   _expect(errors,abs(float(ust.hp)-float(st.hp))<0.01 and abs(float(ust.damage)-float(st.damage))<0.01,"unit_catalog_sync_%s_%d"%[u,lv])

 for e in EnemyCatalog.TYPES.keys():
  var st=EnemyCatalog.TYPES[e]
  _expect(errors,float(st.get("hp",0))>0.0 and float(st.get("speed",0))>0.0 and float(st.get("damage",0))>=0.0,"enemy_%s"%e)
  var eu=EnemyUnit.new()
  eu.configure(e,5000.0)
  _expect(errors,eu.kind==e and eu.hp>0.0 and eu.speed>0.0,"enemy_node_"+e)
  eu.free()

 for route_name in ["single","double","y","x","ring","spiral","parallel","bridge","central"]:
  var r1=StageGenerator.route(route_name)
  var r2=RouteFactory.points(route_name)
  _expect(errors,r1.size()>=4 and r2.size()>=4,"route_"+route_name)
  var zones=MapRules.build_zones(r1)
  _expect(errors,not zones.is_empty(),"route_zones_"+route_name)
  _expect(errors,zones.has(MapRules.nearest_valid(zones[0],zones)),"route_nearest_"+route_name)

 _expect(errors,not BridgeRules.can_place_fixed({"bridge":true},Vector2(500,1200)),"bridge_build_rule")
 _expect(errors,BridgeRules.can_place_fixed({"bridge":false},Vector2(500,1200)),"normal_build_rule")
 _expect(errors,BridgeRules.mobile_hold_bonus("tank")>1.0,"bridge_tank_bonus")

 var last_tower_cost=0
 var last_unit_cost=0
 for lv in range(1,101):
  var tc=Progression.upgrade_cost(lv,"tower")
  var uc=Progression.upgrade_cost(lv,"unit")
  _expect(errors,tc>=last_tower_cost and uc>=last_unit_cost,"upgrade_cost_%d"%lv)
  last_tower_cost=tc
  last_unit_cost=uc
 for s in range(1,251):
  var reward=Progression.stage_reward(s)
  _expect(errors,int(reward.gold)>0 and int(reward.xp)>0,"stage_reward_%d"%s)
  _expect(errors,int(reward.gems)==(1 if s%5==0 else 0),"stage_gems_%d"%s)
 _expect(errors,Progression.stars(0.9)==3 and Progression.stars(0.6)==2 and Progression.stars(0.2)==1,"stars_logic")

 var base6=BaseEconomy.offline_reward({"factory":1,"ammo":1,"warehouse":1},12.0)
 _expect(errors,float(base6.hours)==6.0 and int(base6.gold)>0,"offline_cap")
 var off=OfflineProduction.calculate(0,999999,{"gold":100.0,"supplies":50.0})
 _expect(errors,int(off.seconds)==OfflineProduction.CAP_SECONDS,"offline_seconds_cap")
 _expect(errors,int(off.gold)==600,"offline_gold_math")

 for f in FacilitySystem.FACILITIES:
  var last_cost=0
  for lv in range(1,101):
   var cost=FacilitySystem.upgrade_cost(f,lv)
   _expect(errors,int(cost.gold)>0 and int(cost.supplies)>0,"facility_%s_%d"%[f,lv])
   _expect(errors,int(cost.gold)>=last_cost,"facility_cost_regression_%s_%d"%[f,lv])
   last_cost=int(cost.gold)
 _expect(errors,FacilitySystem.unit_cap({"factory":100,"hangar":100,"airbase":100},"fighter")==100,"facility_unit_cap")

 for branch in ["defense","ground","air","logistics"]:
  var last_a=0
  var last_b=0
  for lv in range(1,101):
   var a=ResearchModel.cost(branch,lv)
   var b=ResearchTree.cost(branch,lv)
   _expect(errors,int(a.gold)>=last_a and int(b.gold)>=last_b,"research_%s_%d"%[branch,lv])
   last_a=int(a.gold)
   last_b=int(b.gold)
 _expect(errors,ResearchModel.bonus(100)<=0.30,"research_bonus_cap")

 for rarity in ["common","rare","epic","legendary"]:
  var prev=0.0
  for lv in range(1,51):
   var bonus=GeneralSystem.bonus(lv,rarity)
   _expect(errors,bonus>=prev,"general_%s_%d_regression"%[rarity,lv])
   prev=bonus
  _expect(errors,GeneralSystem.xp_needed(50)>GeneralSystem.xp_needed(1),"general_xp_"+rarity)

 for lang in ["en","de","fr","ko","ja"]:_expect(errors,LocalizationManager.normalize(lang)==lang,"locale_"+lang)
 _expect(errors,LocalizationManager.normalize("tr")=="en","locale_fallback")
 var settings=GameSettings.sanitize({"music":5.0,"sfx":-2.0,"language":"ja"})
 _expect(errors,float(settings.music)==1.0 and float(settings.sfx)==0.0 and str(settings.language)=="ja","settings_sanitize")

 _expect(errors,ThemeSystem.THEMES.size()==20,"theme_count")
 for t in ThemeSystem.THEMES:
  var pal=ThemeSystem.palette(t)
  _expect(errors,pal.has("bg") and pal.has("panel") and pal.has("accent"),"theme_"+t)

 _expect(errors,not AdPolicy.can_show_interstitial(true,99),"battle_interstitial_block")
 _expect(errors,AdPolicy.can_show_interstitial(false,2),"menu_interstitial_allow")
 _expect(errors,not AdPolicy.banner_allowed("battle"),"battle_banner_block")
 _expect(errors,AdPolicy.banner_allowed("menu"),"menu_banner_allow")
 _expect(errors,AdPolicy.rewarded_slots().size()==4,"rewarded_slots")

 var migrated=SaveMigration.migrate({"save_version":1})
 _expect(errors,int(migrated.get("save_version",0))==SaveMigration.VERSION and migrated.has("research") and migrated.has("generals") and migrated.has("events"),"save_migration")
 _expect(errors,AchievementSystem.evaluate(250,1000,100).size()==5,"achievement_all")
 _expect(errors,LuckyWheel.spin(1234)==LuckyWheel.spin(1234),"wheel_deterministic")
 _expect(errors,LuckyBox.open_box(50,99)==LuckyBox.open_box(50,99),"box_deterministic")
 _expect(errors,VIPSystem.bonus(999999)<=0.15,"vip_cap")

 var profile=PlayerProfile.defaults()
 _expect(errors,profile.get("themes",[])==["command_navy"] and int(profile.get("level",0))==1,"profile_defaults")
 _expect(errors,PlayerProfile.level_from_xp(999999)<=100,"profile_level_cap")
 var ref1=AccountModel.referral_code("device-test")
 _expect(errors,ref1==AccountModel.referral_code("device-test") and ref1.begins_with("WD") and ref1.length()<=10,"referral_code")
 var link=AccountModel.link_reward()
 _expect(errors,int(link.gems)==25 and int(link.gold)==2500,"link_reward")

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
 _expect(errors,AbilitySystem.COOLDOWNS.size()==3,"ability_cooldowns")

 for dominant in ["air","armor","ground","tower"]:
  var p={dominant:10.0}
  var comp=AdaptiveDirector.composition(120,p,77)
  _expect(errors,comp.size()==20,"adaptive_"+dominant)
 var ai=AdaptiveAI.composition([],{"air":10.0})
 _expect(errors,str(ai.dominant)=="air" and str(ai.counter)=="sam" and abs(float(ai.normal)+float(ai.adaptive)-1.0)<0.001,"adaptive_ai")

 _expect(errors,CombatMath.damage(100.0,50.0)<CombatMath.damage(100.0,0.0),"armor_damage")
 _expect(errors,CombatMath.dps(100.0,2.0)==50.0,"dps_math")
 _expect(errors,Targeting.priority("missile","fighter")>1.0,"targeting_air")
 _expect(errors,Targeting.priority("cannon","heavy_tank")>1.0,"targeting_armor")
 _expect(errors,MobileArmy.matchup("helicopter","tank")>1.0,"matchup_heli_tank")

 var tutorial=TutorialPlan.steps()
 _expect(errors,tutorial.size()==5,"tutorial_steps")
 for i in range(5):_expect(errors,int(tutorial[i].wave)==i+1,"tutorial_wave_%d"%(i+1))
 for lv in [1,10,25,50,75,100]:_expect(errors,not RadarSystem.intel(lv,3).is_empty(),"radar_%d"%lv)

 for streak in range(0,14):
  var dr=DailyReward.reward(streak)
  _expect(errors,int(dr.day)>=1 and int(dr.day)<=7 and int(dr.gold)>0,"daily_%d"%streak)
 var now=int(Time.get_unix_time_from_system())
 _expect(errors,DailyReward.claimable(now-21*3600),"daily_claimable")
 _expect(errors,not DailyReward.claimable(now-3600),"daily_not_claimable")
 var ep=EventSystem.current()
 _expect(errors,ep.has("id") and float(ep.get("mult",0.0))>=1.0,"event_current")
 var mp={}
 MissionSystem.update(mp,"battle",2)
 _expect(errors,int(mp.get("battle",0))==2,"mission_update")
 _expect(errors,MissionSystem.daily_seed()>20200000,"mission_seed")

 _expect(errors,LeaderboardModel.score(2,0,0)>LeaderboardModel.score(1,999,999),"leaderboard_stage_weight")
 var row=LeaderboardModel.local_row({"name":"QA"},12,100,500)
 _expect(errors,str(row.name)=="QA" and int(row.stage)==12,"leaderboard_row")
 _expect(errors,int(RewardSystem.ad_reward(100).gold)>int(RewardSystem.ad_reward(1).gold),"ad_reward_scale")
 _expect(errors,int(RewardSystem.theme_progress(99).unlocks)==0 and int(RewardSystem.theme_progress(100).unlocks)==1,"theme_ad_unlock")
 _expect(errors,RewardSystem.battle_bonus(3,10)>RewardSystem.battle_bonus(1,10),"battle_bonus")

 var tone=AudioFactory.tone(440.0,0.1,0.2)
 _expect(errors,tone!=null and tone.mix_rate==22050 and tone.data.size()>1000,"audio_tone")
 var telemetry:Array=[]
 for i in range(250):LocalTelemetry.event(telemetry,"qa",{"i":i})
 _expect(errors,telemetry.size()==200 and int(telemetry[0].data.i)==50,"telemetry_cap")

 return errors
