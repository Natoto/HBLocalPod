Pod::Spec.new do |s|

  s.name         = "JSPatch"
  s.version      = "0.0.1"
  s.summary      = "JSPatch desc" 
  s.homepage     = "https://github.com/natoto"  
  s.author       = { "summer-liu" => "787038442@qq.com" } 
  s.platform     = :ios, "7.0"
  s.source       = { :git => "." }
  s.source_files  = "JSPatch/**/*.{h,m,c,S}"
  s.resource = 'JSPatch/**/*.{js,php}'
  s.requires_arc = true
  s.frameworks = 'UIKit','JavaScriptCore' 
end