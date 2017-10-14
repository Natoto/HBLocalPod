//
//  HBNavigationbar.h
//  JXL
//
//  Created by BooB on 15-4-18.
//  Copyright (c) 2015年 BooB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBNavigationbar : UIView
+(HBNavigationbar *)navigationbar;

@property(nonatomic,strong) UIColor     * TintColor;
@property(nonatomic,strong) UIView      * titleView;
@property(nonatomic,strong) UIControl   * leftItem;
@property(nonatomic,strong) UIControl   * rightItem;
@property(nonatomic,strong) NSString    * title;
@property(nonatomic,strong) NSString    * text;
@property (nonatomic, strong) UIFont * titleFont;

+(CGFloat)defaultheight;

-(void)drawtoplinelayer;
-(void)drawbottomlinelayer;
/**
 *  清除底部分割线
 */
-(void)clearBottomLayer;
/**
 *  清除顶部分割线
 */
-(void)clearTopLayer;

+(UIImage *)defaultbackImage;

-(UIButton *)setrightBarButtonItemWithImage:(UIImage *)image target:(id)target selector:(SEL)selector;
-(UIButton *)setrightBarButtonItemWithTitle:(NSString *)title target:(id)target selector:(SEL)selector;

-(UIButton *)setleftBarButtonItemWithImage:(UIImage *)image target:(id)target selector:(SEL)selector;
-(UIButton *)setleftBarButtonItemWithTitle:(NSString *)title target:(id)target selector:(SEL)selector;
-(UIButton *)setBarButtonItemWithTitle:(NSString *)title image:(UIImage *)image leftbar:(BOOL)left target:(id)target selector:(SEL)selector;

//-(UIButton *)setrightBar_1_ButtonItemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage target:(id)target selector:(SEL)selector;
//
//-(UIButton *)setrightBar_2_ButtonItemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage target:(id)target selector:(SEL)selector;

+(HBNavigationbar *)navigationtoolbar;
@end
