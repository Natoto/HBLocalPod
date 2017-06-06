//
//  BaseViewController.h
//  PENG
//
//  Created by zeno on 15/12/14.
//  Copyright © 2015年 nonato. All rights reserved.
//

#import <HBKit/HBKit.h>
#import "HBNavigationbar.h"
//#import "HBPrecomplile.h"
//#import "PENGColor.h"
//#import "PENGFont.h"
//#import "PENG_Define.h"
#import "HBSignalBus.h"
#import "BaseViewControllerProtocol.h"

@interface BaseViewController : HBBaseViewController<BaseViewControllerProtocol>
@property(nonatomic,strong) NSNumber * thiscreateTime;

/**
 *  是否显示loading动画 需要重载
 *
 *  @return 是否
 */
-(BOOL)isShowLoadingView;
-(void)FinishedLoadData;


@end
