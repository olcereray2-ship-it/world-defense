class_name LocalizationManager

const LANGUAGES=["en","de","fr","ko","ja"]
const PATH="res://data/localization.csv"
static var _table:Dictionary={}

static func supported()->Array:
 return LANGUAGES.duplicate()

static func normalize(code:String)->String:
 var c=code.to_lower().replace("-","_").split("_")[0]
 return c if c in LANGUAGES else "en"

static func apply(code:String):
 TranslationServer.set_locale(normalize(code))

static func _ensure_loaded():
 if not _table.is_empty():return
 var raw=FileAccess.get_file_as_string(PATH)
 if raw.is_empty():return
 var lines=raw.split("\n",false)
 if lines.is_empty():return
 var header=lines[0].get_csv_line()
 if header.size()<2:return
 for i in range(1,lines.size()):
  var cols=lines[i].get_csv_line()
  if cols.is_empty():continue
  var key=str(cols[0]).strip_edges()
  if key.is_empty():continue
  var row:Dictionary={}
  for j in range(1,mini(header.size(),cols.size())):
   row[normalize(str(header[j]))]=str(cols[j])
  _table[key]=row

static func text(key:String,code:String="")->String:
 _ensure_loaded()
 var lang=normalize(code if not code.is_empty() else TranslationServer.get_locale())
 var row=_table.get(key,{})
 if row is Dictionary:
  if row.has(lang):return str(row[lang])
  if row.has("en"):return str(row["en"])
 return key
