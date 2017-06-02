//
//  NSObject+HBHUD.h
//  HUANGBO
//
//  Created by HUANGBO on 15/1/25.
//  Copyright (c) 2015年 YY.COM All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class MBProgressHUD;
@interface NSObject(HBHUD)<MBProgressHUDDelegate>

@property (nonatomic, strong) UIColor * hudbgcolor;
@property (nonatomic, strong) NSNumber * hudoffset;

-(void)presentMessageTips:(NSString *)message animated:(BOOL)animated;

-(void)presentAlertTitle:(NSString *)title message:(NSString *)message;

-(void)presentAlertTitle:(NSString *)title message:(NSString *)message from:(UIViewController *)from block:(void(^)())block;

-(void)presentSheetTitle:(NSString *)title
                 message:(NSString *)message
                    from:(UIViewController *)from
                   block:(void(^)())block
                  cancel:(void(^)())cancle;

-(void)presentAlertTips:(NSString *)message;

-(MBProgressHUD *)presentMessageTips_:(NSString *)message;

- (void)presentMessageTips_:(NSString *)message dismisblock:(void(^)())dismissblock;

-(void)presentFailureTips:(NSString *)message;

-(void)presentMessageTips:(NSString *)message;
- (void)presentMessageTips:(NSString *)message dismisblock:(void(^)())dismissblock;
-(MBProgressHUD *)presentLoadingTips:(NSString *)message;
-(void)dismissTips;

-(MBProgressHUD *)presentLoadinghud;
-(void)dismissAllTips;

@end
