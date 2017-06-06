//
//  ImagesVideoPreViewController.h
//  PENG
//
//  Created by zeno on 15/10/28.
//  Copyright © 2015年 nonato. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MWPhotoBrowser.h"
@class YYPhotoGroupView;

@interface  UIViewController(ImagesVideoPreView)//<MWPhotoBrowserDelegate>

@property (nonatomic, strong,readonly) YYPhotoGroupView * photogroupvView;
-(void)showPhotoBrowserWithURLS:(NSArray<NSURL *> *)imageurls;
-(void)showPhotoBrowserWithURLS:(NSArray<NSURL *> *)imagevideourls CurrentPhotoIndex:(NSInteger)currentPhotoIndex;
-(void)showPhotoBrowserWithURLS:(NSArray<NSURL *> *)imagevideourls CurrentPhotoIndex:(NSInteger)currentPhotoIndex fromView:(UIView *)fromView;

- (void)showVideoBrowserWithURL:(NSURL *)videoURL;
 
-(void)showPhotoBrowserWithImages:(NSArray<UIImage *> *)images CurrentPhotoIndex:(NSInteger)currentPhotoIndex fromView:(UIView *)fromView;

-(UIView *)mycontainer;
@end
