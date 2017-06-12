//
//  HBSynchronizeQueue.m
//  HBSynchronizeManager
//
//  Created by haijiao on 15/7/7.
//  Copyright (c) 2015年 olinone. All rights reserved.
//

#import "HBSynchronizeQueue.h"

@implementation HBSynchronizeQueue

+ (HBSynchronizeQueue *)synchronizeQueue
{
    static HBSynchronizeQueue * _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.maxConcurrentOperationCount = 1;
    }
    return self;
}

/**
 *  Queue 并行执行的时候可以取消其它任务
 */
+ (void)cancelAllOperations
{
    [[HBSynchronizeQueue synchronizeQueue] cancelAllOperations];
}

#pragma mark - sync
/**
 * Queue 串行执行，堵塞线程
 */
+ (void)execSyncBlock:(void (^)())block
{
    [[HBSynchronizeQueue synchronizeQueue] execSyncBlock:block];
}

- (void)execSyncBlock:(void (^)())block
{
    if (NSOperationQueue.currentQueue == self) {
        block();
    } else {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:block];
        [self addOperations:@[operation] waitUntilFinished:YES];
    }
}

#pragma mark - asyn
/**
 *  Queue 并行执行，不堵塞线程
 */
+ (NSOperation *)execAsynBlock:(void (^)())block
{
    return [[HBSynchronizeQueue synchronizeQueue] execAsynBlock:block];
}

- (NSOperation *)execAsynBlock:(void (^)())block
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:block];
    [self addOperation:operation];
    return operation;
}

@end
