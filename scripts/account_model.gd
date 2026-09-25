class_name AccountModel

static func referral_code(device_seed:String)->String:
 var value=int(device_seed.hash())&0x7fffffff
 return ("WD"+str(value)).substr(0,10).to_upper()

static func link_reward()->Dictionary:
 return {"gems":25,"gold":2500}
