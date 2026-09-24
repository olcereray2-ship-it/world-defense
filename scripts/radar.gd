class_name RadarSystem
static func intel(level:int,wave:int)->String:
 if level<10:return "TEHDİT YAKLAŞIYOR"
 if level<25:return "TEHDİT: %s KANAT"%("SAĞ" if wave%2 else "SOL")
 if level<50:return "%d düşman yaklaşıyor"%[6+wave*3]
 if level<75:return "Hava/kara sınıfları tespit edildi"
 return "Rota, sınıf ve özel tehdit tamamen analiz edildi"
