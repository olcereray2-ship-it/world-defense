class_name AccountModel
static func referral_code(device_seed:String)->String:return ("WD"+str(abs(device_seed.hash()))).substr(0,10).to_upper()
static func link_reward()->Dictionary:return {"gems":25,"gold":2500}
