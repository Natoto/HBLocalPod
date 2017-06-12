//
//  HBSynchronizeQueue.h
//  HBSynchronizeManager
//
//  Created by haijiao on 15/7/7.
//  Copyright (c) 2015年 olinone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBSynchronizeQueue : NSOperationQueue

+ (void)execSyncBlock:(void (^)())block;
+ (NSOperation *)execAsynBlock:(void (^)())block;
+ (void)cancelAllOperations;

- (void)execSyncBlock:(void (^)())block;
- (NSOperation *)execAsynBlock:(void (^)())block;

@end
