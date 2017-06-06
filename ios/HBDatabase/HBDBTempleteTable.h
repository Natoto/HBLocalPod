//
//  HBDBTempleteTable.h
//  fenda
//
//  Created by boob on 2017/4/5.
//  Copyright © 2017年 YY.COM. All rights reserved.
//

#import "HBDataBase.h"
#import  "HBContentTable.h"


#define STEP1_SET_TABLE_NAME(CLAZZ) \
- (void)configTableName{\
self.contentClass = [CLAZZ class];\
self.tableName = [NSString stringWithFormat:@"%@Table",NSStringFromClass([CLAZZ class])];\
}

#define STEP2_SET_MAIN_KEY(KEY) \
- (NSString *)contentId{\
    return @#KEY;\
}\

/**
 * 其他字段属性，以nil结尾 如： STEP3_SET_OTHER_FIELDS(@"uid",nil);
 */
#define STEP3_SET_OTHER_FIELDS(...)\
- (NSArray<NSString *> *)getContentField{\
    return [self configcontentfields:__VA_ARGS__];\
}\

#define STEP3_SET_OTHER_FIELDS_DEFAULT \
- (NSArray<NSString *> *)getContentField{\
    return [self getDefaultContentField];\
}\

#define STEP4_SET_ASS_TABLE \
- (NSDictionary<NSString *, NSDictionary *> *)associativeTableField


#define AS_DBTABLE_FORCALSS(CLAZZ)\
@interface CLAZZ##Table : HBDBTempleteTable\
@end


@protocol HBDBTempleteTableProtocol <NSObject>

@required

- (void)configTableName; //__attribute__((warn_unused_result));
- (NSString *)contentId;//__attribute__((warn_unused_result));

@optional

- (NSArray<NSString *> *)getContentField;

// 为 gradeID 加上索引
- (void)addOtherOperationForTable:(FMDatabase *)aDB;
// 设置关联的表
- (NSDictionary<NSString *, NSDictionary *> *)associativeTableField;
- (NSDictionary*)fieldStorageType;
- (NSDictionary *)fieldLenght;

@end

@interface HBDBTempleteTable : HBContentTable<HBDBTempleteTableProtocol>

- (NSArray<NSString *> *)getDefaultContentField;

-(NSArray *)configcontentfields:(NSString *)firstArg, ...;

@end
