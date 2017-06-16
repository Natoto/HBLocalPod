//
//  YLogger.h
//  log
//
//  Created by wuwenqing on 13-12-6.
//  Copyright (c) 2013年 yy inc. All rights reserved.
//

// Main idea comes from Google Toolkit for Mac, honor is Google's.

#import <Foundation/Foundation.h>

@protocol LogWriter;
@protocol LogFormatter;
@protocol LogFilter;

@protocol LogDelegate <NSObject>
- (void)logMsg:(NSString *)msg;
@end

typedef bool (^logDat)(NSString *fileName, NSData *data);

@interface HBLogger : NSObject

+ (HBLogger *)sharedLogger;
+ (void)setSharedLogger:(HBLogger *)logger;
+ (id)standardLogger;
+ (id)loggerWithFilePrefix:(NSString *)filePrefix inFolder:(NSString *)folder;

@property (atomic, strong) id<LogFilter> filter;

- (id)initWithWriter:(id<LogWriter>)writer
           formatter:(id<LogFormatter>)format
              filter:(id<LogFilter>)filter;

- (NSString *)currentLogFilePath;
- (void)logData:(logDat)logData;
- (void)setDelegate :(id)delegate;
- (id  )getDelegate;


- (void)logFuncDebug:(const char *)func line:(int)line module:(NSString *)module msg:(NSString *)fmt, ...NS_FORMAT_FUNCTION(3, 5);
- (void)logFuncInfo :(const char *)func line:(int)line module:(NSString *)module msg:(NSString *)fmt, ...NS_FORMAT_FUNCTION(3, 5);
- (void)logFuncWarn :(const char *)func line:(int)line module:(NSString *)module msg:(NSString *)fmt, ...NS_FORMAT_FUNCTION(3, 5);
- (void)logFuncError:(const char *)func line:(int)line module:(NSString *)module msg:(NSString *)fmt, ...NS_FORMAT_FUNCTION(3, 5);

- (void)LogFuncSync:(const char *)func line:(int)line module:(NSString *)module msg:(NSString *)fmt, ...NS_FORMAT_FUNCTION(3, 5);


-(void)remove7dayAgoLogfile;

@end

typedef enum {
    LoggerLevelDebug,
    LoggerLevelInfo,
    LoggerLevelWarn,
    LoggerLevelError,
    LoggerLevelDSync
} LoggerLevel;

@protocol LogWriter <NSObject>
- (void)logMessage:(NSString *)msg level:(LoggerLevel)level;
- (void)logDat:(logDat)logData;
@end


@protocol LogFormatter <NSObject>
- (NSString *)stringForFunc:(NSString *)func
                     module:(NSString *)module
                 withFormat:(NSString *)fmt
                     valist:(va_list)args
                      level:(LoggerLevel)level NS_FORMAT_FUNCTION(2, 0);
@end

@protocol LogFilter <NSObject>
- (BOOL)filterAllowsMessage:(NSString *)msg level:(LoggerLevel)level;
@end


