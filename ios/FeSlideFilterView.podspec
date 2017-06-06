Pod::Spec.new do |s|

  s.name         = "FeSlideFilterView"
  s.version      = "0.0.2"
  s.summary      = "FeSlideFilterView desc" 
  s.homepage     = "https://github.com/natoto/HBLocalPod"  
  s.author       = { "nonato" => "787038442@qq.com" } 
  s.platform     = :ios, "7.0"
  s.source       = { :git => "." }
  s.source_files  = "FeSlideFilterView/*.{h,m}" 
  s.frameworks =  'Foundation' 
  s.requires_arc = true    
  s.resource = 'FeSlideFilterView/**/*.{png,jpg}'
  
end