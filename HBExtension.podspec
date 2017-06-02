Pod::Spec.new do |s|

  s.name         = "HBExtension"
  s.version      = "0.0.5"
  s.summary      = "HBExtension desc" 
  s.homepage     = "https://github.com/natoto"  
  s.author       = { "summer-liu" => "787038442@qq.com" } 
  s.platform     = :ios, "7.0"
  s.source       = { :git => "." }
  s.source_files  = "HBExtension/**/*.{h,m,mm}" 
  s.resource = 'HBExtension/**/*.{jpg,png,plist,xib}'
  s.frameworks =  'UIKit' 
  s.requires_arc = true   
  s.dependency   "HBKit"
  s.dependency   "YYWebImage"
  #s.dependency   "hdstatsdk"
  s.dependency   "MJRefresh" 
  s.dependency   "NIAttributedLabel"
  s.dependency   "FDFullscreenPopGesture"
end