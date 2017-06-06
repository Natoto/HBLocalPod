//
//  HBLabelCell.m
//  hjb
//
//  Created by zeno on 16/3/17.
//  Copyright © 2016年 YY.COM All rights reserved.
//

#import "HBLabelCell.h"
//#import <yytext/YYText.h>
#import <Masonry/Masonry.h>

@implementation HBLabelCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = YES;
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentLeft;
//        label.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        label.numberOfLines = 0;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 5, 5, 5));
        }];
//        label.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) { 
//        };
//        self.highlightTapAction = [label.highlightTapAction copy];
        _label = label;
    }
    return self;
}

-(void)setcelldictionary:(NSMutableDictionary *)dictionary
{
//    [super setcelldictionary:dictionary];
    if (dictionary) {
        
        self.dictionary = dictionary;
        UIColor * bgcolor = [dictionary objectForKey:key_cellstruct_background];
        if ([[bgcolor class] isSubclassOfClass:[UIColor class]]) {
            self.contentView.backgroundColor = bgcolor;
            self.backgroundColor = bgcolor;
        }
        if ([[bgcolor class] isSubclassOfClass:[NSString class]]) {
            NSString * bgcolorstring= [dictionary objectForKey:key_cellstruct_background];
            self.contentView.backgroundColor = [CELL_STRUCT_Common colorWithStructKey:bgcolorstring];
            self.backgroundColor = self.contentView.backgroundColor;
        }
        
        NSString * text_alignstr = [dictionary objectForKey:key_cellstruct_textAlignment];
        if ([text_alignstr isEqualToString:value_cellstruct_textAlignment_center]) {
            self.label.textAlignment = NSTextAlignmentCenter;
//            self.label.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        }

        NSString *textAlignment = [self.dictionary objectForKey:key_cellstruct_textAlignment];
        if (textAlignment) {
            if ([textAlignment isEqualToString:value_cellstruct_textAlignment_left]) {
                self.label.textAlignment = NSTextAlignmentLeft;
            }
            else if ([textAlignment isEqualToString:value_cellstruct_textAlignment_center]) {
                self.label.textAlignment = NSTextAlignmentCenter; 
            }
            else if ([textAlignment isEqualToString:value_cellstruct_textAlignment_right]) {
                self.label.textAlignment = NSTextAlignmentRight;
            }
        }
    }
}

-(void)setcellTitleColor:(NSString *)color
{
    if (color.length) {
        self.label.textColor = [CELL_STRUCT_Common colorWithStructKey:color];
    }
}
-(void)setcellTitleFontsize:(NSNumber *)titleFontsize
{
    if (titleFontsize) {
        self.label.font = [UIFont systemFontOfSize:titleFontsize.floatValue];
    }
}
-(void)setcellTitleFont:(UIFont *)titleFont
{
    if (titleFont) {
        self.label.font = titleFont;
    }
}
-(void)setcellTitle:(NSString *)title
{
    if (title) {
        self.label.text = title;
    }
}

-(void)setcellProfile:(NSString *)profile
{
}

-(void)setcellAttributeTitle:(NSAttributedString *)attributeTitle
{
    if (attributeTitle) {
        self.label.attributedText = attributeTitle;
    }
}
@end

//YYText 用法
//NSMutableAttributedString *text = [NSMutableAttributedString new];
//
//{
//    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"Shadow"];
//    one.yy_font = [UIFont boldSystemFontOfSize:30];
//    one.yy_color = [UIColor whiteColor];
//    YYTextShadow *shadow = [YYTextShadow new];
//    shadow.color = [UIColor colorWithWhite:0.000 alpha:0.490];
//    shadow.offset = CGSizeMake(0, 1);
//    shadow.radius = 5;
//    one.yy_textShadow = shadow;
//    [text appendAttributedString:one];
//    [text appendAttributedString:[self padding]];
//}
//
//{
//    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"Inner Shadow"];
//    one.yy_font = [UIFont boldSystemFontOfSize:30];
//    one.yy_color = [UIColor whiteColor];
//    YYTextShadow *shadow = [YYTextShadow new];
//    shadow.color = [UIColor colorWithWhite:0.000 alpha:0.40];
//    shadow.offset = CGSizeMake(0, 1);
//    shadow.radius = 1;
//    one.yy_textInnerShadow = shadow;
//    [text appendAttributedString:one];
//    [text appendAttributedString:[self padding]];
//}
//
//{
//    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"Multiple Shadows"];
//    one.yy_font = [UIFont boldSystemFontOfSize:30];
//    one.yy_color = [UIColor colorWithRed:1.000 green:0.795 blue:0.014 alpha:1.000];
//    
//    YYTextShadow *shadow = [YYTextShadow new];
//    shadow.color = [UIColor colorWithWhite:0.000 alpha:0.20];
//    shadow.offset = CGSizeMake(0, -1);
//    shadow.radius = 1.5;
//    YYTextShadow *subShadow = [YYTextShadow new];
//    subShadow.color = [UIColor colorWithWhite:1 alpha:0.99];
//    subShadow.offset = CGSizeMake(0, 1);
//    subShadow.radius = 1.5;
//    shadow.subShadow = subShadow;
//    one.yy_textShadow = shadow;
//    
//    YYTextShadow *innerShadow = [YYTextShadow new];
//    innerShadow.color = [UIColor colorWithRed:0.851 green:0.311 blue:0.000 alpha:0.780];
//    innerShadow.offset = CGSizeMake(0, 1);
//    innerShadow.radius = 1;
//    one.yy_textInnerShadow = innerShadow;
//    
//    [text appendAttributedString:one];
//    [text appendAttributedString:[self padding]];
//}
//
////    {
////        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"Background Image"];
////        one.yy_font = [UIFont boldSystemFontOfSize:30];
////        one.yy_color = [UIColor colorWithRed:1.000 green:0.795 blue:0.014 alpha:1.000];
////
////        CGSize size = CGSizeMake(20, 20);
////        UIImage *background = [UIImage yy_imageWithSize:size drawBlock:^(CGContextRef context) {
////            UIColor *c0 = [UIColor colorWithRed:0.054 green:0.879 blue:0.000 alpha:1.000];
////            UIColor *c1 = [UIColor colorWithRed:0.869 green:1.000 blue:0.030 alpha:1.000];
////            [c0 setFill];
////            CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
////            [c1 setStroke];
////            CGContextSetLineWidth(context, 2);
////            for (int i = 0; i < size.width * 2; i+= 4) {
////                CGContextMoveToPoint(context, i, -2);
////                CGContextAddLineToPoint(context, i - size.height, size.height + 2);
////            }
////            CGContextStrokePath(context);
////        }];
////        one.yy_color = [UIColor colorWithPatternImage:background];
////
////        [text appendAttributedString:one];
////        [text appendAttributedString:[self padding]];
////    }
//
//{
//    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"Border"];
//    one.yy_font = [UIFont boldSystemFontOfSize:30];
//    one.yy_color = [UIColor colorWithRed:1.000 green:0.029 blue:0.651 alpha:1.000];
//    
//    YYTextBorder *border = [YYTextBorder new];
//    border.strokeColor = [UIColor colorWithRed:1.000 green:0.029 blue:0.651 alpha:1.000];
//    border.strokeWidth = 3;
//    border.lineStyle = YYTextLineStylePatternCircleDot;
//    border.cornerRadius = 3;
//    border.insets = UIEdgeInsetsMake(0, -4, 0, -4);
//    one.yy_textBackgroundBorder = border;
//    
//    [text appendAttributedString:[self padding]];
//    [text appendAttributedString:one];
//    [text appendAttributedString:[self padding]];
//    [text appendAttributedString:[self padding]];
//    [text appendAttributedString:[self padding]];
//    [text appendAttributedString:[self padding]];
//}
//
//{
//    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"Link"];
//    one.yy_font = [UIFont boldSystemFontOfSize:30];
//    one.yy_color = [UIColor colorWithRed:0.093 green:0.492 blue:1.000 alpha:1.000];
//    one.yy_underlineColor = one.yy_color;
//    one.yy_underlineStyle = NSUnderlineStyleSingle;
//    
//    YYTextBorder *border = [YYTextBorder new];
//    border.cornerRadius = 3;
//    border.insets = UIEdgeInsetsMake(0, -4, 0, -4);
//    border.fillColor = [UIColor colorWithWhite:0.000 alpha:0.220];
//    
//    YYTextHighlight *highlight = [YYTextHighlight new];
//    [highlight setBorder:border];
//    highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
//        [_self showMessage:[NSString stringWithFormat:@"Tap: %@",[text.string substringWithRange:range]]];
//    };
//    [one yy_setTextHighlight:highlight range:one.yy_rangeOfAll];
//    
//    [text appendAttributedString:one];
//    [text appendAttributedString:[self padding]];
//}
//
//{
//    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"Another Link"];
//    one.yy_font = [UIFont boldSystemFontOfSize:30];
//    one.yy_color = [UIColor redColor];
//    
//    YYTextBorder *border = [YYTextBorder new];
//    border.cornerRadius = 50;
//    border.insets = UIEdgeInsetsMake(0, -10, 0, -10);
//    border.strokeWidth = 0.5;
//    border.strokeColor = one.yy_color;
//    border.lineStyle = YYTextLineStyleSingle;
//    one.yy_textBackgroundBorder = border;
//    
//    YYTextBorder *highlightBorder = border.copy;
//    highlightBorder.strokeWidth = 0;
//    highlightBorder.strokeColor = one.yy_color;
//    highlightBorder.fillColor = one.yy_color;
//    
//    YYTextHighlight *highlight = [YYTextHighlight new];
//    [highlight setColor:[UIColor whiteColor]];
//    [highlight setBackgroundBorder:highlightBorder];
//    highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
//        [_self showMessage:[NSString stringWithFormat:@"Tap: %@",[text.string substringWithRange:range]]];
//    };
//    [one yy_setTextHighlight:highlight range:one.yy_rangeOfAll];
//    
//    [text appendAttributedString:one];
//    [text appendAttributedString:[self padding]];
//}
//
//{
//    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"Yet Another Link"];
//    one.yy_font = [UIFont boldSystemFontOfSize:30];
//    one.yy_color = [UIColor whiteColor];
//    
//    YYTextShadow *shadow = [YYTextShadow new];
//    shadow.color = [UIColor colorWithWhite:0.000 alpha:0.490];
//    shadow.offset = CGSizeMake(0, 1);
//    shadow.radius = 5;
//    one.yy_textShadow = shadow;
//    
//    YYTextShadow *shadow0 = [YYTextShadow new];
//    shadow0.color = [UIColor colorWithWhite:0.000 alpha:0.20];
//    shadow0.offset = CGSizeMake(0, -1);
//    shadow0.radius = 1.5;
//    YYTextShadow *shadow1 = [YYTextShadow new];
//    shadow1.color = [UIColor colorWithWhite:1 alpha:0.99];
//    shadow1.offset = CGSizeMake(0, 1);
//    shadow1.radius = 1.5;
//    shadow0.subShadow = shadow1;
//    
//    YYTextShadow *innerShadow0 = [YYTextShadow new];
//    innerShadow0.color = [UIColor colorWithRed:0.851 green:0.311 blue:0.000 alpha:0.780];
//    innerShadow0.offset = CGSizeMake(0, 1);
//    innerShadow0.radius = 1;
//    
//    YYTextHighlight *highlight = [YYTextHighlight new];
//    [highlight setColor:[UIColor colorWithRed:1.000 green:0.795 blue:0.014 alpha:1.000]];
//    [highlight setShadow:shadow0];
//    [highlight setInnerShadow:innerShadow0];
//    [one yy_setTextHighlight:highlight range:one.yy_rangeOfAll];
//    
//    [text appendAttributedString:one];
//}
