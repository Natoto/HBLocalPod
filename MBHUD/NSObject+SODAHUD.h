//
//  NSObject+HBHUD.h
//  pengmi
//
//  Created by BOOB on 18/1/3.
//  Copyright (c) 2018年 YY.Inc All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SodaCircleProgressHud.h"

static long tag_view_circlehud = 0xe3e334;

@class MBProgressHUD;
@interface NSObject(HBHUD)<MBProgressHUDDelegate>

-(UIView *)HUDSuperView;

/**
 * 显示扇形进度条,含有取消按钮
 */
-(MBProgressHUD *)presentSectorHud:(NSString *)text
                            cancel:(NSString *)cancelTitle
                          progress:(CGFloat)progress;

/**
 * 显示扇形进度条
 */
-(MBProgressHUD *)presentSectorHud:(NSString *)text progress:(CGFloat)progress;

/**
 * 图片提示框
 */
-(MBProgressHUD *)presentImageHud:(NSString *)imgName text:(NSString *)text;

/**
 * 自定义等待框
 */
-(MBProgressHUD *)presentCustomViewHud:(UIView *)customView text:(NSString *)text;
/**
 * 显示圆形进度条
 */
-(void)presentCircleHud:(NSString *)text progress:(CGFloat)progress;

/**
 * 显示条形进度条
 */
-(MBProgressHUD *)presentbarhud:(NSString *)text progress:(CGFloat)progress;

/**
 * 文字提示
 */
-(MBProgressHUD *)presentMessageTips_:(NSString *)message;

/**
 * 文字提示，带消失回调
 */
- (void)presentMessageTips_:(NSString *)message dismisblock:(void(^)())dismissblock;

/**
 * 错误提示
 */
-(void)presentFailureTips:(NSString *)message;

/**
 * 文字提示
 */
-(void)presentMessageTips:(NSString *)message;

/**
 * 文字提示，带消失回调
 */
- (void)presentMessageTips:(NSString *)message dismisblock:(void(^)())dismissblock;

/**
 * 转圈等待
 */
-(MBProgressHUD *)presentLoadingTips:(NSString *)message;

/**
 * 消失等待框
 */
-(void)dismissTips;

/**
 * 转圈等待loading
 */
-(void)presentLoadinghud;

/**
 * 消失等待框
 */
-(void)dismissAllTips;

@end

