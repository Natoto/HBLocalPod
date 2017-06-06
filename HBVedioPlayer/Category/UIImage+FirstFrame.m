//
//  UIImage+FirstFrame.m
//  fenda
//
//  Created by boob on 2017/6/6.
//  Copyright © 2017年 YY.COM. All rights reserved.
//

#import "UIImage+FirstFrame.h"
#import <AVFoundation/AVFoundation.h>

@implementation UIImage(FirstFrame)


+ (void) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time image: (void(^)(UIImage* image)) imageblock  {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        NSParameterAssert(asset);
        AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
        assetImageGenerator.appliesPreferredTrackTransform = YES;
        assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
        
        CGImageRef thumbnailImageRef = NULL;
        CFTimeInterval thumbnailImageTime = time;
        NSError *thumbnailImageGenerationError = nil;
        thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
        
        if(!thumbnailImageRef)
            NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
            imageblock(thumbnailImage);
        });
    });
}

@end
