//
//  UILabel+PENG.h
//  PENG
//
//  Created by hb on 15/6/8.
//  Copyright (c) 2016年 yy.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIAttributedLabel.h"

@interface UILabel(PENG)

+ (UILabel *)CreateLabelWithFrame:(CGRect)frame andTxt:(NSString *)TXT;
+ (UILabel *)CreateLabelWithFrame:(CGRect)frame andTxt:(NSString *)TXT fontsize:(NSUInteger)size;

+ (NIAttributedLabel *)CreateNIAttributedLabelWithFrame:(CGRect)frame andTxt:(NSString *)TXT fontsize:(NSUInteger)size;

+(CGFloat)heightOfNIAttributedLabel:(NSString *)contentstr withwidth:(CGFloat)WIDTH_CONTENT fontsize:(NSUInteger)FONT_SIZE_LABEL;
@end
