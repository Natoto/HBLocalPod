
Pod::Spec.new do |s|

  s.name         = "NSObject_ObjectMap"
  s.version      = "1.0.1"
  s.summary      = "NSObject_ObjectMap desc"  
  s.homepage     = "https://github.com/natoto/HBLocalPod"  
  s.author       = { "huangbo" => "787038442@qq.com" } 
  s.platform     = :ios, "7.0"
  s.source       = { :git => "." } 
  s.requires_arc = true  
  s.frameworks = 'UIKit' ,'Foundation'
  s.source_files = "NSObject_ObjectMap/*.{h,m}" 
end
