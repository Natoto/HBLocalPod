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
    
    NSString * filename = [NSString stringWithFormat:@"movie%.0f-%.0fx%.0f.mp4",[[NSDate date] timeIntervalSince1970],size.width,size.height];
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString * parentpathToMovie = [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches/"];
    NSString *pathToMovie = [parentpathToMovie stringByAppendingPathComponent:filename];
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
//            complete(movieURL);
            [[self class] convertVideoWithModel:pathToMovie zippath:^(NSString *zipfilepath) {
                self.sbxvideoPath = zipfilepath;
                complete([NSURL fileURLWithPath:zipfilepath]);
            }];
        });
    }];

    self.sbxvideoPath = pathToMovie;
    return pathToMovie;
}



/**
 * TODO: 视频压缩
 */
+ (void) convertVideoWithModel:(NSString *) sandBoxFilePath zippath:(void(^)(NSString *zipfilepath))zipfilepathblock
{
    NSString * filename = sandBoxFilePath.lastPathComponent;
    //保存至沙盒路径
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString * pathDocuments = [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches/zip"];
    
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:pathDocuments] )
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:pathDocuments
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString * zippath = [pathDocuments stringByAppendingPathComponent:filename];
        
        //转码配置
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:sandBoxFilePath] options:nil];
        AVAssetExportSession *exportSession=  [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputURL = [NSURL fileURLWithPath:zippath];
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            int exportStatus = exportSession.status;
//            NSLog(@"%d",exportStatus);
            switch (exportStatus)
            {
                case AVAssetExportSessionStatusFailed:
                {
                    // log error to text view
                    NSError *exportError = exportSession.error;
                    NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (zipfilepathblock) {
                            zipfilepathblock(sandBoxFilePath);
                        }
                    });
                    break;
                }
                case AVAssetExportSessionStatusCompleted:
                {
                    NSLog(@"视频转码成功 , 保存压缩路径：%@",zippath);
//                    NSData *data = [NSData dataWithContentsOfFile:sandBoxFilePath];
//                    [data writeToFile:zippath atomically:YES];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (zipfilepathblock) {
                            zipfilepathblock(zippath);
                        }
                    });
                }
            }
        }];
        
    });
    
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
- (void) av_createWatermark:(CATextLayer *)lable video:(NSURL*)videoURL
                complete:(void(^)(NSURL * savepath))complete
{
    if (videoURL == nil)
        return;
    
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:videoURL options:nil];
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *clipVideoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *clipAudioTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    //If you need audio as well add the Asset Track for audio here
    
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:clipVideoTrack atTime:kCMTimeZero error:nil];
    [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:clipAudioTrack atTime:kCMTimeZero error:nil];
    
    [compositionVideoTrack setPreferredTransform:[[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] preferredTransform]];
    
    CGSize sizeOfVideo=[videoAsset naturalSize];
    //NSLog(@"sizeOfVideo.width is %f",sizeOfVideo.width);
    //NSLog(@"sizeOfVideo.height is %f",sizeOfVideo.height);
    //TextLayer defines the text they want to add in Video
    
    CATextLayer *textOfvideo= lable;
    
//    [[CATextLayer alloc] init];
//    textOfvideo.string=[NSString stringWithFormat:@"%@",text];//text is shows the text that you want add in video.
//    [textOfvideo setFont:(__bridge CFTypeRef)([UIFont fontWithName:[NSString stringWithFormat:@"%@",fontUsed] size:13])];//fontUsed is the name of font
//    [textOfvideo setFrame:CGRectMake(0, 0, sizeOfVideo.width, sizeOfVideo.height/6)];
//    [textOfvideo setAlignmentMode:kCAAlignmentCenter];
//    [textOfvideo setForegroundColor:[selectedColour CGColor]];
    
    
    CALayer *optionalLayer=[CALayer layer];
    [optionalLayer addSublayer:textOfvideo];
    optionalLayer.frame=CGRectMake(0, 0, sizeOfVideo.width, sizeOfVideo.height);
    [optionalLayer setMasksToBounds:YES];
    
    CALayer *parentLayer=[CALayer layer];
    CALayer *videoLayer=[CALayer layer];
    parentLayer.frame=CGRectMake(0, 0, sizeOfVideo.width, sizeOfVideo.height);
    videoLayer.frame=CGRectMake(0, 0, sizeOfVideo.width, sizeOfVideo.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:optionalLayer];
    
    AVMutableVideoComposition *videoComposition=[AVMutableVideoComposition videoComposition] ;
    videoComposition.frameDuration=CMTimeMake(1, 10);
    videoComposition.renderSize=sizeOfVideo;
    videoComposition.animationTool=[AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [mixComposition duration]);
    AVAssetTrack *videoTrack = [[mixComposition tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableVideoCompositionLayerInstruction* layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
    NSString *destinationPath = [documentsDirectory stringByAppendingFormat:@"/utput_%@.mov", [dateFormatter stringFromDate:[NSDate date]]];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
    exportSession.videoComposition=videoComposition;
    
    exportSession.outputURL = [NSURL fileURLWithPath:destinationPath];
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        switch (exportSession.status)
        {
            case AVAssetExportSessionStatusCompleted:
                NSLog(@"Export OK");
                complete(exportSession.outputURL);
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(destinationPath)) {
                    UISaveVideoAtPathToSavedPhotosAlbum(destinationPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                }
                break;
            case AVAssetExportSessionStatusFailed:
                complete(nil);
                NSLog (@"AVAssetExportSessionStatusFailed: %@", exportSession.error);
                break;
            case AVAssetExportSessionStatusCancelled:complete(nil);
                NSLog(@"Export Cancelled");
                break;
        }
    }];
    
