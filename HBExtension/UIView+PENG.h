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



/**
 * 假设要加载的Class为MyNibView,
 xib中必须将File Owner设置成NSObject而非MyNibView！这里我还不是很清楚什么原因，估计是由于Nib的file owner为nil或者其他值
 将顶层的UIView的class设置成MyNibView，并通过他设置IBOutlet的映射关系。
 顶层的UIView则会被加载后放到数组的第一个位置。
 */
+ (id)viewFromNib;


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
