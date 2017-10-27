Pod::Spec.new do |s|

  s.name         = "ShareModel"
  s.version      = "1.0.1"
  s.summary      = "ManageLocalCode desc" 
  s.homepage     = "https://github.com/natoto/HBLocalPod"  
  s.author       = { "summer-liu" => "787038442@qq.com" } 
  s.platform     = :ios, "7.0"
  s.source       = { :git => "." }
  s.source_files  = "ShareModel/XMShareView/**/*.{h,m}" 
  s.resource = 'ShareModel/XMShareView/**/*.{png,jpg}'
  s.frameworks =  'UIKit' 
  s.requires_arc = true 
  s.default_subspecs    = 'Vendor'

  # 核心模块 
  s.subspec 'Vendor' do |sp|
   
		# Tencent
	 	sp.subspec 'Tencent' do |ssp|
		    ssp.vendored_frameworks = 'ShareModel/Vendor/Tencent/TencentOpenAPI.framework'
		    ssp.resource = 'ShareModel/Vendor/Tencent/TencentOpenApi_IOS_Bundle.bundle'
		    ssp.libraries = 'sqlite3'
		end

		 # SinaWeiboSDK
        sp.subspec 'SinaWeiboSDK' do |ssp|
            ssp.vendored_libraries = "ShareModel/Vendor/libWeiboSDK/*.a"
            ssp.resource = 'ShareModel/Vendor/libWeiboSDK/WeiboSDK.bundle'
            ssp.frameworks = 'ImageIO', 'AdSupport'
            ssp.libraries = 'sqlite3'
            ssp.source_files = "ShareModel/Vendor/libWeiboSDK/*.{h,m}"
            ssp.public_header_files = "ShareModel/Vendor/libWeiboSDK/*.h"
        end

         # WeChatSDK
        sp.subspec 'Weixin' do |ssp|
            ssp.vendored_libraries = "ShareModel/Vendor/Weixin/*.a"
            ssp.source_files = "ShareModel/Vendor/Weixin/*.{h,m}"
            ssp.public_header_files = "ShareModel/Vendor/Weixin/*.h"
            ssp.libraries = 'sqlite3'
        end
   end
end