class_name EnemyCatalog

const TYPES={
 "assault":{"hp":90,"speed":95,"armor":4,"damage":14,"class":"infantry"},
 "heavy":{"hp":180,"speed":62,"armor":12,"damage":22,"class":"infantry"},
 "fast_armor":{"hp":320,"speed":115,"armor":28,"damage":30,"class":"armor"},
 "heavy_tank":{"hp":900,"speed":48,"armor":55,"damage":65,"class":"armor"},
 "anti_tank":{"hp":380,"speed":68,"armor":22,"damage":72,"class":"armor"},
 "aa_vehicle":{"hp":420,"speed":66,"armor":30,"damage":48,"class":"aa"},
 "sam":{"hp":390,"speed":55,"armor":26,"damage":62,"class":"aa"},
 "helicopter":{"hp":350,"speed":130,"armor":10,"damage":44,"class":"air"},
 "fighter":{"hp":300,"speed":205,"armor":8,"damage":58,"class":"air"},
 "bomber":{"hp":650,"speed":120,"armor":18,"damage":95,"class":"air"},
 "artillery":{"hp":300,"speed":45,"armor":10,"damage":85,"class":"support"},
 "ew":{"hp":250,"speed":70,"armor":8,"damage":10,"class":"support"},
 "support":{"hp":280,"speed":65,"armor":12,"damage":8,"class":"support"}
}

static func stage_pool(stage:int)->Array:
 var s=clampi(stage,1,250)
 var p=["assault","heavy"]
 if s>=8:p+=["fast_armor"]
 if s>=18:p+=["heavy_tank","anti_tank"]
 if s>=30:p+=["aa_vehicle","helicopter"]
 if s>=45:p+=["sam","artillery"]
 if s>=70:p+=["fighter","support"]
 if s>=95:p+=["bomber","ew"]
 return p
