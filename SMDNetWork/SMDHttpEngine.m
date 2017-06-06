//
//  HJBPayHttpEngine.m
//  HJBPaySDK
//
//  Created by boob on 16/9/26.
//  Copyright © 2016年 YY.COM. All rights reserved.
//

#import "SMDHttpEngine.h"
//#import "NSObject+ObjectMap.h"
#import <CommonCrypto/CommonCrypto.h>
@interface NSString(urlencode)
- (NSString *)smd_urlencoding;
- (NSString *)smd_urldecoding;
@end

@implementation SMDHttpEngine
+ (instancetype)sharedInstance {
    static SMDHttpEngine *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[SMDHttpEngine alloc] init];
        _sharedClient.requestSerializer.timeoutInterval = 20;//设置超时时间20秒
        _sharedClient.securityPolicy = [AFSecurityPolicy defaultPolicy];
        _sharedClient.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
          
//        _sharedClient.operationQueue = [[NSOperationQueue alloc] init];
//        _sharedClient.shouldUseCredentialStorage = YES;
        // 设置请求格式
//        _sharedClient.requestSerializer = [HBJSONRequestSerializer serializer];
        // 设置返回格式
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        [_sharedClient.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
        [_sharedClient.requestSerializer setValue:[NSString stringWithFormat:@"%@", [[NSLocale preferredLanguages] componentsJoinedByString:@", "]] forHTTPHeaderField:@"Accept-Language"];
    });
    return _sharedClient;
}


-(NSString *)getrequesturlwith:(NSString *)urlkey{
    
    NSString * urlstring;
    BOOL havehttp = ([urlkey hasPrefix:@"http://"] || [urlkey hasPrefix:@"https://"]);
    if (self.m_baseurl && !havehttp) {
        urlstring = [NSString stringWithFormat:@"%@/%@",self.m_baseurl,urlkey];\
    }else
    {
        urlstring = [NSString stringWithFormat:@"%@",urlkey];
    }
    return urlstring;
}

-(void)req_post_url:(NSString *)urlkey
              prama:(NSDictionary *)prama
          response:(void (^)(NSString * jsonstring))response
      errorHandler:(void (^)(NSError * err))error
{
    [self req_post_url:urlkey prama:prama responsedata:^(NSData *jsondata) {
                NSString *responsejson = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
                response(responsejson);
    } errorHandler:^(NSError *err) {
        error(err);
    }];
}

-(void)req_post_url:(NSString *)urlkey
              prama:(NSDictionary *)prama
       responsedata:(void (^)(NSData * jsondata))response
       errorHandler:(void (^)(NSError * err))err
{
    NSString * urlstring = [NSString stringWithFormat:@"%@",[self getrequesturlwith:urlkey]];\
    NSLog(@"\n%@",urlstring);\
    
    [self POST:urlstring parameters:prama progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        response(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        NSDictionary *userInfo = @{ AFNetworkingReachabilityNotificationStatusItem: @([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) };
        [notificationCenter postNotificationName:AFNetworkingReachabilityDidChangeNotification object:nil userInfo:userInfo];
       
        NSLog(@"%@",error.description);
        err(error);\
    }];
}

-(void)req_get_url:(NSString *)urlkey
           response:(void (^)(NSString * jsonstring))response
       errorHandler:(void (^)(NSError * err))err
{
    NSString * urlstring = [NSString stringWithFormat:@"%@",[self getrequesturlwith:urlkey]];\
    NSLog(@"\n%@",urlstring);\
    
    [self GET:urlstring parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
         NSString *responsejson = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        response(responsejson);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        NSDictionary *userInfo = @{ AFNetworkingReachabilityNotificationStatusItem: @([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) };
        [notificationCenter postNotificationName:AFNetworkingReachabilityDidChangeNotification object:nil userInfo:userInfo];
        err(error);\
    }];
}


-(void)req_get_url:(NSString *)urlkey
             prama:(NSDictionary *)prama
      responsedata:(void (^)(NSData * jsondata))response
      errorHandler:(void (^)(NSError * err))err
{
    NSString * urlstring = [NSString stringWithFormat:@"%@",[self getrequesturlwith:urlkey]];\
    NSLog(@"\n%@",urlstring);\
    
    [self GET:urlstring parameters:prama progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        response(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        NSDictionary *userInfo = @{ AFNetworkingReachabilityNotificationStatusItem: @([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) };
        [notificationCenter postNotificationName:AFNetworkingReachabilityDidChangeNotification object:nil userInfo:userInfo];
        err(error);\
    }];
    
}

@end

@implementation NSString(urlencode)

- (NSString *)smd_urlencoding
{
    NSString * result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault,
                                                                                              (CFStringRef)self,
                                                                                              NULL,
                                                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                              kCFStringEncodingUTF8 ));
    return result ;
}

- (NSString *)smd_urldecoding
{
    NSMutableString * string = [NSMutableString stringWithString:self];
    [string replaceOccurrencesOfString:@"+"
                            withString:@" "
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [string length])];
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
