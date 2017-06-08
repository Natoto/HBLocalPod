//
//  PPVideoWaterMarkModel.m
//  Pods
//
//  Created by boob on 2017/6/7.
//
//

#import "PPVideoWaterMarkModel.h"
#import <GPUImage/GPUImage.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface PPVideoWaterMarkModel()
{
    AVAssetExportSession * _assetExport;
}

@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic, strong) GPUImageView * filterView;
@property (nonatomic, strong) GPUImageUIElement *uielement;

@property (nonatomic, strong) GPUImageMovieWriter * movieWriter;
@property (nonatomic, strong) GPUImageMovie *movieFile;

@property (nonatomic, strong) GPUImageUIElement * uiElementInput;

@property (nonatomic, strong) NSString * sbxvideoPath;

@property (nonatomic, strong) void(^progressblock)(CGFloat progress);

@property (nonatomic, strong) CADisplayLink* dlink;

@property (nonatomic, strong)  GPUImageFilter* progressFilter;

@end


#ifndef	weakify
#if __has_feature(objc_arc)
#define weakify( x )	autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x;
#else	// #if __has_feature(objc_arc)
#define weakify( x )	autoreleasepool{} __block __typeof__(x) __block_##x##__ = x;
#endif	// #if __has_feature(objc_arc)
#endif	// #ifndef	weakify

#ifndef	strongify
#if __has_feature(objc_arc)
#define strongify( x )	try{} @finally{} __typeof__(x) x = __weak_##x##__;
#else	// #if __has_feature(objc_arc)
#define strongify( x )	try{} @finally{} __typeof__(x) x = __block_##x##__;
#endif	// #if __has_feature(objc_arc)
#endif	// #ifndef	@normalize

@implementation PPVideoWaterMarkModel

-(void)dealloc{
    NSLog(@"%@ %s ",NSStringFromClass([self class]),__func__);
}

-(void)saveToAblum:(void(^)(NSURL *assetURL))block
{
    [self save_to_photosAlbum:self.sbxvideoPath block:block];
}


-(void)save_to_photosAlbum:(NSString *)pathToMovie block:(void(^)(NSURL *assetURL))complete
{
    @weakify(self)
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(pathToMovie))
    {
        [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:pathToMovie] completionBlock:^(NSURL *assetURL, NSError *error)
         {
             @strongify(self)
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 if (error) {
                     complete(nil);
                 } else {
                     [self.dlink invalidate];
                     complete(assetURL);
                 }
             });
         }];
    }
    else {
        NSLog(@"error mssg)");
        complete(nil);
    }
}



-(NSString *)MixVideoPathWithVedioUrl:(NSURL *)url
                              subView:(UIView *)subView
                              fromFilterView:(GPUImageView *)filterView
                              progress:(void (^)(CGFloat))progressblock
                              complete:(void(^)(NSURL * savepath))complete
{
    if (!filterView) {
        filterView = [[GPUImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    self.filterView = filterView;
    self.progressblock = progressblock;
    
    // 滤镜
    GPUImageNormalBlendFilter *filter = [[GPUImageNormalBlendFilter alloc] init];
//    [(GPUImageDissolveBlendFilter *)filter setMix:0.5];
    self.filter = filter;
    
    // 取视频 播放 
    AVAsset *asset = [AVAsset assetWithURL:url];
    CGSize size = asset.naturalSize;
    GPUImageMovie * movieFile = [[GPUImageMovie alloc] initWithAsset:asset];
    _movieFile = movieFile;
    movieFile.runBenchmark = NO;
    movieFile.playAtActualSpeed = YES;
    movieFile.shouldRepeat = YES;
    
    //取界面动画
    if (!subView) {
        subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        subView.opaque = YES;
    }
    GPUImageUIElement *uielement = [[GPUImageUIElement alloc] initWithView:subView];
    //    GPUImageTransformFilter 动画的filter
    self.uielement = uielement;
    
    NSString * filename = [NSString stringWithFormat:@"Documents/movie%.0f.m4v",[[NSDate date] timeIntervalSince1970]];
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:filename];
//    unlink([pathToMovie UTF8String]);
    
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    NSLog(@"movieURL %@",movieURL);
    
    
    GPUImageMovieWriter *movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:size];//CGSizeMake(640.0, 480.0)
    self.movieWriter = movieWriter;
    
    GPUImageFilter* progressFilter = [[GPUImageFilter alloc] init];
    self.progressFilter = progressFilter;
    
    [movieFile addTarget:progressFilter];
    [progressFilter addTarget:filter];
    [uielement addTarget:filter];
    
    movieWriter.shouldPassthroughAudio = YES;
    movieFile.audioEncodingTarget = movieWriter;
    [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
    
    // 显示到界面
    [filter addTarget:filterView];
    [filter addTarget:movieWriter];
    
    
    [movieWriter startRecording];
    [movieFile startProcessing];
    
    //监听进度
    CADisplayLink* dlink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
    [dlink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [dlink setPaused:NO];
    self.dlink = dlink;
    
    @weakify(self)
    //进度刷新
    [self.progressFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time) {
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(PPVideoWaterMarkModel:uielementupdate:progress:)]) {
            [self.delegate PPVideoWaterMarkModel:self uielementupdate:subView progress:self.movieFile.progress];
        }
        [self.uielement updateWithTimestamp:time];
    }];
    
    [self.movieWriter setCompletionBlock:^{
        @strongify(self)
        [self.filter removeTarget:self.movieWriter];
        [self.movieWriter finishRecording];
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(movieURL);
        });
    }];

    self.sbxvideoPath = pathToMovie;
    return pathToMovie;
}

