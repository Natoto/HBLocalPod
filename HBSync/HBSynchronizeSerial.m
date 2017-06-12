//
//  HBSynchronizeSerial.m
//  TTPod
//
//  Created by haijiao on 15/10/29.
//
//

#import "HBSynchronizeSerial.h"

#if OS_OBJECT_USE_OBJC
#define HBDispatchQueueRelease(__v)
#else
#define HBDispatchQueueRelease(__v) (dispatch_release(__v));
#endif

@interface HBSynchronizeSerial () {
    dispatch_queue_t _queue;
}

@end

@implementation HBSynchronizeSerial

+ (HBSynchronizeSerial *)synchronizeQueue {
    static HBSynchronizeSerial * _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)dealloc {
    if (_queue) {
        HBDispatchQueueRelease(_queue);
        _queue = 0x00;
    }
}

- (instancetype)init {
    if (self = [super init]) {
        NSString *identifier = [@"com.ttpod.music." stringByAppendingString:[self randomBitString]];
        _queue = dispatch_queue_create([identifier UTF8String], DISPATCH_QUEUE_SERIAL);
        dispatch_queue_t dQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        dispatch_set_target_queue(_queue, dQueue);
    }
    return self;
}

- (NSString *)randomBitString {
    u_int8_t length = 10;
    char data[length];
    for (int x = 0; x< length; data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:length encoding:NSUTF8StringEncoding];
}

#pragma mark - sync
/**
 * GCD 串行执行，堵塞线程
 */
+ (void)execSyncBlock:(void (^)())block {
    [[HBSynchronizeSerial synchronizeQueue] execSyncBlock:block];
}

- (void)execSyncBlock:(void (^)())block {
    dispatch_sync(_queue, ^{
        block();
    });
}

#pragma mark - asyn
/**
 * GCD 并行执行，不堵塞线程
 */
+ (void)execAsynBlock:(void (^)())block {
    [[HBSynchronizeSerial synchronizeQueue] execAsynBlock:block];
}

- (void)execAsynBlock:(void (^)())block {
    dispatch_async(_queue, ^{
        block();
    });
}

@end
