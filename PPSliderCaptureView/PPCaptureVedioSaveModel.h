//
//  PPCaptureVedioSaveModel.h
//  VedioFilterDemo
//
//  Created by boob on 2017/5/24.
//  Copyright © 2017年 YY.COM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GPUImage/GPUImage.h>

#define LZBImageViewWidth  720
#define LZBImageViewHeight  1280

typedef enum : NSUInteger {
    PPCAPTURE_STATE_END,
    PPCAPTURE_STATE_RUNNING,
} PPCAPTURE_STATE;


@interface PPCaptureVedioSaveModel : NSObject

-(instancetype)initWithCamera:(GPUImageVideoCamera *)camera vedioImageView:(GPUImageView *)videoImageView;


@property (nonatomic, strong) NSString * videoPath;

@property (nonatomic, assign) PPCAPTURE_STATE captureState;

@property (nonatomic,retain) GPUImageOutput<GPUImageInput> *filter;;

@property (nonatomic, copy) void (^saveblcok)(BOOL succ);

@property (nonatomic, copy) void (^captureblock)(PPCAPTURE_STATE state);//0开始 1结束 2进行中

/**
 * 保存到相册
 */
-(void)save_to_photosAlbum:(NSString *)path;

- (void)start_stop:(BOOL)isSelected;

+ (void)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time image: (void(^)(UIImage* image)) imageblock;

@end