- (void)updateProgress
{
    if (self.movieFile.progress>=1.0) {
        [self.dlink invalidate];
    }
    self.progressblock(self.movieFile.progress);
}



-(CATextLayer *)createtextlayer{
    CATextLayer* titleLayer = [CATextLayer layer];
    titleLayer.backgroundColor = [UIColor clearColor].CGColor;
    titleLayer.string =  @"Dummy text";
    //    titleLayer.font = CFBridgingRetain(lable.font.familyName);
    titleLayer.fontSize = 30;//lable.font.pointSize;
    titleLayer.shadowOpacity = 0.5;
    titleLayer.foregroundColor = [UIColor whiteColor].CGColor;
    //lable.textColor.CGColor;
    titleLayer.alignmentMode = kCAAlignmentCenter;
    titleLayer.frame =  CGRectMake(0, 50, 200, 100);
    return titleLayer;
}

/**
 * 第二种方式添加水印
 */
- (void) createWatermark:(CATextLayer *)lable video:(NSURL*)videoURL
                complete:(void(^)(NSURL * savepath))complete
{
    if (videoURL == nil)
        return;
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:videoURL options:nil];
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack* compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo  preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack* clipVideoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                   ofTrack:clipVideoTrack
                                    atTime:kCMTimeZero error:nil];
    
    [compositionVideoTrack setPreferredTransform:[[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] preferredTransform]];
    
    AVAssetTrack* videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGSize videoSize = [videoTrack naturalSize];
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:lable];
    
    //create the composition and add the instructions to insert the layer:
    
    AVMutableVideoComposition* videoComp = [AVMutableVideoComposition videoComposition];
    videoComp.renderSize = videoSize;
    videoComp.frameDuration = CMTimeMake(1, 30);
    videoComp.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    /// instruction
    AVMutableVideoCompositionInstruction* instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [mixComposition duration]);
    AVAssetTrack* mixVideoTrack = [[mixComposition tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableVideoCompositionLayerInstruction* layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:mixVideoTrack];
    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    videoComp.instructions = [NSArray arrayWithObject: instruction];
    
    // export video
    
    _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
    _assetExport.videoComposition = videoComp;
    
    NSLog (@"created exporter. supportedFileTypes: %@", _assetExport.supportedFileTypes);
    
    NSString* videoName = @"NewWatermarkedVideo.mov";
    
    NSString* exportPath = [NSTemporaryDirectory() stringByAppendingPathComponent:videoName];
    NSURL* exportUrl = [NSURL fileURLWithPath:exportPath];
    
    NSLog(@"%@",exportUrl);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath])
        [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
    
    _assetExport.outputFileType = AVFileTypeQuickTimeMovie;
    _assetExport.outputURL = exportUrl;
    _assetExport.shouldOptimizeForNetworkUse = YES;
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {
         
         
         //Final code here
         
         switch (_assetExport.status)
         {
             case AVAssetExportSessionStatusUnknown:
                 NSLog(@"Unknown");
                 break;
             case AVAssetExportSessionStatusWaiting:
                 NSLog(@"Waiting");
                 break;
             case AVAssetExportSessionStatusExporting:
                 NSLog(@"Exporting");
                 break;
             case AVAssetExportSessionStatusCompleted:
                 complete(exportUrl);
                 NSLog(@"Created new water mark image");
                 
                 break;
             case AVAssetExportSessionStatusFailed:
                 complete(nil);
                 NSLog(@"Failed- %@", _assetExport.error);
                 break;
             case AVAssetExportSessionStatusCancelled:
                 NSLog(@"Cancelled");
                 break;
         }
     }
     ];   
}

@end
