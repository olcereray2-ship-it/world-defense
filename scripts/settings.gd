class_name GameSettings
const DEFAULTS={"music":0.8,"sfx":0.9,"vibration":true,"language":"en","quality":"auto","fps":60}
static func sanitize(v:Dictionary)->Dictionary:
 var d=DEFAULTS.duplicate(true)
 for k in d.keys():
  if v.has(k):d[k]=v[k]
 d.music=clamp(float(d.music),0.0,1.0);d.sfx=clamp(float(d.sfx),0.0,1.0)
 return d
