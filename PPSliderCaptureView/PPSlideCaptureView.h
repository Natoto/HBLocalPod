//
//  PPSlideCaptureView.h
//  VedioFilterDemo
//
//  Created by boob on 2017/5/24.
//  Copyright © 2017年 YY.COM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage/GPUImage.h>
#import "PPCameraFilters.h"

/**
 * 滑动滤镜选择用法
 -(PPCaptureVedioSaveModel *)model{
 if (!_model) {
 _model = [[PPCaptureVedioSaveModel alloc] initWithCamera:self.captureView.camera];
 }
 return _model;
 }
 
 - (void)viewDidLoad {
 [super viewDidLoad];
 self.automaticallyAdjustsScrollViewInsets = NO;
 [self.captureView.camera startCameraCapture];
 }
 - (IBAction)btnCaptureTap:(id)sender {
 
 self.model.filter = self.captureView.currentGroup;
 [self.model start_stop:sender];
 }
 */
 

@class PPSlideCaptureView;
@protocol PPSlideCaptureViewDelegate

-(NSArray<GPUImageFilterGroup *> *)ftgroupsOfslideCaptureView:(PPSlideCaptureView *)captureView;

@optional
-(void)PPSlideCaptureView:(PPSlideCaptureView *)captureView updateFilterAtIndex:(NSInteger)index;
@end
/**
 * 滑动视频实时滤镜
 */
@interface PPSlideCaptureView : UIView

@property (strong, nonatomic,readonly)  GPUImageView *vidioImageView;


@property (nonatomic, weak) NSObject<PPSlideCaptureViewDelegate> * delegate;

//@property (nonatomic, strong) GPUImageVideoCamera * camera;
//@property (strong, nonatomic,readonly)  GPUImageView *pictureImageView;
@property (nonatomic, strong) GPUImageStillCamera * stillCamera;

/**
 * 当前滤镜
 */
@property (nonatomic , strong,readonly) GPUImageFilterGroup *currentGroup;

@property (nonatomic, assign) NSInteger   currentIndex;

@property (nonatomic, assign) NSInteger   maskIndex;

@end
