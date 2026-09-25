class_name RewardSystem

static func ad_reward(stage:int)->Dictionary:
 var s=clampi(stage,1,250)
 return {"gold":600+s*45,"gems":2}

static func theme_progress(ad_views:int)->Dictionary:
 var views=maxi(0,ad_views)
 return {"views":views,"next_at":100,"unlocks":int(views/100)}

static func battle_bonus(stars:int,stage:int)->int:
 var s=clampi(stage,1,250)
 var rating=clampi(stars,1,3)
 return int(float(350+s*30)*(1.0+float(rating)*0.15))
