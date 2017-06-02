
//
//  SMDBaseTable.m
//  fenda
//
//  Created by boob on 2017/4/5.
//  Copyright © 2017年 YY.COM. All rights reserved.
//

#import "SMDBaseTable.h"
#import <objc/runtime.h>
@implementation SMDBaseTable

//
//- (void)configTableName{
//    
//    self.contentClass = [BeeActiveObject class];
//    self.tableName = [NSString stringWithFormat:@"%@Table",NSStringFromClass([self class])];
//    
//}
//
//- (NSString *)contentId{
//    return @"id";
//}


- (NSArray<NSString *> *)getDefaultContentField{
    NSMutableArray *arrayM = [[NSMutableArray alloc] init];
    unsigned int outCount;
    Class aClass = [self.contentClass class];
    while (class_getSuperclass(aClass) != nil) {
        objc_property_t *properties = class_copyPropertyList(aClass, &outCount);
        for (NSInteger index = 0; index < outCount; index++) {
            NSString *tmpName = [NSString stringWithFormat:@"%s",property_getName(properties[index])];
            if (![tmpName isEqualToString:self.contentId]) {
                [arrayM addObject:tmpName];
            }
        }
        if (properties) {
            free(properties);
        }
        aClass = class_getSuperclass(aClass);
    }
    return arrayM;
}


-(NSArray *)configcontentfields:(NSString *)firstArg, ... {
    
#warning 注意赋值的时候需要以nil结尾，如果是空的直接nil
    NSMutableArray *concatString = [[NSMutableArray alloc] init];
    if (firstArg.length) {
        va_list args;
        va_start(args, firstArg);
        for (NSString *arg = firstArg; arg != nil; arg = va_arg(args, NSString*))
        {
            if ([[arg class] isSubclassOfClass:[NSString class]]) {
                [concatString addObject:arg];
            }
        }
        va_end(args);
    }
//    NSLog(@"%s %@",__func__,concatString);
    return concatString;
}

@end
