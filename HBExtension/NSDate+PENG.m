//
//  NSDate+PENG.m
//  PENG
//
//  Created by hb on 15/6/8.
//  Copyright (c) 2016年 yy.com All rights reserved.
//

#import "NSDate+PENG.h"
#import "NSDate+HBExtension.h"

@implementation NSDate(PENG)

+(NSString *)formatDateStringFromObject:(id)dateobject
{
    NSString * timestring;
    if ([[dateobject class] isSubclassOfClass:[NSDate class]]) {
        NSDate * adate = (NSDate *)dateobject;
        timestring  = [NSString stringWithFormat:@"%.0f",adate.timeIntervalSince1970];
    }
    else if ([[dateobject class] isSubclassOfClass:[NSString class]] || [[dateobject class] isSubclassOfClass:[NSNumber class]])
    {
        timestring  = [NSString stringWithFormat:@"%@",dateobject];
    }
    return timestring;
}

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });
    return dateFormatter;
}

+ (NSString *)dateStringfromdate:(NSDate *)date
{
    NSDateFormatter *formatter = [NSDate dateFormatter];//[[NSDateFormatter alloc] init] ;
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = date;
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+ (NSString *)datefromstring:(NSString *)timestr
{
    NSDateFormatter *formatter = [NSDate dateFormatter];//[[NSDateFormatter alloc] init] ;
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestr longLongValue]];
    NSString *confromTimespStr =[confromTimesp timeAgo]; // [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+ (NSString *)datefromstring2:(NSString *)timestr
{
    NSDateFormatter *formatter = [NSDate dateFormatter];// [[NSDateFormatter alloc] init] ;
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = [NSDate date];
    if (timestr) {
        confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestr  longLongValue]];
    }
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}
 

+ (NSString *)datefromstring:(NSString *)timestr formate:(NSString *)formate
{
//    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
//    [formatter setDateFormat:formate];
//    NSDate * date =[NSDate dateWithTimeIntervalSince1970:[timestr longLongValue]];
//    NSString * timeNow = [formatter stringFromDate:date];
//     return timeNow;
    
    NSDateFormatter *formatter = [NSDate dateFormatter];//[[NSDateFormatter alloc] init] ;
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formate];
    NSDate *confromTimesp = [NSDate date];
    if (timestr) {
        confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestr.doubleValue];
        // [NSDate dateWithTimeIntervalSince1970:[timestr  longLongValue]];
    }
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}
+ (NSString *)datefromstringWithDate:(NSDate *)date
{
    NSDateFormatter *formatter = [NSDate dateFormatter];// [[NSDateFormatter alloc] init] ;
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = [NSDate date];
    if (date) {
        confromTimesp = date; //[NSDate dateWithTimeIntervalSince1970:[timestr  longLongValue]];
    }
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+ (NSString *)datefromstringWithDate:(NSDate *)date format:(NSString *)formatestring
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatestring];
    NSDate *confromTimesp = [NSDate date];
    if (date) {
        confromTimesp = date; //[NSDate dateWithTimeIntervalSince1970:[timestr  longLongValue]];
    }
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}
/**
 *  从字符串转为date
 *
 *  @param datestring  2016-05-20 11:05:34
 *  @param formatestr @"YYYY-MM-dd HH:mm:ss"];
 *
 *  @return nadate
 */
+ (NSDate *)getNSDatefromstringWithstring:(NSString *)datestring formate:(NSString *)formatestr
{
    NSDateFormatter *formatter = [NSDate dateFormatter];//[[NSDateFormatter alloc] init] ;
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatestr];//@"YYYY-MM-dd HH:mm:ss"];
    NSDate * date = [formatter dateFromString:datestring];
    return date;
}

+ (NSString *)datefromstring3:(NSString *)timestr
{
    NSDateFormatter *formatter = [NSDate dateFormatter];//[[NSDateFormatter alloc] init] ;
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSDate *confromTimesp = [NSDate date];
    if (timestr) {
        confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestr  longLongValue]];
    }
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+ (NSString *)datefromstring4:(NSString *)timestr
{
    NSDateFormatter *formatter = [NSDate dateFormatter];// [[NSDateFormatter alloc] init] ;
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestr longLongValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+ (NSString *)datefromstring5:(NSString *)timestr
{
    NSDateFormatter *formatter = [NSDate dateFormatter];// [[NSDateFormatter alloc] init] ;
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestr longLongValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+(NSString *)nowstring
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];//转为字符型
    return timeString;
}

+(NSString *)now_ss_string
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];//转为字符型
    return timeString;
}

+ (NSString *)datefromstringFromNow
{
    NSDateFormatter *formatter = [NSDate dateFormatter];//[[NSDateFormatter alloc] init] ;
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSDate *confromTimesp = [NSDate date];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}


+ (NSString *)lessSecondToHHMMSS:(NSUInteger)seconds
{
    //    NSUInteger day  = (NSUInteger)seconds/(24*3600);
    NSUInteger hour = (NSUInteger)(seconds%(24*3600))/3600;
    NSUInteger min  = (NSUInteger)(seconds%(3600))/60;
    NSUInteger second = (NSUInteger)(seconds%60);
    
    NSString *time = [NSString stringWithFormat:@"%lu时%lu分%lu秒",(unsigned long)hour,(unsigned long)min,(unsigned long)second];
    return time;
    
}
+(NSString *)lessSecondToHHMM:(NSUInteger)seconds
{
    //    NSUInteger day  = (NSUInteger)seconds/(24*3600);
    NSUInteger hour = (NSUInteger)(seconds%(24*3600))/3600;
    NSUInteger min  = (NSUInteger)(seconds%(3600))/60;
    NSUInteger second = (NSUInteger)(seconds%60);
    
    NSString *time = [NSString stringWithFormat:@"%lu时%lu分",(unsigned long)hour,(unsigned long)min];
    return time;
    
}

/**
 *  根据日期获取当月最后一天
 *
 */
+(NSString *)getMonthLastDay:(NSDate *)theDate
{
    NSDate *newDate= theDate;
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }
    NSDateFormatter *myDateFormatter = [NSDate dateFormatter];//[[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyy-MM-dd"];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    return endString;
}


/**
 *  根据日期获取当月第一天
 *
 */
+(NSString *)getMonthFirstDay:(NSDate *)theDate
{
    NSDate *newDate= theDate;
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }
    NSDateFormatter *myDateFormatter = [NSDate dateFormatter];//[[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyy-MM-dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    return beginString;
}

/**
 如何判断两个时间是否是同一天
 */
+ (BOOL)isCurrentDay:(NSDate *)aDate
{
    if (aDate==nil) return NO;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:aDate];
    NSDate *otherDate = [cal dateFromComponents:components];
    if([today isEqualToDate:otherDate])
        return YES;
    
    return NO;
}
@end
