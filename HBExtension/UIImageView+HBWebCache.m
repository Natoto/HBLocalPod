//
//  UIImageView+PengWebCache.m
//  PENG
//
//  Created by zeno on 15/11/23.
//  Copyright © 2015年 nonato. All rights reserved.
//

#import "UIImageView+HBWebCache.h"
//#import "UIImageView+WebCache.h"
//#import "UIButton+WebCache.h"
#import "YYWebImage.h"

@implementation  UIImageView(HBWebCache)

//- (void)hb_setImageWithURL:(NSURL *)url withLoadingGif:(NSString *)gif
//{ 
//    if (!self.image) {
//        self.loadingView.hidden = NO;
//    }
//    [self yy_setImageWithURL:url placeholder:nil options:YYWebImageOptionShowNetworkActivity | YYWebImageOptionShowNetworkActivity | YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
//        if (image) {
//            self.loadingView.hidden = YES;
//        }
//    }];
//}

- (void)hb_setImageWithURL:(NSURL *)url {
     
    [self yy_setImageWithURL:url placeholder:nil options:YYWebImageOptionShowNetworkActivity  completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
    }];
}

- (void)hb_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
//     [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
    [self yy_setImageWithURL:url placeholder:placeholder options:YYWebImageOptionShowNetworkActivity completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
        
    }];
}

- (void)hb_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(int)options {
//    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
    
    [self yy_setImageWithURL:url placeholder:placeholder options:YYWebImageOptionShowNetworkActivity completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
        
    }];
}


- (void)hb_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(int)options completed:(HBWebImageCompletionBlock)completedBlock
{
//    [self sd_setImageWithURL:url placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if(completedBlock) completedBlock(image,error,cacheType,imageURL);
//    }];
    [self yy_setImageWithURL:url placeholder:placeholder options:YYWebImageOptionShowNetworkActivity completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
         if(completedBlock) completedBlock(self.image,error,stage,url);
    }];
}

-(void)hb_cancelCurrentImageLoad
{
//    [self sd_cancelCurrentAnimationImagesLoad];
    [self yy_cancelCurrentImageRequest];
}
@end

@implementation UIButton(PengWebCache)

- (void)hb_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(int)options {
    
    [self hb_setImageWithURL:url placeholder:placeholder forState:UIControlStateNormal];
}


- (void)hb_setImageWithURL:(NSURL *)url forState:(UIControlState)state {
//    [self sd_setImageWithURL:url forState:state placeholderImage:[UIImage imageNamed:@"nopic.png"] options:0 completed:nil];
    
//    [self yy_setImageWithURL:url forState:state options:YYWebImageOptionShowNetworkActivity | YYWebImageOptionShowNetworkActivity | YYWebImageOptionSetImageWithFadeAnimation];
    [self yy_setImageWithURL:url forState:state placeholder:[UIImage imageNamed:@"nopic.png"] options:YYWebImageOptionShowNetworkActivity
                  completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
    }];
 
}


- (void)hb_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state {
 
    [self yy_setBackgroundImageWithURL:url forState:state placeholder:[UIImage imageNamed:@"nopic.png"] options:YYWebImageOptionShowNetworkActivity
                  completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                  }];
}
- (void)hb_setImageWithURL:(NSURL *)url placeholder:(UIImage *)placeholder forState:(UIControlState)state {
    
    [self yy_setImageWithURL:url forState:state placeholder:placeholder options:YYWebImageOptionShowNetworkActivity
                  completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
        
    }];
    
    
}

- (void)hb_setImageWithURL:(NSURL *)url forState:(UIControlState)state  completed:(HBWebImageCompletionBlock)completedBlock
{
     [self yy_setImageWithURL:url forState:state placeholder:nil options:YYWebImageOptionShowNetworkActivity
                   completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
          if(completedBlock) completedBlock(image,error,stage,url);
     }];
}


//+ (YYWebImageManager *)avatarImageManager {
//    static YYWebImageManager *manager;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSString *path = [[UIApplication sharedApplication].cachesPath stringByAppendingPathComponent:@"weibo.avatar"];
//        YYImageCache *cache = [[YYImageCache alloc] initWithPath:path];
//        manager = [[YYWebImageManager alloc] initWithCache:cache queue:[YYWebImageManager sharedManager].queue];
//        manager.sharedTransformBlock = ^(UIImage *image, NSURL *url) {
//            if (!image) return image;
//            return [image imageByRoundCornerRadius:100]; // a large value
//        };
//    });
//    return manager;
//}
@end