//    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:videoURL options:nil];
//    AVMutableComposition* mixComposition = [AVMutableComposition composition];
//    
//    AVMutableCompositionTrack* compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo  preferredTrackID:kCMPersistentTrackID_Invalid];
//    
//    AVAssetTrack* clipVideoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
//    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
//                                   ofTrack:clipVideoTrack
//                                    atTime:kCMTimeZero error:nil];
//    
//    [compositionVideoTrack setPreferredTransform:[[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] preferredTransform]];
//    
//    AVAssetTrack* videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
//    CGSize videoSize = [videoTrack naturalSize];
//    
//    if (!lable) {
//        lable = [self createtextlayer];
//    }
//    
//    CALayer *parentLayer = [CALayer layer];
//    CALayer *videoLayer = [CALayer layer];
//    parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
//    videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
//    [parentLayer addSublayer:videoLayer];
//    [parentLayer addSublayer:lable];
//    
//    //create the composition and add the instructions to insert the layer:
//    
//    AVMutableVideoComposition* videoComp = [AVMutableVideoComposition videoComposition];
//    videoComp.renderSize = videoSize;
//    videoComp.frameDuration = CMTimeMake(1, 30);
//    videoComp.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
//    
//    /// instruction
//    AVMutableVideoCompositionInstruction* instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
//    
//    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [mixComposition duration]);
//    AVAssetTrack* mixVideoTrack = [[mixComposition tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
//    AVMutableVideoCompositionLayerInstruction* layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:mixVideoTrack];
//    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
//    videoComp.instructions = [NSArray arrayWithObject: instruction];
//    
//    // export video
//    
//    _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
//    _assetExport.videoComposition = videoComp;
//    
//    NSLog (@"created exporter. supportedFileTypes: %@", _assetExport.supportedFileTypes);
//    
//    NSString* videoName = @"NewWatermarkedVideo.mov";
//    
//    NSString* exportPath = [NSTemporaryDirectory() stringByAppendingPathComponent:videoName];
//    NSURL* exportUrl = [NSURL fileURLWithPath:exportPath];
//    
//    NSLog(@"%@",exportUrl);
//    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath])
//        [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
//    
//    _assetExport.outputFileType = AVFileTypeQuickTimeMovie;
//    _assetExport.outputURL = exportUrl;
//    _assetExport.shouldOptimizeForNetworkUse = YES;
//    
//    [_assetExport exportAsynchronouslyWithCompletionHandler:
//     ^(void ) {
//         
//         
//         //Final code here
//         
//         switch (_assetExport.status)
//         {
//             case AVAssetExportSessionStatusUnknown:
//                 NSLog(@"Unknown");
//                 break;
//             case AVAssetExportSessionStatusWaiting:
//                 NSLog(@"Waiting");
//                 break;
//             case AVAssetExportSessionStatusExporting:
//                 NSLog(@"Exporting");
//                 break;
//             case AVAssetExportSessionStatusCompleted:
//                 complete(exportUrl);
//                 NSLog(@"Created new water mark image");
//                 
//                 break;
//             case AVAssetExportSessionStatusFailed:
//                 complete(nil);
//                 NSLog(@"Failed- %@", _assetExport.error);
//                 break;
//             case AVAssetExportSessionStatusCancelled:
//                 NSLog(@"Cancelled");
//                 break;
//         }
//     }
//     ];   
}
-(void) video: (NSString *) videoPath didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if(error)
        NSLog(@"Finished saving video with error: %@", error);
}
@end
