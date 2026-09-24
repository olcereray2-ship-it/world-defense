class_name UnitCatalog
const TOWERS={
"machine_gun":{"damage":18.0,"range":260.0,"rate":5.55,"role":"infantry"},
"cannon":{"damage":55.0,"range":310.0,"rate":1.33,"role":"armor"},
"missile":{"damage":78.0,"range":390.0,"rate":0.95,"role":"air"},
"laser":{"damage":34.0,"range":300.0,"rate":3.57,"role":"support"},
"tesla":{"damage":42.0,"range":270.0,"rate":1.82,"role":"crowd"}}
const ARMY={
"infantry":{"hp":120.0,"damage":18.0,"speed":105.0},
"tank":{"hp":520.0,"damage":62.0,"speed":62.0},
"artillery":{"hp":230.0,"damage":95.0,"speed":48.0},
"helicopter":{"hp":260.0,"damage":74.0,"speed":120.0},
"fighter":{"hp":210.0,"damage":110.0,"speed":180.0}}
static func scaled(base:Dictionary,level:int)->Dictionary:
 var x=base.duplicate(true)
 var m=1.0+(0.065 if x.has("range") else 0.06)*float(level-1)
 for k in ["hp","damage","range"]:
  if x.has(k):x[k]=float(x[k])*m
 return x
static func milestone(level:int)->int:
 for x in [100,75,50,25,10]:
  if level>=x:return x
 return 1
