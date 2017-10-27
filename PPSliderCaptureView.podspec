Pod::Spec.new do |s|
s.name         = "PPSliderCaptureView"
s.version      = "1.0.1"
s.summary      = "PPSliderCaptureView desc" 
s.homepage     = "https://github.com/natoto/HBLocalPod"  
s.author       = { "nonato" => "787038442@qq.com" } 
s.platform     = :ios,'7.0'
s.source       = { :git => "https://github.com/natoto/HBLocalPod" }
s.source_files = "PPSliderCaptureView/**/*.{h,m}" 
s.frameworks = 'Foundation' 
s.requires_arc = true    
s.resource = 'PPSliderCaptureView/**/*.{png,jpg,bundle}'
s.dependency 'GPUImage'
end