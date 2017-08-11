//
//  BaseViewControllerProtocol.h
//  PENG
//
//  Created by zeno on 15/12/14.
//  Copyright © 2015年 nonato. All rights reserved.
//
#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import "HBNavigationbar.h"
#import "ProtocolKit.h"
//#import "PENG_Define.h"
#import "UIViewAdditions.h"
#import "HJBRouterHelper.h"
#import <HBKit/HBKit.h>
#import <HBKitRefresh/HBKitRefresh.h>


static NSString * const  notify_sender_Network =@"Network";
static NSString * const  notify_NetworkError= @"notify_NetworkError";

#define DEFAULT_CELL_SELECTOR  DEFAULT_CELL_SELECT_ACTION

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
//NSLog(__VA_ARGS__);
#define NSLogMethod NSLog(@"🔴类名与方法名：%s（在第%d行），描述：%@", __PRETTY_FUNCTION__, __LINE__, NSStringFromClass([self class]));
#else
#  define NSLog(...) ;
#  define NSLogMethod ;
#endif

//static int app_user_PengGifHeader = 0;
//static int app_user_PengGifFooter = 0;

@protocol BaseViewControllerProtocol<NSObject>

@end

@interface HBBaseViewController(BaseViewControllerProtocol)
@property(nonatomic,retain) HBNavigationbar * navigationbar;
@property(nonatomic,retain) HBNavigationbar * navigationtoolsbar;
 
-(void)backtoparent:(id)sender andRefresh:(BOOL)refresh animate:(BOOL)animate;
-(void)backtoparent:(id)sender andRefresh:(BOOL)refresh;
-(void)FinishedLoadData;
-(void)refreshView;
//-(void)swizz_dealloc;

/**
 * 配置是否是否使用自定义的header footer
 */
-(BOOL)app_use_gifHeader;
-(BOOL)app_use_gifFooter;
/**
 * 配置刷新动画头部
 */
-(void)config_user_gifheader;
-(void)config_user_giffooter;
@end

@interface UIViewController(hbshownewmsg)

- (void)showUpdateNewsCountMessageView:(NSString *)message;
- (UILabel *)showStatusbarMessageView:(NSString *)message;

@end
