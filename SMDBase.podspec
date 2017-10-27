Pod::Spec.new do |s|

  s.name         = "SMDBase"
  s.version      = "1.0.1"
  s.summary      = "SMDBase desc" 
  s.homepage     = "https://github.com/natoto/HBLocalPod"  
  s.author       = { "nonato" => "787038442@qq.com" } 
  s.platform     = :ios, "7.0"
  s.source       = { :git => "." }
  s.source_files  = "SMDBase/**/*.{h,m,mm}" 
  s.resource = 'SMDBase/**/*.{jpg,png,plist,xib}'
  s.frameworks =  'UIKit' 
  s.requires_arc = true   
  s.dependency   "HBKit"
  s.dependency   "HBKitRefresh"
  s.dependency   "HBKitWatchDog"
  #s.dependency   "hdstatsdk"
  s.dependency   "MJRefresh"
  s.dependency   "NIAttributedLabel"
  s.dependency   "HBExtension" 
end