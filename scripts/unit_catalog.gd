class_name UnitCatalog
const TOWERS={
"machine_gun":{"damage":24.0,"range":310.0,"rate":4.5,"role":"infantry"},
"cannon":{"damage":92.0,"range":350.0,"rate":1.2,"role":"armor"},
"missile":{"damage":76.0,"range":430.0,"rate":1.6,"role":"air"},
"laser":{"damage":48.0,"range":360.0,"rate":3.0,"role":"support"},
"tesla":{"damage":58.0,"range":290.0,"rate":2.1,"role":"crowd"}}
const ARMY={
"infantry":{"hp":180,"damage":18,"speed":105},
"tank":{"hp":850,"damage":72,"speed":62},
"artillery":{"hp":360,"damage":125,"speed":45},
"helicopter":{"hp":430,"damage":58,"speed":145},
"fighter":{"hp":330,"damage":105,"speed":230}}
static func scaled(base:Dictionary,level:int)->Dictionary:
 var x=base.duplicate(true);var m=1.0+0.055*float(level-1)
 for k in ["hp","damage","range"]:
  if x.has(k):x[k]=float(x[k])*m
 return x
static func milestone(level:int)->int:
 for x in [100,75,50,25,10]:
  if level>=x:return x
 return 1
