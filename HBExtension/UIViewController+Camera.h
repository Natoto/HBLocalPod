//
//  HBImagePickerController+Camera.h
//  EditImageDemo
//
//  Created by HUANGBO on 15/4/8.
//  Copyright (c) 2015年 YY.COM All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
@class MBProgressHUD;
@protocol UIViewControllerCameraDelegate;

@interface UIViewController(Camera)<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic, assign, readonly) BOOL editMode;

-(void)setEditMode:(BOOL)editMode;
/**
 * 首先要设置代理模式 第一步
 */
-(void)setUIViewControllerCameraDelegate:(id)delegate;

-(void)cancelUIViewControllerCameraDelegate;

-(void)presentCameraViewControllerWithAnimated: (BOOL)flag completion:(void (^)(void))completion;

- (void)presentAblumViewControllerWithAnimated: (BOOL)flag completion:(void (^)(void))completionx;
@end




@protocol UIViewControllerCameraDelegate <NSObject>

@optional
/**
 * 从相册挑选图片取消
 */
- (void)hb_imagePickerControllerDidCancel:(UIViewController *)imagePickerController;
/**
 * 从相机选择图片
 */
-(void)hb_imagePickerController:(UIViewController *)viewController cameraDidFinishPickingMediaWithImage:(UIImage *)image;


@end
