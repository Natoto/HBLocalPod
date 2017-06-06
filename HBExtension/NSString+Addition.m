//
//  NSString+Peng.m
//  PENG
//
//  Created by hb on 15/5/20.
//  Copyright (c) 2016年 yy.com All rights reserved.
//

#import "NSString+Addition.h"
//#import "PENG_Define.h"

#define KT_UIColorWithRGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0f]

//众筹详情 字体颜色
#define PENG_COLOR_DARKGRAY KT_UIColorWithRGB(102, 102, 102)

//倒计时的橙色 255  114 0
#define PENG_COLOR_ORANGE KT_UIColorWithRGB(244, 114, 0)

@implementation NSString(Peng)

/**
 *  获得强调之后的字符串(橙色标注)
 *
 *  @param sourcestring 源字符串
 *  @param string       要强调的字符串
 *
 *  @return 返回attributionstring
 */
+(NSMutableAttributedString *)getStrongAttributionString:(NSMutableAttributedString *)sourcestring
                                               strongstr:(NSString *)string
{
    if (!string) {
        return sourcestring;
    }
    NSMutableAttributedString * attributionstring = sourcestring; //[[NSMutableAttributedString alloc] initWithString:sourcestring];
    NSRange moneyRange = [sourcestring.mutableString rangeOfString:string];
    if (moneyRange.location!= NSNotFound) {
        [attributionstring addAttributes:@{NSForegroundColorAttributeName:PENG_COLOR_ORANGE} range:moneyRange];
        // [UIColor redColor]
    }
    return attributionstring;
}

/**
 *  获得强调之后的字符串(红色标注)
 *
 *  @param sourcestring 源字符串
 *  @param string       要强调的字符串
 *
 *  @return 返回attributionstring
 */
+(NSMutableAttributedString *)getStrongAttributionString:(NSMutableAttributedString *)sourcestring
                                             redColorstr:(NSString *)string
{
    if (!string) {
        return sourcestring;
    }
    NSMutableAttributedString * attributionstring = sourcestring; //[[NSMutableAttributedString alloc] initWithString:sourcestring];
    NSRange moneyRange = [sourcestring.mutableString rangeOfString:string];
    if (moneyRange.location!= NSNotFound) {
        [attributionstring addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:moneyRange];
        // [UIColor redColor]
    }
    return attributionstring;
}
/**
 *  改变文字中某一关键字的颜色
 *
 *  @param sourcestring 原始字符串
 *  @param string       要改变的文字
 *  @param color        要改变的颜色
 *
 *  @return 返回attributionstring
 */
+(NSMutableAttributedString *)getAttributionString:(NSMutableAttributedString *)sourcestring
                                     changedstring:(NSString *)string
                                         withcolor:(UIColor *)color
{
    if (!string) {
        return sourcestring;
    }
    NSMutableAttributedString * attributionstring = sourcestring;
    NSRange moneyRange = [sourcestring.mutableString rangeOfString:string];
    if (moneyRange.location!= NSNotFound) {
        [attributionstring addAttributes:@{NSForegroundColorAttributeName:color} range:moneyRange];
        // [UIColor redColor]
    }
    return attributionstring;
}

/**
 *  获得弱化之后的字符串(灰色标注)
 *
 *  @param sourcestring 源字符串
 *  @param string       要强调的字符串
 *
 *  @return 返回attributionstring
 */
+(NSMutableAttributedString *)getWeakAttributionString:(NSMutableAttributedString *)sourcestring
                                               weakstr:(NSString *)string
{
    if (!string) {
        return sourcestring;
    }
    NSMutableAttributedString * attributionstring = sourcestring; //[[NSMutableAttributedString alloc] initWithString:sourcestring];
    NSRange moneyRange = [sourcestring.mutableString rangeOfString:string];
    if (moneyRange.location!= NSNotFound) {
        [attributionstring addAttributes:@{NSForegroundColorAttributeName:PENG_COLOR_DARKGRAY} range:moneyRange];
    }//[UIColor grayColor]
    return attributionstring;
}

/**
 *  获得改变了字体的字符串
 *
 *  @param sourcestring 原始串
 *  @param string       要改变的字符串
 *  @param font         要改变的字体
 *
 *  @return 返回          NSMutableAttributedString
 */
+(NSMutableAttributedString *)addAttributedString:(NSMutableAttributedString *) sourcestring
                                           string:(NSString *)string
                                         WithFont:(UIFont *)font
{
    if (!string) {
        return sourcestring;
    }
    NSMutableAttributedString * attributionstring = sourcestring; //[[NSMutableAttributedString alloc] initWithString:sourcestring];
    NSRange txtRange = [sourcestring.mutableString rangeOfString:string];
    if (txtRange.location!= NSNotFound) {
        [attributionstring addAttributes:@{NSFontAttributeName:font} range:txtRange];
    }
    return attributionstring;
    
}
/**
 *  获得改变了属性的字符串
 *
 *  @param sourcestring 原始串
 *  @param string       要改变的字符串
 *  @param font         要改变的属性
 *
 *  @return 返回          NSMutableAttributedString
 */
+(NSMutableAttributedString *)addAttributedString:(NSMutableAttributedString *) sourcestring
                                           string:(NSString *)string
                                         WithAttrs:(NSDictionary *)attrs
{
    if (!string) {
        return sourcestring;
    }
    NSMutableAttributedString * attributionstring = sourcestring; //[[NSMutableAttributedString alloc] initWithString:sourcestring];
    NSRange txtRange = [sourcestring.mutableString rangeOfString:string];
    if (txtRange.location!= NSNotFound) {
        [attributionstring addAttributes:attrs range:txtRange];
    }
    return attributionstring;
    
}

/**
 *  改变段落
 *
 *  @param sourcestring   原始串
 *  @param paragraphStyle 段落格式
 *
 *  @return 返回改变后的段落attributionstring
 */
+(NSMutableAttributedString *)addAttributedString:(NSMutableAttributedString *) sourcestring
                               withParagraphStyle:(NSMutableParagraphStyle *)paragraphStyle
{
    [sourcestring addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle} range:(NSMakeRange(0, sourcestring.length))];
    return sourcestring;
    
}
-(NSString *)formatNumberString
{
    if (self.integerValue>10000) {
        CGFloat div = self.integerValue/10000.;
        return [NSString stringWithFormat:@"%.1fw",div];
     }
    else if (self.integerValue>1000) {
         CGFloat div = self.integerValue/1000.;
         return [NSString stringWithFormat:@"%.1fk",div];
     }
    return self;
}

-(NSString *)removeHttpPrefix
{
    NSString * string = [self stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    return string;
}

- (CGFloat)getTextHeightWithWidth:(CGFloat)width font:(CGFloat)fontsize;
{
    //获取当前系统版本
    CGFloat currentVersion = [[UIDevice currentDevice].systemVersion floatValue];
    CGFloat height;
    if (currentVersion >= 7.0)    //系统大于7.0
    {
        //label高度
        height = [self boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontsize] forKey:NSFontAttributeName] context:nil].size.height;
    }
    else
    {
        //label高度
        height = [self sizeWithFont:[UIFont systemFontOfSize:fontsize] constrainedToSize:CGSizeMake(width, 10000)].height;
    }
    return height;
}
@end
