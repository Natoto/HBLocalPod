Pod::Spec.new do |s|

  s.name         = "AlipaySDK"
  s.version      = "0.0.2"
  s.summary      = "AlipaySDK desc"

  s.homepage     = "https://github.com/natoto/HBLocalPod" 

  s.author       = { "nonato" => "787038442@qq.com" }

  s.platform     = :ios, "7.0"
  s.source       = { :git => "." } 
  s.requires_arc = true 
  s.vendored_frameworks = 'AlipaySDK/AlipaySDK.framework'
  s.resource = 'AlipaySDK/AlipaySDK.bundle'
  s.libraries = 'sqlite3'

end