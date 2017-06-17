//
//  UILabel+PENG.m
//  PENG
//
//  Created by hb on 15/6/8.
//  Copyright (c) 2016年 yy.com All rights reserved.
//

#import "UILabel+PENG.h"
#import "NIAttributedLabel.h"
@implementation UILabel(PENG)
 
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = label.textAlignment;
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}

+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = label.textAlignment;
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}

+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = label.textAlignment;
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}


+ (UILabel *)CreateLabelWithFrame:(CGRect)frame andTxt:(NSString *)TXT
{
    return [UILabel CreateLabelWithFrame:frame andTxt:TXT fontsize:15.0];
}

+ (UILabel *)CreateLabelWithFrame:(CGRect)frame andTxt:(NSString *)TXT fontsize:(NSUInteger)size
{
    UILabel *label=[[UILabel alloc] initWithFrame:frame];
    label.text=TXT;
    label.font=[UIFont systemFontOfSize:size];
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor blackColor];
    label.textAlignment=NSTextAlignmentCenter;
    return label;
}

+ (NIAttributedLabel *)CreateNIAttributedLabelWithFrame:(CGRect)frame andTxt:(NSString *)TXT fontsize:(NSUInteger)size
{
    NIAttributedLabel *label=[[NIAttributedLabel alloc] initWithFrame:frame];
    label.text=TXT;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font=[UIFont systemFontOfSize:size];
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor blackColor];
    label.textAlignment=NSTextAlignmentLeft;
    return label;
}

+(CGFloat)heightOfNIAttributedLabel:(NSString *)contentstr withwidth:(CGFloat)WIDTH_CONTENT fontsize:(NSUInteger)FONT_SIZE_LABEL
{
    
    static NIAttributedLabel* contentLabel = nil;
    if (!contentLabel) {
        contentLabel = [UILabel CreateNIAttributedLabelWithFrame:CGRectZero andTxt:contentstr fontsize:FONT_SIZE_LABEL];
        CGRect frame = contentLabel.frame;
        frame.size.width = WIDTH_CONTENT;
        contentLabel.frame = frame;
    }
    else {
        // reuse contentLabel and reset frame, it's great idea from my mind
        contentLabel.frame = CGRectZero;
        CGRect frame = contentLabel.frame;
        frame.size.width = WIDTH_CONTENT;
        contentLabel.frame = frame;
    }
    contentLabel.text = contentstr;
    
    CGSize contentSize = [contentLabel sizeThatFits:CGSizeMake(WIDTH_CONTENT, CGFLOAT_MAX)];
    
    return  contentSize.height;
}


@end
