//
//  PPCameraFilters.m
//  GPUImageDemo
//
//  Created by xx11dragon on 15/9/22.
//  Copyright © 2015年 xx11dragon. All rights reserved.
//

#import <GPUImage/GPUImage.h>
#import "PPCameraFilters.h"
#import "PPFliterGroup.h"
#import "InstaFilters.h"

@implementation PPCameraFilters


+(GPUImageFilterGroup *)heibai
{
    IFInkwellFilter * filter = [[IFInkwellFilter alloc] init];
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"黑白";
    group.color = [UIColor blackColor];
    return group;
}

+(GPUImageFilterGroup *)bulage
{
    IFLordKelvinFilter * filter = [[IFLordKelvinFilter alloc] init];
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"布拉格";
    group.color = [UIColor blackColor];
    return group;
}
+(GPUImageFilterGroup *)shaolv{

    IFEarlybirdFilter *filter =  [[IFEarlybirdFilter alloc] init];;
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"少女";
    group.color = [UIColor blackColor];
    return group;
}


+(GPUImageFilterGroup *)bailu{
    IFHefeFilter *filter = [[IFHefeFilter alloc] init];
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"白露";
    group.color = [UIColor blackColor];
    return group;
}

+(GPUImageFilterGroup *)shiguang{
    
    IFAmaroFilter *filter  =  [[IFAmaroFilter alloc] init];
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"时光";
    group.color = [UIColor blackColor];
    return group;
}

+(GPUImageFilterGroup *)yese{

    IFRiseFilter*filter  =  [[IFRiseFilter alloc] init];
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"夜色";
    group.color = [UIColor blackColor];
    return group;
    
}

+(GPUImageFilterGroup *)meishi{

    IFHefeFilter * filter  =  [[IFHefeFilter alloc] init];
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"美食";
    group.color = [UIColor blackColor];
    return group;
}

+ (GPUImageFilterGroup *)normal {
    GPUImageFilter *filter = [[GPUImageFilter alloc] init]; //默认
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"正常";
    group.color = [UIColor blackColor];
    return group;
    
}

+ (GPUImageFilterGroup *)saturation {
    GPUImageSaturationFilter *filter = [[GPUImageSaturationFilter alloc] init]; //饱和度
    filter.saturation = 2.0f;
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"饱和度";
    group.color = [UIColor blueColor];
    return group;
}


+ (GPUImageFilterGroup *)exposure {
    GPUImageExposureFilter *filter = [[GPUImageExposureFilter alloc] init]; //曝光
    filter.exposure = 1.0f;
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"曝光";
    group.color = [UIColor greenColor];
    return group;
}



+ (GPUImageFilterGroup *)contrast {
    GPUImageContrastFilter *filter = [[GPUImageContrastFilter alloc] init]; //对比度
    filter.contrast = 2.0f;
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"对比度";
    group.color = [UIColor redColor];
    return group;
}


+ (GPUImageFilterGroup *)sketch {
    GPUImageSketchFilter *filter = [[GPUImageSketchFilter alloc] init]; //对比度
 
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"素描";
    group.color = [UIColor redColor];
    return group;
}


+ (GPUImageFilterGroup *)testGroup1 {
    GPUImageFilterGroup *filters = [[GPUImageFilterGroup alloc] init];
    
    GPUImageExposureFilter *filter1 = [[GPUImageExposureFilter alloc] init]; //曝光
    filter1.exposure = 0.0f;
    GPUImageSaturationFilter *filter2 = [[GPUImageSaturationFilter alloc] init]; //饱和度
    filter2.saturation = 2.0f;
    GPUImageContrastFilter *filter3 = [[GPUImageContrastFilter alloc] init]; //对比度
    filter3.contrast = 2.0f;
    
    [filter1 addTarget:filter2];
    [filter2 addTarget:filter3];
    
    [(GPUImageFilterGroup *) filters setInitialFilters:[NSArray arrayWithObject: filter1]];
    [(GPUImageFilterGroup *) filters setTerminalFilter:filter3];
    filters.title = @"组合";
    filters.color = [UIColor yellowColor];
    return filters;
}


@end
