//
//  CacheCenter.m
//  JXL
//
//  Created by BooB on 15-4-20.
//  Copyright (c) 2015年 BooB. All rights reserved.
//

#import "CacheCenter.h"
#import <CommonCrypto/CommonCrypto.h>
//#import "NSString+HBExtension.h"
#if __has_include("YYCache.h")
#import "YYCache.h"
#else if __has_include(<YYCache/YYCache.h>)
#import <YYCache/YYCache.h>
#endif

#define USE_YYCACHE  1

@interface NSString (hbcache)

@end
@implementation NSString(hbcache)

//md5 32位 加密 （小写）
- (NSString*)md532BitLower
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );
    
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

@end

@interface CacheCenter()
@property(nonatomic,retain) NSMutableArray * signalNames;
@property(nonatomic,retain) YTKKeyValueStore *store;
@property (nonatomic, strong) NSString * appvision;

@property (nonatomic, strong) YYDiskCache * yycache;
@end

@implementation CacheCenter

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(YYDiskCache *)yycache{
    if (!_yycache) {
        NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject];
        basePath = [basePath stringByAppendingPathComponent:@"smd"];
        YYDiskCache *yy = [[YYDiskCache alloc] initWithPath:[basePath stringByAppendingPathComponent:@"yy"]];
        _yycache = yy;
    }
    return _yycache;
}
static NSString * hjb_appvision() {
    static NSString * appvision;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appvision = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    });
    return appvision;
}

-(YTKKeyValueStore *)store
{
    if (!_store) {
        YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"smdjson.db"];
        _store = store;
    }
    return _store;
}
/**
 *  保存JSON到数据库
 *
 *  @param jsonstring json串
 *  @param tableName  数据库表名
 *  @param key        表中的字段
 */
-(void)saveJSON:(NSString *)jsonstring ForTableName:(NSString *)tableName Key:(NSString *)key
{
    [self.store createTableWithName:tableName];
    [self.store putString:jsonstring withId:key intoTable:tableName];
}

-(NSString *)getJSONForTableName:(NSString *)tableName key:(NSString *)key
{
    NSString * jsonstring = [self.store getStringById:key fromTable:tableName];
    return  jsonstring;
}

-(id)readNSUserDefaultObjectForKey:(NSString *)key
{ 
    key = [CacheCenter fullKey:key fixkey:nil];
    id object = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return object;
}

-(void)setNSUserDefaultObject:(id)object forKey:(NSString *)key
{
    key = [CacheCenter fullKey:key fixkey:nil];
    @try {
        if (object)
        {
            [[NSUserDefaults standardUserDefaults]  setObject:object forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if (object && ![self.signalNames containsObject:key])
        {
            [self.signalNames addObject:key];
            [[NSUserDefaults standardUserDefaults] setObject:self.signalNames forKey:@"signalNames"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if (!object)
        {//为空就移除
            [[NSUserDefaults standardUserDefaults]  removeObjectForKey:key];
            [[NSUserDefaults standardUserDefaults]  synchronize];
            if ([self.signalNames containsObject:key])
            {
                [self.signalNames removeObject:key];
                [[NSUserDefaults standardUserDefaults] setObject:self.signalNames forKey:@"signalNames"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

-(id)readObject:(NSString *)key
{
    key = [CacheCenter fullKey:key fixkey:[CacheCenter curpostfix]];
#if USE_YYCACHE //#warning： 继承的基类的属性读取不到
    id object = [self.yycache objectForKey:key];
#else
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    id object = [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
#endif
    return object;
}

#warning 存在内测问题 建议用yycache
-(void)saveObject:(id)object forkey:(NSString *)key
{
    if(!key) return;
    key = [CacheCenter fullKey:key fixkey:[CacheCenter curpostfix]];
    if (object && key) {
#if USE_YYCACHE
        [self.yycache  setObject:object forKey:key withBlock:^{
            NSLog(@"%@ save success",key);
        }];
#else
        NSData *archiveCarPriceData = [NSKeyedArchiver archivedDataWithRootObject:object];
        [[NSUserDefaults standardUserDefaults] setObject:archiveCarPriceData forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
#endif

    }
    if (![self.signalNames containsObject:key]) {
        if(!key) return;
        [self.signalNames addObject:key];
        [[NSUserDefaults standardUserDefaults] setObject:self.signalNames forKey:@"signalNames"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if (!object && key) {//为空就移除
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        if ([self.signalNames containsObject:key]) {
            [self.signalNames removeObject:key];
            [[NSUserDefaults standardUserDefaults] setObject:self.signalNames forKey:@"signalNames"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
}
-(void)removeObjectForKey:(NSString *)key
{
    [self removeObject:key postfix:[CacheCenter curpostfix]];
}

-(void)removeObject:(NSString *)key postfix:(NSString *)postfix
{
    key = [CacheCenter fullKey:key fixkey:postfix];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
#if USE_YYCACHE
    [self.yycache removeObjectForKey:key];
#endif
}

+(NSString *)fullKey:(NSString *)key fixkey:(NSString *)fixkey
{
    NSString * allkey  = nil;
    if (fixkey) {
        allkey = [NSString stringWithFormat:@"%@_%@_%@",key,fixkey,hjb_appvision()];
    }
    else
    {
        allkey = [NSString stringWithFormat:@"%@_%@",key,hjb_appvision()];
    }
    //TODO:安全性处理
    allkey = [key md532BitLower];
    return allkey;
}

+(NSString *)curpostfix
{
    return @"_smd_";
}

//发送清除历史缓存通知
-(void)removePreUserData:(NSString *)username
{
    if (!username || ![username isEqualToString:[CacheCenter curpostfix]])
    {//切换账号的时候清除所有的用户消息
        if (!self.signalNames.count)
        {
            self.signalNames = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"signalNames"]];
        }
        [self.signalNames enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop){
            [self removeObject:obj postfix:username];
        }];
    }
}

-(NSMutableArray *)signalNames{
    if (!_signalNames) {
        _signalNames = [NSMutableArray new];
    }
    return _signalNames;
}

@end

