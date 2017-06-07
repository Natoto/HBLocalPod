//
//  PPCameraFilters.h
//  GPUImageDemo
//
//  Created by xx11dragon on 15/9/22.
//  Copyright © 2015年 xx11dragon. All rights reserved.
//

@class GPUImageFilterGroup;
@interface PPCameraFilters : NSObject

//时光、白露、少女、布拉格、黑白 
+(GPUImageFilterGroup *)heibai;
+(GPUImageFilterGroup *)bulage;
+(GPUImageFilterGroup *)shaolv;
+(GPUImageFilterGroup *)bailu;
+(GPUImageFilterGroup *)shiguang;
/**
 * 夜色
 */
+(GPUImageFilterGroup *)yese;
/**
 * 美食
 */
+(GPUImageFilterGroup *)meishi;
//    正常
+ (GPUImageFilterGroup *)normal;

+ (GPUImageFilterGroup *)saturation;

+ (GPUImageFilterGroup *)exposure;

+ (GPUImageFilterGroup *)contrast;

+ (GPUImageFilterGroup *)testGroup1;

+ (GPUImageFilterGroup *)sketch;

@end
