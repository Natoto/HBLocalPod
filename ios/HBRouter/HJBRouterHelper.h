//
//  HJBRouterHelper.h
//  hjb
//
//  Created by BooB on 16/3/15.
//  Copyright © 2016年 YY.COM All rights reserved.
//

#import <Foundation/Foundation.h>
@interface HJBRouterHelper:NSObject
+(void)initHBRouterWithRoot:(UIViewController *)mainNavigationctr;
@end

@interface UIViewController(HJBRouterHelper)

-(void)openURLString:(NSString *)URLString
        forKeyAndNib:(NSString *)key
          parameters:(NSDictionary *)parameters;

-(void)openURLString:(NSString *)URLString
              forkey:(NSString *)key
          parameters:(NSDictionary *)parameters;

+(void)openURLString:(NSString *)URLString forkey:(NSString *)key parameters:(NSDictionary *)parameters;
+(void)openForkey:(NSString *)key  blockViewController:(UIViewController *(^)(void))block ;

-(void)openForkey:(NSString *)key  blockViewController:(UIViewController *(^)(void))block;
 
-(void)openURLString:(NSString *)URLString forkey:(NSString *)key parameters:(NSDictionary *)parameters animate:(BOOL)animate;

@end
