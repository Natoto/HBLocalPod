//
//  HBPagableViewController.h
//  switchchildcontrollers
//
//  Created by zeno on 16/1/25.
//  Copyright © 2016年 YY.COM All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBContainerView;
@protocol HBContainerViewDelegate <NSObject>
//datasource
 
- (NSInteger)numberOfControllersInHBContainer:(HBContainerView *)viewController;

- (UIViewController *)hbcontainer:(HBContainerView *)viewController subControllerForIndex:(NSInteger)subIndex;
//delegate
-(void)hbcontainer:(HBContainerView *)viewController selectIndex:(NSInteger)selectIndex;
@end

@interface HBContainerView : UIView

@property(nonatomic,weak) NSObject<HBContainerViewDelegate> * containerDelegate;

-(void)swithSubControllerWithIndex:(NSInteger)selectIndex;
@end
