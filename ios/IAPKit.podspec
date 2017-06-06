Pod::Spec.new do |s|

  s.name         = "IAPKit"
  s.version      = "0.0.1"
  s.summary      = "ManageLocalCode desc"
  s.homepage     = "https://github.com/natoto/HBLocalPod"  

  s.author       = { "summer-liu" => "787038442@qq.com" }

  s.platform     = :ios, "7.0"
  s.source       = { :git => "." }
  s.source_files  = "IAPKit/*.{h,m}"
  s.requires_arc = true

end