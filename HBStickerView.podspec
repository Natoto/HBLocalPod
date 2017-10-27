Pod::Spec.new do |s|

  s.name         = "HBStickerView"
  s.version      = "1.0.1"
  s.summary      = "HBStickerView desc"

  s.homepage     = "https://github.com/natoto/HBLocalPod" 

  s.author       = { "nonato" => "787038442@qq.com" }

  s.platform     = :ios, "7.0"
  s.source       = { :git => "." } 
  s.requires_arc = true  
  s.source_files = "HBStickerView/*.{h,m}" 
  s.resource = 'HBStickerView/StickerView.bundle'
 
end