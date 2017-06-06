Pod::Spec.new do |s|

  s.name         = "SMDAlertView"
  s.version      = "0.0.2"
  s.summary      = "SMDAlertView desc"
  s.homepage     = "https://github.com/natoto/HBLocalPod"  

  s.author       = { "summer-liu" => "787038442@qq.com" }

  s.platform     = :ios, "7.0"
  s.source       = { :git => "." }
  s.source_files  = "SMDAlertView/*.{h,m}" 
  s.frameworks =  'UIKit' 
  s.requires_arc = true   
  s.dependency  "Masonry"

end