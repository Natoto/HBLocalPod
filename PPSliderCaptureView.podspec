Pod::Spec.new do |s|
s.name         = "PPSliderCaptureView"
s.version      = "0.0.3"
s.summary      = "PPSliderCaptureView desc" 
s.homepage     = "https://github.com/natoto"  
s.author       = { "nonato" => "787038442@qq.com" } 
s.platform     = :ios,'7.0'
s.source       = { :podspec => "https://github.com/Natoto/HBLocalPod/blob/master/PPSliderCaptureView.podspec" }
s.source_files = "PPSliderCaptureView/**/*.{h,m}" 
s.frameworks = 'Foundation' 
s.requires_arc = true    
s.resource = 'PPSliderCaptureView/**/*.{png,jpg,bundle}'
s.dependency 'GPUImage'
end