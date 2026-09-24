class_name AudioFactory
static func tone(freq:float,duration:float,volume:float=0.25)->AudioStreamWAV:
 var rate=22050;var samples=int(rate*duration);var bytes=PackedByteArray();bytes.resize(samples*2)
 for i in samples:
  var env=1.0-float(i)/samples
  var v=int(sin(TAU*freq*i/rate)*32767.0*volume*env)
  bytes[i*2]=v&255;bytes[i*2+1]=(v>>8)&255
 var w=AudioStreamWAV.new();w.format=AudioStreamWAV.FORMAT_16_BITS;w.mix_rate=rate;w.stereo=false;w.data=bytes
 return w
