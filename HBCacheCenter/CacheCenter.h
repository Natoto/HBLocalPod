//
//  CacheCenter.h
//  JXL
//
//  Created by BooB on 15-4-20.
//  Copyright (c) 2015年 BooB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKKeyValueStore.h"

#define GET_OBJECT_OF_USERDEFAULT(KEY)   [[CacheCenter sharedInstance] readNSUserDefaultObjectForKey:KEY];
#define SET_OBJECT_OF_USERDEFAULT(OBJ,KEY)  [[CacheCenter sharedInstance] setNSUserDefaultObject:OBJ forKey:KEY];


@interface CacheCenter : NSObject

+ (instancetype)sharedInstance;

/**
 *  保存JSON数据
 *
 *  @param jsonstring json数据
 *  @param tableName  表名
 *  @param key        关键字
 */
-(void)saveJSON:(NSString *)jsonstring ForTableName:(NSString *)tableName Key:(NSString *)key;
/**
 *  得到json数据
 *
 *  @param tableName 表名
 *  @param key       关键字
 *
 *  @return json数据
 */
-(NSString *)getJSONForTableName:(NSString *)tableName key:(NSString *)key;

/**
   * 使用 NSUserDefault 读key数据  不建议用 耗内存
 */
-(id)readNSUserDefaultObjectForKey:(NSString *)key;
///**
// * 使用 NSUserDefault 存储 key的数据
// */
-(void)setNSUserDefaultObject:(id)object forKey:(NSString *)key;

/**
 * 保存archive对象 不建议用 耗内存
 */
-(void)saveObject:(id)object forkey:(NSString *)key;
/**
 * 读取缓存数据
 */
-(id)readObject:(NSString *)key;

/**
 * 移除关键字为key的缓存
 */
-(void)removeObjectForKey:(NSString *)key;

//-(void)removeObject:(NSString *)key;

//发送清除历史缓存通知
-(void)removePreUserData:(NSString *)username;
@end
