//
//  JSPatch.h
//  JSPatch
//
//  Created by bang on 15/11/14.
//  Copyright (c) 2015 bang. All rights reserved.
//

#import <Foundation/Foundation.h>

//是否经过md5校验
const static int  jp_md5verify = 0;
//
//#if DEBUG
//const static NSString *rootUrl = @"http://7xicym.com1.z0.glb.clouddn.com/debug";
//#else
//const static NSString *rootUrl = @"http://7xicym.com1.z0.glb.clouddn.com/";
//#endif

static NSString *publicKey = @"-----BEGIN PUBLIC KEY-----\nsJM6n7wUShGu1F8V0a4rH+8uYJRyil9en6KCZwvr7AFpsVdh6IKYALQihv7uDO6BwYqbL8PjRrwJsA/R8DQgWjm8S+io70G5yruxcmFnzqz0fMWPSzwehY69Zs87nUDzjHj3nZSyNujQh+BosAml7QUWWv5Qx8fqdpRSQWMVPv0=\n-----END PUBLIC KEY-----";

typedef void (^JPUpdateCallback)(NSError *error);

typedef enum {
    JPUpdateErrorUnzipFailed = -1001,
    JPUpdateErrorVerifyFailed = -1002,
} JPUpdateError;
@interface JPloaderData : NSObject

+ (instancetype)sharedInstance;
@property (nonatomic, strong) NSString * rootUrl;
@property (nonatomic, strong) NSString * patchVersionName;//补丁文件名，最后一个字段
@end

@interface JPLoader : NSObject

+ (BOOL)run;
+ (void)updateToVersion:(NSInteger)version callback:(JPUpdateCallback)callback;
+ (void)updateToVersion:(NSInteger)version ex:(NSString *)ex callback:(JPUpdateCallback)callback;

+ (void)runTestScriptInBundle;
+ (void)setLogger:(void(^)(NSString *log))logger;
+ (NSInteger)currentVersion;
+ (void)clearVersion;
@end
