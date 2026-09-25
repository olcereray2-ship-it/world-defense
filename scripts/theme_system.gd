class_name ThemeSystem

const THEMES=["command_navy","desert_ops","arctic","urban_night","jungle","steel","crimson","neon","sandstorm","ocean","obsidian","gold","plasma","titanium","aurora","ember","storm","ghost","royal","veteran"]

static func palette(id:String)->Dictionary:
 var theme_id=id if id in THEMES else "command_navy"
 var seed=int(theme_id.hash())&0x7fffffff
 return {
  "bg":Color.from_hsv(float(seed%360)/360.0,0.34,0.24),
  "panel":Color.from_hsv(float((seed+24)%360)/360.0,0.42,0.34),
  "accent":Color.from_hsv(float((seed+170)%360)/360.0,0.65,0.92)
 }
