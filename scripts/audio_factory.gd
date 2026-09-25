class_name AudioFactory

static func tone(freq:float,duration:float,volume:float=0.25)->AudioStreamWAV:
 var rate:=22050
 var safe_duration=maxf(0.01,duration)
 var safe_freq=maxf(20.0,freq)
 var safe_volume=clampf(volume,0.0,1.0)
 var samples=maxi(1,int(float(rate)*safe_duration))
 var bytes=PackedByteArray()
 bytes.resize(samples*2)
 for i in range(samples):
  var env=1.0-float(i)/float(samples)
  var v=int(sin(TAU*safe_freq*float(i)/float(rate))*32767.0*safe_volume*env)
  bytes[i*2]=v&255
  bytes[i*2+1]=(v>>8)&255
 var w=AudioStreamWAV.new()
 w.format=AudioStreamWAV.FORMAT_16_BITS
 w.mix_rate=rate
 w.stereo=false
 w.data=bytes
 return w
