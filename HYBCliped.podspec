Pod::Spec.new do |s|

  s.name         = "HYBCliped"
  s.version      = "1.0.1"
  s.summary      = "HYBCliped desc" 
  s.homepage     = "https://github.com/natoto/HBLocalPod"  
  s.author       = { "summer-liu" => "787038442@qq.com" } 
  s.platform     = :ios, "7.0"
  s.source       = { :git => "." }
  s.source_files  = "HYBCliped/**/*.{h,m,mm}" 
  s.resource = 'HYBCliped/**/*.{jpg,png,plist,xib}'
  s.frameworks =  'UIKit' 
  s.requires_arc = true    
end