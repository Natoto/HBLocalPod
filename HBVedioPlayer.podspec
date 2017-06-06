Pod::Spec.new do |s|
    s.name         = 'HBVedioPlayer'
    s.version      = '0.1.1'
    s.summary      = 'A good player made by renzifeng'
    s.homepage     = "https://github.com/natoto/HBLocalPod"  
    s.license      = 'MIT'
    s.authors      = { 'renzifeng' => 'zifeng1300@gmail.com' }
    #s.platform     = :ios, '7.0'
    s.ios.deployment_target = '7.0'
    s.source       = { :git => 'https://github.com/natoto/HBLocalPod' }
    s.source_files = 'HBVedioPlayer/**/*.{h,m}'
    s.resource     = 'HBVedioPlayer/ZFPlayer.bundle'
    s.framework    = 'UIKit','MediaPlayer'
    s.dependency 'Masonry'
    s.requires_arc = true
end
