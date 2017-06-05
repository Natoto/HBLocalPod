Pod::Spec.new do |s|

  s.name         = "XYRuntime"
  s.version      = "0.0.2"
  s.summary      = "XYRuntime desc" 
  s.homepage     = "https://github.com/natoto/HBLocalPod"  
  s.author       = { "nonato" => "787038442@qq.com" } 
  s.platform     = :ios, "7.0"
  s.source       = { :git => "." }
  s.source_files  = "XYRuntime/*.{h,m}" 
  s.frameworks =  'Foundation' 
  s.requires_arc = true    

end