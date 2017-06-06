//
//  BaseViewController.m
//  PENG
//
//  Created by zeno on 15/12/14.
//  Copyright © 2015年 nonato. All rights reserved.
//

#import "BaseViewController.h"
//#import "UIView+Loading.h"
//#import "HiidoSdkModel.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    if (self.navigationController.childViewControllers.count > 1 && self.navigationController.topViewController == self) {
//        self.showBackItem = YES;
//    }
//    if (self.isShowLoadingView) {
//        [self.view loadingView];
//    }
}
-(BOOL)app_user_gifFooter{
    return NO;
}
-(BOOL)app_user_gifHeader{
    return NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [HiidoSdkModel enterPage:[self class] title:self.navigationbar.title];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [HiidoSdkModel leavePageId:self.navigationbar.title destPageId:nil];
}


-(BOOL)isShowLoadingView
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [self swizz_dealloc];
}

#pragma mark - 断开网络
-(void)FinishedLoadData
{
    [super FinishedLoadData];
//    [self.view hideloadingview];
}
-(void)swizz_dealloc
{
    NSLogMethod
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    REMOVE_HBSIGNAL_OBSERVER(self, notify_NetworkError,  notify_sender_Network)
}
 
@end
