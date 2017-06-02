Pod::Spec.new do |s|

  s.name         = "JSONKit"
  s.version      = "0.0.1"
  s.summary      = "JSONKit desc" 
  s.homepage     = "https://github.com/natoto"  
  s.author       = { "nonato" => "787038442@qq.com" } 
  s.platform     = :ios, "7.0"
  s.source       = { :git => "." }
  s.source_files  = "JSONKit/*.{h,m}" 
  s.requires_arc = false
  s.frameworks = 'UIKit'  
end