//
//  UIImage+FirstFrame.h
//  fenda
//
//  Created by boob on 2017/6/6.
//  Copyright © 2017年 YY.COM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(FirstFrame)

+ (void) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time image: (void(^)(UIImage* image)) imageblock;

@end
