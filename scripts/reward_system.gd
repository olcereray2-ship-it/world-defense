class_name RewardSystem
static func ad_reward(stage:int)->Dictionary:
 return {"gold":600+stage*45,"gems":2}
static func theme_progress(ad_views:int)->Dictionary:
 return {"views":ad_views,"next_at":100,"unlocks":ad_views/100}
static func battle_bonus(stars:int,stage:int)->int:
 return int((350+stage*30)*(1.0+stars*0.15))
