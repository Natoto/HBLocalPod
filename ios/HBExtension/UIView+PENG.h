//
//  UIView+PENG.h
//  PENG
//
//  Created by zeno on 15/9/24.
//  Copyright © 2015年 nonato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(PENGPENG)
@property(nonatomic,retain) CALayer * viewtoplayer;
@property(nonatomic,retain) CALayer * viewbottomlayer;
@property(nonatomic,retain) CALayer * viewleftlayer;
@property(nonatomic,retain) CALayer * viewrightlayer;

-(void)cleartopLayer;
-(void)clearviewbottomlayer;
-(void)drawbottomlinelayer;
-(void)drawtoplinelayer;



/**
 *  清除左边部分割线
 */
-(void)clearleftlayer;
-(void)drawleftlayer;
/**
 *  清除右边部分割线
 */
-(void)clearrightlayer;
-(void)drawrightlayer;

//LAYER 圆角
-(void)setlayercolor:(UIColor *)color;
-(void)setcornerRadius:(CGFloat )cornerRadius;
-(void)setppcornerRadius:(CGFloat )cornerRadius;
-(void)setppcornerRadius:(CGFloat )cornerRadius strokeColor:(UIColor *)strokeColor;
+(UIView *)BigButtonview:(CGRect)frame btnframe:(CGRect)buttonFrame title:(NSString *)title target:(id)target sel:(SEL)selector;


-(void)addgradientlayer:(UIColor *)fromcolor tocolor:(UIColor *)tocolor;

-(void)yy_show;
-(void)yy_show:(BOOL)animate;
-(void)yy_hide;

-(void)yy_hide:(BOOL)animate;
@end
