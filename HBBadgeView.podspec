Pod::Spec.new do |s|
  s.name             = "HBBadgeView"
  s.version          = '1.4.1'
  s.summary          = "Customizable UIKit badge view like the one on applications in the iOS springboard."
  s.description      = "Customizable UIKit badge view like the one on applications in the iOS springboard. Very optimized for performance: drawn entirely using CoreGraphics."
  s.homepage     = "https://github.com/natoto/HBLocalPod"  
  s.license          = 'MIT'
  s.author           = { 'Javier Soto' => 'ios@javisoto.es' }
  s.source           = { :git => 'https://github.com/JaviSoto/JSBadgeView.git', :tag => s.version.to_s }

  s.platform     = :ios
  s.requires_arc = true

  s.source_files = 'HBBadgeView/Classes/**/*'
  s.resource_bundles = {
    'HBBadgeView' => ['HBBadgeView/Assets/*.png']
  }

  s.frameworks = 'QuartzCore'
end
