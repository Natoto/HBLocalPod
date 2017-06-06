//
//  UIImageView+PengWebCache.h
//  PENG
//
//  Created by zeno on 15/11/23.
//  Copyright © 2015年 nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UIView+Loading.h"
typedef void(^HBWebImageCompletionBlock)(UIImage *image, NSError *error, int cacheType, NSURL *imageURL);

@interface UIImageView(HBWebCache)

/**
 *  加载图片 加载等待界面为gif
 *
 *  @param url 图片url
 *  @param gif gif的名字
 */
//- (void)hb_setImageWithURL:(NSURL *)url withLoadingGif:(NSString *)gif;

- (void)hb_setImageWithURL:(NSURL *)url;

- (void)hb_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)hb_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(int)options;

- (void)hb_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(int)options completed:(HBWebImageCompletionBlock)completedBlock;

-(void)hb_cancelCurrentImageLoad;
@end


@interface UIButton(PengWebCache)
- (void)hb_setImageWithURL:(NSURL *)url forState:(UIControlState)state;

- (void)hb_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state;

- (void)hb_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(int)options;

- (void)hb_setImageWithURL:(NSURL *)url forState:(UIControlState)state  completed:(HBWebImageCompletionBlock)completedBlock;

- (void)hb_setImageWithURL:(NSURL *)url placeholder:(UIImage *)placeholder forState:(UIControlState)state;
@end
