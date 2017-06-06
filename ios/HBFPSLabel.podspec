Pod::Spec.new do |s|

  s.name         = "HBFPSLabel"
  s.version      = "0.0.1"
  s.summary      = "HBFPSLabel desc" 
  s.homepage     = "https://github.com/natoto/HBLocalPod"  
  s.author       = { "nonato" => "787038442@qq.com" } 
  s.platform     = :ios, "7.0"
  s.source       = { :git => "." }
  s.source_files  = "HBFPSLabel/*.{h,m}" 
  s.frameworks =  'UIKit'
  s.requires_arc = true    

end