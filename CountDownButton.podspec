Pod::Spec.new do |s|

  s.name         = "CountDownButton"
  s.version      = "0.0.2"
  s.summary      = "CountDownButton desc"

  s.homepage     = "https://github.com/natoto" 

  s.author       = { "summer-liu" => "787038442@qq.com" }

  s.platform     = :ios, "7.0"
  s.source       = { :git => "." }
  s.source_files  = "CountDownButton/*.{h,m}" 
  s.frameworks =  'UIKit' 
  s.requires_arc = true    

end