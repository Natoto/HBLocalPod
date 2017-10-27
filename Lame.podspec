
Pod::Spec.new do |s|

  s.name         = "Lame"
  s.version      = "1.0.1"
  s.summary      = "Lame caf 转MP3"  
  s.homepage     = "https://github.com/natoto/HBLocalPod"  
  s.author       = { "huangbo" => "787038442@qq.com" } 
  s.platform     = :ios, "7.0"
  s.source       = { :git => "." } 
  s.requires_arc = true 
  s.vendored_libraries = "Lame/libmp3lame.a" 
  s.frameworks = 'AVFoundation' 
  s.source_files = "Lame/*.{h,m}"
  s.public_header_files = "Lame/*.h"
end
