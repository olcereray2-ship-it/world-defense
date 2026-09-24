class_name AdPolicy
static func can_show_interstitial(in_battle:bool,battles_since:int)->bool:return not in_battle and battles_since>=2
static func banner_allowed(screen:String)->bool:return screen in ["menu","leaderboard","missions","themes","shop"]
static func rewarded_slots()->Array:return ["double_offline","bonus_gold","lucky_box","extra_event_reward"]
