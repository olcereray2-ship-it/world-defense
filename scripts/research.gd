class_name ResearchModel

static func cost(branch:String,level:int)->Dictionary:
 return ResearchTree.cost(branch,level)

static func bonus(level:int)->float:
 return ResearchTree.bonus(level)

static func branches()->Dictionary:
 return ResearchTree.BRANCHES.duplicate(true)
