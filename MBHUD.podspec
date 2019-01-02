Pod::Spec.new do |s|

  s.name         = "MBHUD"
  s.version      = "1.0.1"
  s.summary      = "HUD" 
  s.homepage     = "https://github.com/natoto/HBLocalPod"
  s.license      = 'Apache License, Version 2.0'
  s.author             = { "Simon CORSIN" => "nonato@foxmail.com" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/natoto/HBLocalPod.git", :tag => "1.0.1" }
  s.source_files  = 'MBHUD/*.{h,m}'
  s.public_header_files = 'MBHUD/*.h'
  s.requires_arc = true  
  s.dependency   "MBProgressHUD"

end
