//
//  PPCaptureVedioSaveModel.m
//  VedioFilterDemo
//
//  Created by boob on 2017/5/24.
//  Copyright © 2017年 YY.COM. All rights reserved.
//

#import "PPCaptureVedioSaveModel.h"
@interface PPCaptureVedioSaveModel()
{
    NSString * pathToMovie;
} 
@property (nonatomic,retain) GPUImageMovieWriter *writer;

@property (nonatomic, strong) GPUImageView *videoImageView;

@property (nonatomic,retain) GPUImageVideoCamera *camera;

@property (nonatomic, strong) NSMutableDictionary * videoSettings;
@end

@implementation PPCaptureVedioSaveModel


-(instancetype)initWithCamera:(GPUImageVideoCamera *)camera vedioImageView:(GPUImageView *)videoImageView{

    self = [super init];
    if (self) {
        self.camera = camera;
        self.videoImageView = videoImageView;
        [self createNewWritterWithisStart:YES];
    }
    return self;
}

- (void)start_stop:(BOOL)isstop
{
  
    if (!self.filter) {
        NSLog(@"滤镜不能为空");
        return;
    }
    if (isstop) {
        [self endRecord];
     
    }else{
        [self beginRecord];
    }
}



#pragma mark - handel
- (void)beginRecord
{
    unlink([self.videoPath UTF8String]);
    if(self.filter != nil)
        [self.filter addTarget:self.writer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.camera.audioEncodingTarget = self.writer;
        [self.writer startRecording];
        self.captureState = PPCAPTURE_STATE_RUNNING;
    });
}

- (void)endRecord
{
    if(self.filter != nil)
        [self.filter removeTarget:self.writer];
    
    __weak typeof(self) weakSelf = self;
    // 储存到图片库,并且设置回调.
    [self.writer finishRecordingWithCompletionHandler:^{
        [weakSelf createNewWritterWithisStart:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf gotoPlayer];
        });
    }];
}

-(void)setCaptureState:(PPCAPTURE_STATE)captureState{
    _captureState = captureState;
    if (self.captureblock) {
        self.captureblock(captureState);
    }
}
- (void)gotoPlayer
{
    self.captureState = PPCAPTURE_STATE_END; 
}


- (void)createNewWritterWithisStart:(BOOL)isCameraCapture {
    
    [self.camera removeTarget:self.writer];
    
    _writer = [[GPUImageMovieWriter alloc] initWithMovieURL:[NSURL fileURLWithPath:self.videoPath] size:CGSizeMake(LZBImageViewWidth , LZBImageViewWidth) fileType:AVFileTypeMPEG4 outputSettings:self.videoSettings];
    //防止can't write frame  
    _writer.encodingLiveVideo = YES;
    _writer.assetWriter.movieFragmentInterval = kCMTimeInvalid;
    
    if(isCameraCapture)
    {
        [self.camera addAudioInputsAndOutputs];
        self.camera.audioEncodingTarget = self.writer;
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSLog(@"baocun");
        [self save_to_photosAlbum:self.videoPath];
    }
}
-(void)save_to_photosAlbum:(NSString *)path
{
    if (!path) {
        path = self.videoPath;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
            
            UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    });
}

// 视频保存回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        if (self.saveblcok) {
            self.saveblcok(NO);
        }
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
        if (self.saveblcok) {
            self.saveblcok(YES);
        }
    }
    
}

- (NSString *)videoPath
{
    if(_videoPath == nil)
    {
        NSString * vedioname = [NSString stringWithFormat:@"movie%d.mp4",(int)[[NSDate date] timeIntervalSince1970]];
        _videoPath =  [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:vedioname];
    }
    return _videoPath;
}


- (NSMutableDictionary *)videoSettings {
    if (!_videoSettings) {
        _videoSettings = [[NSMutableDictionary alloc] init];
        [_videoSettings setObject:AVVideoCodecH264 forKey:AVVideoCodecKey];
        [_videoSettings setObject:[NSNumber numberWithInteger:LZBImageViewWidth] forKey:AVVideoWidthKey];
        [_videoSettings setObject:[NSNumber numberWithInteger:LZBImageViewHeight] forKey:AVVideoHeightKey];
    }
    return _videoSettings;
}
@end
