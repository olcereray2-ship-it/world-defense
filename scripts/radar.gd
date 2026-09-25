class_name RadarSystem

static func intel(level:int,wave:int)->String:
 var lv=clampi(level,1,100)
 if lv<10:return LocalizationManager.text("intel_approaching")
 if lv<25:
  var side=LocalizationManager.text("right") if wave%2!=0 else LocalizationManager.text("left")
  return LocalizationManager.text("intel_flank")%side
 if lv<50:return LocalizationManager.text("intel_count")%(6+maxi(0,wave)*3)
 if lv<75:return LocalizationManager.text("intel_classes")
 return LocalizationManager.text("intel_full")
