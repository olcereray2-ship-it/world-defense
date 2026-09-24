class_name EventSystem
static func current()->Dictionary:
 var d=Time.get_date_dict_from_system();var idx=(int(d.day)+int(d.month)*3)%5
 var events=[
  {"id":"armor_hunt","bonus":"anti_tank","mult":1.15},
  {"id":"air_alert","bonus":"aa","mult":1.15},
  {"id":"supply_rush","bonus":"gold","mult":1.20},
  {"id":"siege_week","bonus":"artillery","mult":1.15},
  {"id":"commander_trial","bonus":"xp","mult":1.20}]
 return events[idx]
