Pod::Spec.new do |s|

  s.name         = "HBDataBase"
  s.version      = "1.0.6"
  s.summary      = "对FMDB的轻量级封装，帮助快速创建管理移动端数据库."
  s.homepage     = "https://github.com/natoto/HBDatabase"
  s.license      = "MIT"
  s.author             = { "HUANGBO" => "nonato@foxmail.com" }
  s.platform     = :ios
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/natoto/HBDatabase.git",:branch => "master", :tag => "1.0.6" }
  s.requires_arc = true
  s.source_files  = "HBDatabase/*.{h,m}"
  s.public_header_files = "HBDatabase/*.h"
  s.framework  = "UIKit","Foundation"
  s.dependency 'FMDB'

end
