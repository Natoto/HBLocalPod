//
//  UIButton+PENG.h
//  PENG
//
//  Created by hb on 15/6/8.
//  Copyright (c) 2016年 yy.com All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIBezierButton:UIButton

@end
@interface UIButton(PENGPENG)
@property (nonatomic, strong) UIImage * image;
-(void)setTitle:(NSString *)title;
-(void)setAllTitle:(NSString *)title;
-(void)setSelectedTitle:(NSString *)title;
-(void)setTitleColor:(UIColor *)color;
-(void)setTitleSelectedColor:(UIColor *)color;
-(void)setFont:(UIFont *)font;
//-(void)setlayercolor:(UIColor *)color;
//-(void)setppcornerRadius:(CGFloat )cornerRadius;
-(void)setBackgroundImage:(UIColor *)backgroundColor;
-(void)setSelectBackgroundImage:(UIColor *)backgroundColor;
-(void)setDisableBackgroundImage:(UIColor *)backgroundColor;
//-(void)setcornerRadius:(CGFloat )cornerRadius; 

+ (UIButton *)CreateButtonWithFrame:(CGRect)frame
                             andTxt:(NSString *)TXT
                         buttonType:(UIButtonType)buttonType;

+ (UIButton *)CreateButtonWithFrame:(CGRect)frame;

+ (UIButton *)CreateButtonWithFrame:(CGRect)frame
                           andImage:(UIImage *)image;

+ (UIButton *)CreateButtonWithFrame:(CGRect)frame
                           andimage:(NSString *)imagename;

+ (UIButton *)CreateButtonWithFrame:(CGRect)frame
                             andTxt:(NSString *)TXT;

+ (UIButton *)CreateButtonWithFrame:(CGRect)frame
                             andTxt:(NSString *)TXT
                           txtcolor:(UIColor *)color;


+ (UIButton *)CreateButtonWithFrame:(CGRect)frame
                             andTxt:(NSString *)TXT
                           andImage:(UIImage *)image;


+ (UIButton *)CreateButtonWithFrame:(CGRect)frame
                           andimage:(NSString *)imagename
                        selectImage:(NSString *)selectimage;


+ (UIButton *)CreateButtonWithFrame:(CGRect)frame
                             andTxt:(NSString *)TXT
                           txtcolor:(UIColor *)color
                                tag:(NSInteger)tag
                             target:(id)target
                             action:(SEL)action;


+ (UIButton *)CreateButtonWithFrame:(CGRect)frame
                             andTxt:(NSString *)txt
                         andTxtSize:(NSInteger)txtsize
                           andImage:(UIImage *)image
                        andTXTColor:(UIColor *)txtcolor
                             target:(id)target
                           selector:(SEL)selector
                          superview:(UIView *)superview
                                tag:(NSInteger)tag;
//加下划线
-(void)setUnderlineStyleSingle:(NSString *)text;
@end
