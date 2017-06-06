//
//  NSString+Peng.h
//  PENG
//
//  Created by hb on 15/5/20.
//  Copyright (c) 2016年 yy.com All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Peng)

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
                                         withcolor:(UIColor *)color;

/**
 *  获得强调之后的字符串(红色标注)
 *
 *  @param sourcestring 源字符串
 *  @param string       要强调的字符串
 *
 *  @return 返回attributionstring
 */
+(NSMutableAttributedString *)getStrongAttributionString:(NSMutableAttributedString *)sourcestring strongstr:(NSString *)string;


/**
 *  获得弱化之后的字符串(灰色标注)
 *
 *  @param sourcestring 源字符串
 *  @param string       要强调的字符串
 *
 *  @return 返回attributionstring
 */
+(NSMutableAttributedString *)getWeakAttributionString:(NSMutableAttributedString *)sourcestring weakstr:(NSString *)string;
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
                                                  WithFont:(UIFont *)font;


/**
 *  改变段落
 *
 *  @param sourcestring   原始串
 *  @param paragraphStyle 段落格式
 *
 *  @return 返回改变后的段落attributionstring
 */
+(NSMutableAttributedString *)addAttributedString:(NSMutableAttributedString *) sourcestring
                               withParagraphStyle:(NSMutableParagraphStyle *)paragraphStyle;

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
                                        WithAttrs:(NSDictionary *)attrs;

-(NSString *)removeHttpPrefix;

/**
 *  格式化数字string 如1.2k
 *
 *  @param string 原始string
 *
 *  @return 返回格式化后的
 */
-(NSString *)formatNumberString;

- (CGFloat)getTextHeightWithWidth:(CGFloat)width font:(CGFloat)fontsize;

+(NSMutableAttributedString *)getStrongAttributionString:(NSMutableAttributedString *)sourcestring redColorstr:(NSString *)string;
@end
