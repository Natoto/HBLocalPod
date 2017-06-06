//
//  NSAttributedString+AttributedStringWithHTML.m
//  AttributedStringWithHTML
//
//  Created by boob on 16/5/17.
//  Copyright © 2016年 boob. All rights reserved.
//

#import "NSAttributedString+AttributedStringWithHTML.h"
#import <UIKit/UIKit.h>
//#import "AshtonHTMLReader.h"
@implementation NSAttributedString (AttributedStringWithHTML)


/**
 http://kindeditor.net/ke4/examples/default.html
 *  将HTML标签转换为attributeString
 *  sp:
 * <strong><em><span style="color:#006600;font-size:10px;">HELLO</span></em></strong> <span style="font-size:16px;">WORLD</span>
 *  注意：如果有中文乱码的问题加上 <meta charset=\"UTF-8\">
 *  font-family:Helvetica;
 */
//[NSString stringWithFormat:@"<span style=\"color:#60D978;font-size:15px;\">%@</span>",string];

- (NSAttributedString *)attributedStringWithHTML:(NSString *)HTML {
   
    
   return  [[NSAttributedString alloc] initWithData:[HTML dataUsingEncoding:NSUTF8StringEncoding]
                                            options:@{
                                                      NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                      NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                          documentAttributes:nil error:nil];

}


//TODO: 耗时代码
+ (NSAttributedString *)attributedStringWithHTML:(NSString *)HTML {
    
    NSAttributedString * attringstring;
    @try {
        
        NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType
                                  };
       attringstring = [[NSAttributedString alloc] initWithData:[HTML dataUsingEncoding:NSUTF8StringEncoding] options:options documentAttributes:NULL error:NULL];
    }
    @catch (NSException *exception) {
        NSLog(@"🙅 转换错误~~ %@",exception.description);
    }
    return attringstring;
}

@end


//NSString *pattern = @"(color:#\\w{1,})";
//NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
////    BOOL isMatch = [pred evaluateWithObject:HTML];
////    if (isMatch) {
//NSString * colorstr ;
//NSRange   resultrange;
//NSError * error;
//NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
//
//NSArray<NSTextCheckingResult *> *result = [regex matchesInString:HTML options:0 range:NSMakeRange(0, HTML.length)];
//if (result) {
//    for (int i = 0; i<result.count; i++) {
//        NSTextCheckingResult *res = result[i];
//        NSLog(@"str == %@", [HTML substringWithRange:res.range]);
//        colorstr = [HTML substringWithRange:res.range];
//        resultrange = res.range;
//    }
//}else{
//    NSLog(@"error == %@",error.description);
//}
//if (colorstr) {
//    NSString * rgbvaluestr = [colorstr substringFromIndex:7];
//    long long rgbValue = rgbvaluestr.longLongValue;
//    int red = (int)((rgbValue & 0xFF0000) >> 16);///255.0;
//    int green = (int)((rgbValue & 0xFF00) >> 8);///255.0;
//    int blue = (int)((rgbValue & 0xFF));///255.0;
//    
//    //scanner.scanLocation;
//    NSString * substr = [NSString stringWithFormat:@"color: rgba(%d, %d, %d, 1.000)",red,green,blue];
//    HTML = [HTML stringByReplacingCharactersInRange:resultrange withString:substr];
//}
////    }
//return [[AshtonHTMLReader HTMLReader] attributedStringFromHTMLString:HTML]; //attringstring;
