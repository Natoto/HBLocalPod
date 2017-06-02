Pod::Spec.new do |s|

  s.name         = "SMDNetWork"
  s.version      = "0.0.1"
  s.summary      = "SMDNetWork desc" 
  s.homepage     = "https://github.com/natoto"  
  s.author       = { "nonato" => "787038442@qq.com" } 
  s.platform     = :ios, "7.0"
  s.source       = { :git => "." }
  s.source_files  = "SMDNetWork/**/*.{h,m}" 
  s.frameworks =  'UIKit' 
  s.requires_arc = true   
  s.dependency  "AFNetworking"

end