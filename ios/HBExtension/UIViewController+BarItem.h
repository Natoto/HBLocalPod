//
//  UINavigationController+BarItem.h
//  JHTDoctor
//
//  Created by boob on 16/5/23.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(BarItem)

-(UIButton *)setrightBarButtonItemWithImage:(UIImage *)image target:(id)target selector:(SEL)selector;

-(UIButton *)setrightBarButtonItemWithTitle:(NSString *)title target:(id)target selector:(SEL)selector;

-(UIButton *)setleftBarButtonItemWithImage:(UIImage *)image target:(id)target selector:(SEL)selector;

-(UIButton *)setleftBarButtonItemWithTitle:(NSString *)title target:(id)target selector:(SEL)selector;

-(void)setBarButtonItemWithTitles:(NSArray *)titles images:(NSArray<UIImage *> *)images leftbar:(BOOL)left target:(id)target selector:(SEL)selector;
@end
