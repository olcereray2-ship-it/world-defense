extends Node
func _ready():
 var e=QAChecks.run()
 if e.is_empty():
  print("WORLD_DEFENSE_QA_OK")
  get_tree().quit(0)
 else:
  for x in e:push_error(str(x))
  get_tree().quit(1)
