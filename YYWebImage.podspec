
Pod::Spec.new do |s|

  s.name         = "YYWebImage"
  s.version      = "1.0.0"
  s.summary      = "yywebimage"  
  s.homepage     = ""

  s.homepage     = "https://github.com/natoto" 

  s.author       = { "summer-liu" => "787038442@qq.com" }

  s.platform     = :ios, "7.0"
  s.source       = { :git => "." }
  s.source_files  = "YYWebImage/**/*.{h,m}"
  s.requires_arc = true
end
