Pod::Spec.new do |s|
    s.name         = 'XCDYouTubeKit'
    s.version      = '1.0.1'
    s.summary      = 'A good player made by renzifeng'
    s.homepage     = 'https://github.com/renzifeng/XCDYouTubeKit'
    s.license      = 'MIT'
    s.authors      = { 'renzifeng' => 'zifeng1300@gmail.com' }
    #s.platform     = :ios, '7.0'
    s.ios.deployment_target = '7.0'
    s.source       = { :git => 'https://github.com/renzifeng/XCDYouTubeKit.git', :tag => s.version.to_s }
    s.source_files = 'XCDYouTubeKit/**/*.{h,m}'
    s.resource     = 'XCDYouTubeKit/*.plist'
    s.framework    = 'UIKit','MediaPlayer' 
    s.requires_arc = true
end
