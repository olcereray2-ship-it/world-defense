class_name LocalizationManager
static func supported()->Array:return ["en","de","fr","ko","ja"]
static func normalize(code:String)->String:
 var c=code.to_lower().substr(0,2);return c if c in supported() else "en"
static func apply(code:String):TranslationServer.set_locale(normalize(code))
