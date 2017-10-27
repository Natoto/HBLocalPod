
Pod::Spec.new do |s|

  s.name         = "NIAttributedLabel"
  s.version      = "1.0.1"
  s.summary      = "NIAttributedLabel desc"  
  s.homepage     = "https://github.com/natoto/HBLocalPod"  
  s.author       = { "huangbo" => "787038442@qq.com" } 
  s.platform     = :ios, "7.0"
  s.source       = { :git => "." } 
  s.requires_arc = true  
  s.frameworks = 'UIKit' 
  s.source_files = "NIAttributedLabel/*.{h,m}" 
end
