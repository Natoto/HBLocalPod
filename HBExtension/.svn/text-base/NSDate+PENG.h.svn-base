//
//  NSDate+PENG.h
//  PENG
//
//  Created by hb on 15/6/8.
//  Copyright (c) 2016年 yy.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Category.h"

@interface NSDate(PENG)

+ (NSString *)formatDateStringFromObject:(id)dateobject;
+ (NSString *)datefromstringFromNow;
+ (NSString *)dateStringfromdate:(NSDate *)date;
+ (NSString *)datefromstring:(NSString *)timestr;
+ (NSString *)datefromstring2:(NSString *)timestr;
+ (NSString *)datefromstring3:(NSString *)timestr;
+ (NSString *)datefromstring4:(NSString *)timestr;
+ (NSString *)datefromstring5:(NSString *)timestr;

+ (NSString *)datefromstring:(NSString *)timestr formate:(NSString *)formate;

+ (NSString *)datefromstringWithDate:(NSDate *)date;

+ (NSString *)datefromstringWithDate:(NSDate *)date format:(NSString *)formatestring;
/**
 * 精确到毫秒
 *
 *  @return 字符串
 */
+(NSString *)nowstring;
/**
 * 精确到秒
 *
 *  @return 字符串
 */
+(NSString *)now_ss_string;
/**
 如何判断两个时间是否是同一天
 */
+ (BOOL)isCurrentDay:(NSDate *)aDate;


/**
 *  根据日期获取当月最后一天
 *
 */
+(NSString *)getMonthLastDay:(NSDate *)theDate;

/**
 *  根据日期获取当月第一天
 *
 */
+(NSString *)getMonthFirstDay:(NSDate *)theDate;


/**
 *  从字符串转为date
 *
 *  @param datestring
 *  @param formatestr
 *
 *  @return nadate
 */
+ (NSDate *)getNSDatefromstringWithstring:(NSString *)datestring formate:(NSString *)formatestr;


+ (NSString *)lessSecondToHHMMSS:(NSUInteger)seconds;
+(NSString *)lessSecondToHHMM:(NSUInteger)seconds;
@end
