Pod::Spec.new do |s|

  s.name         = "TTTAttributedLabel"
  s.version      = "0.0.2"
  s.summary      = "TTTAttributedLabel desc" 
  s.homepage     = "https://github.com/natoto"  
  s.author       = { "nonato" => "787038442@qq.com" } 
  s.platform     = :ios, "7.0"
  s.source       = { :git => "." }
  s.source_files  = "TTTAttributedLabel/*.{h,m}" 
  s.frameworks =  'UIKit' 
  s.requires_arc = true    

end