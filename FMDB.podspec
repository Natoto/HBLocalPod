Pod::Spec.new do |s|

  s.name         = "FMDB"
  s.version      = "2.6.2"
  s.summary      = "FMDB desc"

  s.homepage     = "https://github.com/natoto/HBLocalPod"  

  s.author       = { "summer-liu" => "787038442@qq.com" }

  s.platform     = :ios, "7.0"
  s.source       = { :git => "." }
  s.source_files  = "FMDB/**/*.{h,m}" 
  s.frameworks =  'UIKit' 
  s.requires_arc = true    

end