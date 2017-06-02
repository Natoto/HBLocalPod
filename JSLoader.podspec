Pod::Spec.new do |s|

  s.name         = "JSLoader"
  s.version      = "0.0.1"
  s.summary      = "JSLoader desc" 
  s.homepage     = "https://github.com/natoto"  
  s.author       = { "nonato" => "787038442@qq.com" } 
  s.platform     = :ios, "7.0"
  s.source       = { :git => "." }
  s.source_files  = "JSLoader/**/*.{h,m,c,S}"
  s.resource = 'JSLoader/**/*.{js,php}'
  s.requires_arc = true
  s.frameworks = 'UIKit','JavaScriptCore' 
  s.dependency  "JSPatch"
end