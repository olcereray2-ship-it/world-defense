class_name GameSettings

const DEFAULTS={"music":0.8,"sfx":0.9,"vibration":true,"language":"en","quality":"auto","fps":60}
const QUALITIES=["auto","low","medium","high"]
const FPS_OPTIONS=[30,60,90,120]

static func sanitize(v:Dictionary)->Dictionary:
 var d=DEFAULTS.duplicate(true)
 for k in d.keys():
  if v.has(k):d[k]=v[k]
 d["music"]=clampf(float(d.get("music",0.8)),0.0,1.0)
 d["sfx"]=clampf(float(d.get("sfx",0.9)),0.0,1.0)
 d["vibration"]=bool(d.get("vibration",true))
 d["language"]=LocalizationManager.normalize(str(d.get("language","en")))
 var q=str(d.get("quality","auto")).to_lower()
 d["quality"]=q if q in QUALITIES else "auto"
 var fps=int(d.get("fps",60))
 d["fps"]=fps if fps in FPS_OPTIONS else 60
 return d
