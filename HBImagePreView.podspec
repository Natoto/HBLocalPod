Pod::Spec.new do |s|

  s.name         = "HBImagePreView"
  s.version      = "0.0.1"
  s.summary      = "HBImagePreView desc" 
  s.homepage     = "https://github.com/natoto/HBLocalPod"   
  s.author       = { "nonato" => "787038442@qq.com" }

  s.platform     = :ios, "7.0"
  s.source       = { :git => "." }
  s.source_files  = "HBImagePreView/*.{h,m}" 
  s.frameworks =  'UIKit','MediaPlayer' 
  s.requires_arc = true   
  s.dependency  "YYWebImage"

end