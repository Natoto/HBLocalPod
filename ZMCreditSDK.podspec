Pod::Spec.new do |s|

  s.name         = "ZMCreditSDK"
  s.version      = "0.0.2"
  s.summary      = "ZMCreditSDK desc" 
  s.homepage     = "https://github.com/natoto/HBLocalPod"  
  s.author       = { "nonato" => "787038442@qq.com" } 
  s.platform     = :ios, "7.0"
  s.source       = { :git => "." }
  s.source_files  = "ZMCreditSDK/**/*.{h,m}" 
  s.frameworks =  'UIKit' 
  s.requires_arc = true    
  s.vendored_frameworks = 'ZMCreditSDK/*.framework'
  s.resource = 'ZMCreditSDK/*.bundle'
  s.vendored_libraries = "ZMCreditSDK/*.a"
end