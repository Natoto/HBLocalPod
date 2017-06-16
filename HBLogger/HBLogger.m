//
//  YLogger.m
//  log
//
//  Created by wuwenqing on 13-12-6.
//  Copyright (c) 2013年 yy inc. All rights reserved.
//

#import "HBLogger.h"

//for pthread_self()
#import <fcntl.h>
#import <pthread.h>
//end for pthread_self()

static HBLogger *gSharedLogger = nil;

@interface StdoutLogWriter : NSObject<LogWriter>

@end

@implementation StdoutLogWriter

- (void)logMessage:(NSString *)msg level:(LoggerLevel)level
{
    @synchronized(self) {
        @try {
            fprintf(stdout, "%s\n", [msg UTF8String]);
        }
        @catch (id e) {
            // Ignored
        }
    }
}

- (void)logDat:(logDat)logData
{
    
}

@end

static NSString *const kLogFileNameDateFormat = @"yyyyMMdd";

@interface FileLogWriter : NSObject<LogWriter>
{
    NSString *_logFolder;
    NSString *_logFilePrefix;
    NSString *_logDateString;
    NSDateFormatter* _dateFormatter;
    NSFileHandle *_fileHandle;
    dispatch_queue_t _logQueue;
}

+ (id<LogWriter>)fileLogWriterWithFilePrefix:(NSString *)filePrefix inFolder:(NSString *)folder;


@end

@implementation FileLogWriter

+ (id<LogWriter>)fileLogWriterWithFilePrefix:(NSString *)filePrefix inFolder:(NSString *)folder
{
    return [[FileLogWriter alloc] initWithFilePrefix:filePrefix inFolder:folder];
}

- (id)initWithFilePrefix:(NSString *)filePrefix inFolder:(NSString *)folder
{
    self = [super init];
    
    if (self)
    {
        _logFilePrefix = filePrefix;
        _logFolder     = folder;
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [_dateFormatter setDateFormat:kLogFileNameDateFormat];
        _logDateString = [self currentDateString];
        _logQueue      = dispatch_queue_create("com.yy.logger", DISPATCH_QUEUE_SERIAL);
        
        dispatch_async(_logQueue,
                       ^{
                           [self cleanLogFiles];
                       });
    }
    return self;
}

- (void)cleanLogFiles
{
    NSFileManager *fileManager    = [NSFileManager defaultManager];
    NSString      *finalLogFolder = [self calculateLogFolder];
    NSError       *error;
    NSArray       *logFiles       = [fileManager contentsOfDirectoryAtPath:finalLogFolder error:&error];
    
    if (logFiles == nil)
    {
        NSLog(@"failed to get log files array:%@", error);
    
        return;
    }
#ifdef DEBUG
    NSDate* date =[[NSDate date] dateByAddingTimeInterval:-7*24*60*60];
#else
    NSDate* date =[[NSDate date] dateByAddingTimeInterval:-2*24*60*60];
#endif
    
    for (NSString *logFile in logFiles)
    {
        NSString     *logFilePath = [finalLogFolder stringByAppendingPathComponent:logFile];
        NSDictionary *fileAttr    = [fileManager attributesOfItemAtPath:logFilePath error:&error];
        
        if (fileAttr)
        {
            NSDate *creationDate = [fileAttr valueForKey:NSFileCreationDate];
            
            if ([creationDate compare:date] == NSOrderedAscending)
            {
                NSLog(@"%@ will be deleted", logFile);
                [fileManager removeItemAtPath:logFilePath error:&error];
                NSLog(@"%@ was deleted, error number is %ld", logFilePath, (long)error.code);
            }
        }
    }
}

- (void)logDat:(logDat)logData
{
    NSFileManager *fileManager    = [NSFileManager defaultManager];
    NSString      *finalLogFolder = [self calculateLogFolder];
    NSError       *error;
    NSArray       *logFiles       = [fileManager contentsOfDirectoryAtPath:finalLogFolder error:&error];

    if (logFiles == nil)
    {
        NSLog(@"failed to get log files array:%@", error);
        
        return;
    }
    
    NSString *curlog = [NSString stringWithFormat:@"%@.log", _logDateString];
    
    for (NSString *logFile in logFiles)
    {
        NSString *logFilePath = [finalLogFolder stringByAppendingPathComponent:logFile];
        
        if ([logFilePath hasSuffix:@".log"] == NO || [logFilePath hasSuffix:curlog] == YES)
        {
            continue;
        }
        
        NSData   *data        = [NSData dataWithContentsOfFile:logFilePath options:NSDataReadingMapped error:&error];
        
        if (logData != nil) { logData(logFile, data); }
        
        [fileManager removeItemAtPath:logFilePath error:&error];
    }
}

- (NSString *)calculateLogFolder
{
    static NSString *cacheDirectory;
    do
    {
        if (cacheDirectory)
            break;
        
        NSArray *directories = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        if ([directories count] < 1)
            break;
        
        cacheDirectory = [directories objectAtIndex:0];
        
        NSUInteger length = [cacheDirectory length];
        
        if (length < 1)
        {
            cacheDirectory = nil;
        
            break;
        }
        
    } while (false);
    
    if (cacheDirectory == nil)
    {
        NSLog(@"failed to get cache directory");
    
        return nil;
    }
    
    NSString *finalFolder = nil;
    
    if ([_logFolder hasPrefix:@"/"])
    {
        finalFolder = [NSString stringWithFormat:@"%@%@", cacheDirectory, _logFolder];
    }
    else
    {
        finalFolder = [NSString stringWithFormat:@"%@/%@", cacheDirectory, _logFolder];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:finalFolder])
    {
        NSError *error;
        [fileManager createDirectoryAtPath:finalFolder withIntermediateDirectories:YES attributes:nil error:&error];
    
        if (error != nil)
        {
            NSLog(@"failed to create path:%@", finalFolder);
        
            return nil;
        }
    }
    
    return finalFolder;
}

- (NSString *)calculateLogFilePath
{
    NSString *finalFolder = [self calculateLogFolder];
    
    if (finalFolder == nil)
    {
        return nil;
    }
    
    return [NSString stringWithFormat:@"%@/%@_%@.log", finalFolder, _logFilePrefix, _logDateString];
}

- (void)openLogFile:(NSString *)filePath
{
    int fd = -1;
    
    if (filePath)
    {
        NSLog(@"log file name is:%@", filePath);
        int flags = O_WRONLY | O_APPEND | O_CREAT;
        fd = open([filePath fileSystemRepresentation], flags, S_IRUSR|S_IWUSR);
    }
    
    if (fd != -1)
    {
        _fileHandle = [[NSFileHandle alloc] initWithFileDescriptor:fd closeOnDealloc:YES];
    }
}

- (NSString *)currentDateString
{
    return [_dateFormatter stringFromDate:[NSDate date]];
}

- (void)logMessageA:(NSString *)msg level:(LoggerLevel)level
{
    @try
    {
        if (_fileHandle == nil)
        {
            _logDateString = [self currentDateString];
            NSString *filePath = [self calculateLogFilePath];
            
            [self openLogFile:filePath];
        }
        else
        {
            NSString *currentDateString = [self currentDateString];
            
            if (![currentDateString isEqualToString:_logDateString])
            {
                [_fileHandle closeFile];
                _logDateString = currentDateString;
                NSString *filePath = [self calculateLogFilePath];
                
                [self openLogFile:filePath];
            }
        }
        
        NSString *line = [NSString stringWithFormat:@"%@\n", msg];
        [_fileHandle writeData:[line dataUsingEncoding:NSUTF8StringEncoding]];
    }
    @catch (id e)
    {
        // Ignored
    }
}

- (void)logMessage:(NSString *)msg level:(LoggerLevel)level
{
    if (level == LoggerLevelDSync) { dispatch_sync (_logQueue, ^{ [self logMessageA:msg level:level]; }); }
    else                           { dispatch_async(_logQueue, ^{ [self logMessageA:msg level:level]; }); }
}

@end

@interface CompositLogWriter : NSObject<LogWriter>

@property (strong, atomic) NSMutableArray *writers;

- (id)initWithWriters:(NSArray *)writers;

@end

@implementation CompositLogWriter

- (id)initWithWriters:(NSArray *)writers
{
    self = [super init];
    
    if (self)
    {
        self.writers = [NSMutableArray arrayWithArray:writers];
    }
    
    return self;
}

- (void)logMessage:(NSString *)msg level:(LoggerLevel)level
{
    for (id<LogWriter> writer in self.writers)
    {
        [writer logMessage:msg level:level];
    }
}

- (void)logDat:(logDat)logData
{
    for (id<LogWriter> writer in self.writers)
    {
        if ([writer respondsToSelector:@selector(logDat:)] == NO) continue;
        
        [writer logDat:logData];
    }
}

@end

@interface LoggerLevelStringDict : NSObject

+ (LoggerLevelStringDict *)sharedObject;

- (NSString *)stringForLevel:(LoggerLevel)level;

@end

static LoggerLevelStringDict *gLoggerLevelStringDict = nil;

@implementation LoggerLevelStringDict
{
    NSDictionary *_dict;
}

+ (LoggerLevelStringDict *)sharedObject
{
    @synchronized(self)
    {
        if (gLoggerLevelStringDict == nil)
        {
            gLoggerLevelStringDict = [[LoggerLevelStringDict alloc] init];
        }
    }
    
    return gLoggerLevelStringDict;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _dict = @{ @(LoggerLevelDebug) : @"DEBUG",
                   @(LoggerLevelInfo)  : @"INFO ",
                   @(LoggerLevelWarn)  : @"WARN ",
                   @(LoggerLevelError) : @"ERROR",
                   @(LoggerLevelDSync) : @"DSYNC"};
    }
    return self;
}

- (NSString *)stringForLevel:(LoggerLevel)level
{
    return [_dict objectForKey:@(level)];
}

@end


@interface LogDefaultFormatter : NSObject <LogFormatter>

@end

@implementation LogDefaultFormatter
{
    NSDateFormatter *_dateFormatter;  // yyyy-MM-dd HH:mm:ss.SSS
    NSString *_pname;
    pid_t _pid;
}

- (id)init
{
    if ((self = [super init]))
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        _pname         = [[NSProcessInfo processInfo] processName];
        _pid           = [[NSProcessInfo processInfo] processIdentifier];
        
        if (!(_dateFormatter && _pname))
        {
            return nil;
        }
    }
    return self;
}

- (NSString *)prettyNameForFunc:(NSString *)func
{
    NSString *name = [func stringByTrimmingCharactersInSet:
                      [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *function = @"(unknown)";
    
    if ([name length])
    {
        if (// Objective C __func__ and __PRETTY_FUNCTION__
            [name hasPrefix:@"-["] || [name hasPrefix:@"+["] ||
            // C++ __PRETTY_FUNCTION__ and other preadorned formats
            [name hasSuffix:@")"])
        {
            function = name;
        }
        else
        {
            // Assume C99 __func__
            function = [NSString stringWithFormat:@"%@()", name];
        }
    }
    
    return function;
}

- (NSString *)stringForFunc:(NSString *)func
                     module:(NSString *)module
                 withFormat:(NSString *)fmt
                     valist:(va_list)args
                      level:(LoggerLevel)level
{
    //always drop function name parameter
    return [self internalStringForFunc:func
                                module:module
                            withFormat:fmt
                                valist:args
                                 level:level];
}

- (NSString *)internalStringForFunc:(NSString *)func
                             module:(NSString *)module
                         withFormat:(NSString *)fmt
                             valist:(va_list)args
                              level:(LoggerLevel)level
{
    // Performance note: We may want to do a quick check here to see if |fmt|
    // contains a '%', and if not, simply return 'fmt'.
    if (!(fmt && args)) return nil;
    
    NSString *tstamp = nil;
    
    @synchronized (_dateFormatter)
    {
        tstamp = [_dateFormatter stringFromDate:[NSDate date]];
    }
    
    NSString *levelStr   = [[LoggerLevelStringDict sharedObject] stringForLevel:level];
    NSString *finalMsg   = [[NSString alloc] initWithFormat:fmt arguments:args];
    NSString *finalModule= [NSString stringWithFormat:@"%-5s", [module UTF8String]];
    
    if (func)
    {
        NSString *finalFmt = @"%@ [%10p][%@][%@] %@ %@";
        NSString *finalFun = [self prettyNameForFunc:func];
    
        return [NSString stringWithFormat:finalFmt,
                tstamp, pthread_self(),
                levelStr, finalModule, finalFun,
                finalMsg];
    }
    else
    {
        NSString *finalFmt = @"%@ [%10p][%@][%@] %@";
       
        return [NSString stringWithFormat:finalFmt,
                tstamp, pthread_self(),
                levelStr, finalModule,
                finalMsg];
    }
}

@end

@interface LogDefaultFilter : NSObject<LogFilter>

@end

@implementation LogDefaultFilter

- (BOOL)filterAllowsMessage:(NSString *)msg level:(LoggerLevel)level
{
    return level >= LoggerLevelDebug;
}

@end

@interface HBLogger()

@property (atomic, strong) id<LogWriter>    writer  ;
@property (atomic, strong) id<LogFormatter> format  ;
@property (atomic, strong) id               logMsg  ;

@end

@implementation HBLogger

+ (HBLogger *)sharedLogger
{
    @synchronized(self)
    {
        if (gSharedLogger == nil)
        {
            gSharedLogger = [HBLogger loggerWithFilePrefix:@"hb" inFolder:@"/logs"];
        }
    }
    
    return gSharedLogger;
}

+ (void)setSharedLogger:(HBLogger *)logger
{
    @synchronized(self)
    {
        gSharedLogger = logger;
    }
}

+ (id)standardLogger
{
    // Don't trust NSFileHandle not to throw
    @try
    {
        id<LogWriter> writer = [[StdoutLogWriter alloc] init];
        id<LogFormatter> format = [[LogDefaultFormatter alloc] init];
        id<LogFilter> filter = [[LogDefaultFilter alloc] init];
        return [[self alloc] initWithWriter:writer
                                  formatter:format
                                     filter:filter];
    }
    @catch (id e)
    {
        // Ignored
    }
    
    return nil;
}

+ (id)loggerWithFilePrefix:(NSString *)filePrefix inFolder:(NSString *)folder
{
    // Don't trust NSFileHandle not to throw
    @try
    {
        id<LogWriter> writer = [[StdoutLogWriter alloc] init];
        id<LogWriter> fileWriter = [FileLogWriter fileLogWriterWithFilePrefix:filePrefix inFolder:folder];
        NSArray *writers = @[ writer, fileWriter ];
        CompositLogWriter *compositWriter = [[CompositLogWriter alloc] initWithWriters:writers];
        id<LogFormatter> format = [[LogDefaultFormatter alloc] init];
        id<LogFilter> filter = [[LogDefaultFilter alloc] init];
        return [[self alloc] initWithWriter:compositWriter
                                  formatter:format
                                     filter:filter];
    }
    @catch (id e)
    {
        // Ignored
    }
    
    return nil;
}

- (void)setDelegate:(id)delegate
{
    if ([delegate respondsToSelector:@selector(logMsg:)] == NO) return;
    
    _logMsg = delegate;
}

- (id)getDelegate
{
    return _logMsg;
}

- (void)logData:(logDat)logData
{
    [self.writer logDat:logData];
}

- (NSString *)currentLogFilePath
{
    if (![self.writer isKindOfClass:[CompositLogWriter class]])
    {
        return nil;
    }
    
    NSArray *writers = ((CompositLogWriter *)self.writer).writers;
    for (id<LogWriter> writer in writers)
    {
        if ([writer isKindOfClass:[FileLogWriter class]])
        {
            return [((FileLogWriter *)writer) calculateLogFilePath];
        }
    }
    
    return nil;
}

- (id)initWithWriter:(id<LogWriter>)writer
           formatter:(id<LogFormatter>)format
              filter:(id<LogFilter>)filter
{
    self = [super init];
    
    if (self)
    {
        self.writer = writer;
        self.format = format;
        self.filter = filter;
    }
    return self;
}

- (void)logInternalFunc:(const char *)func
                   line:(int)line
                 module:(NSString *)module
                 format:(NSString *)fmt
                 valist:(va_list)args
                  level:(LoggerLevel)level
{
    // Primary point where logging happens, logging should never throw, catch
    // everything.
    @try
    {
        NSString *fname = func ? [NSString stringWithUTF8String:func] : nil;
        fname = [fname stringByAppendingFormat:@"LINE: %d",line];
        NSString *msg = [self.format stringForFunc:fname
                                            module:module
                                        withFormat:fmt
                                            valist:args
                                             level:level];
        if (msg && [self.filter filterAllowsMessage:msg level:level])
        {
            [self.writer logMessage:msg level:level];
            
            if (_logMsg != nil && LoggerLevelError == level) { [_logMsg logMsg:msg]; }
        }
    }
    @catch (id e)
    {
        // Ignored
    }
}

- (void)logSyncFunc:(const char *)func
             module:(NSString *)module
             format:(NSString *)fmt
             valist:(va_list)args
              level:(LoggerLevel)level
{
    // Primary point where logging happens, logging should never throw, catch
    // everything.
    @try
    {
        NSString *fname = func ? [NSString stringWithUTF8String:func] : nil;
        NSString *msg = [self.format stringForFunc:fname
                                            module:module
                                        withFormat:fmt
                                            valist:args
                                             level:level];
        if (msg && [self.filter filterAllowsMessage:msg level:level])
        {
            [self.writer logMessage:msg level:level];
            
            if (_logMsg != nil && LoggerLevelError == level) { [_logMsg logMsg:msg]; }
        }
    }
    @catch (id e)
    {
        // Ignored
    }
}

- (void)logFuncDebug:(const char *)func line:(int)line module:(NSString *)module msg:(NSString *)fmt, ...
{
    va_list args;
    va_start(args, fmt);
    [self logInternalFunc:func  line:line module:module format:fmt valist:args level:LoggerLevelDebug];
    va_end(args);
}

- (void)logFuncInfo:(const char *)func line:(int)line  module:(NSString *)module msg:(NSString *)fmt, ...
{
    va_list args;
    va_start(args, fmt);
    [self logInternalFunc:func  line:line module:module format:fmt valist:args level:LoggerLevelInfo];
    va_end(args);
}

- (void)logFuncWarn:(const char *)func  line:(int)line module:(NSString *)module msg:(NSString *)fmt, ...
{
    va_list args;
    va_start(args, fmt);
    [self logInternalFunc:func  line:line module:module format:fmt valist:args level:LoggerLevelWarn];
    va_end(args);
}

- (void)logFuncError:(const char *)func  line:(int)line  module:(NSString *)module msg:(NSString *)fmt, ...
{
    va_list args;
    va_start(args, fmt);
    [self logInternalFunc:func  line:line module:module format:fmt valist:args level:LoggerLevelError];
    va_end(args);
}

- (void)LogFuncSync:(const char *)func line:(int)line module:(NSString *)module msg:(NSString *)fmt, ...
{
    va_list args;
    va_start(args, fmt);
    [self logInternalFunc:func line:line module:module format:fmt valist:args level:LoggerLevelDSync];
    va_end(args);
}

/**
 * 根据文件名删除七天前的日志  
 *  假设文件名格式是：hb_20160606.log
 */
-(void)remove7dayAgoLogfile{
    
    @try {
        NSFileManager *fileManager    = [NSFileManager defaultManager];
        NSString      *finalLogFolder = [self.currentLogFilePath stringByDeletingLastPathComponent];
        NSError       *error;
        NSArray       *logFiles       = [fileManager contentsOfDirectoryAtPath:finalLogFolder error:&error];
        
        if (logFiles == nil)
        {
            NSLog(@"failed to get log files array:%@", error);
            
            return;
        }
#ifdef DEBUG
        NSDate* date =[[NSDate date] dateByAddingTimeInterval:-7*24*60*60];
#else
        NSDate* date =[[NSDate date] dateByAddingTimeInterval:-2*24*60*60];
#endif
        
        for (NSString *logFile in logFiles)
        {
            NSString     *logFilePath = [finalLogFolder stringByAppendingPathComponent:logFile];
            NSDictionary *fileAttr    = [fileManager attributesOfItemAtPath:logFilePath error:&error];
            
            if (fileAttr)
            {
                NSString * filename = logFile.lastPathComponent;
                NSString * filedatestring = [filename.stringByDeletingPathExtension componentsSeparatedByString:@"_"].lastObject;
                if (!filedatestring) {
                    continue;
                }
                // 1.创建一个时间格式化对象
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 2.格式化对象的样式/z大小写都行/格式必须严格和字符串时间一样
                formatter.dateFormat = @"yyyyMMdd";
                // 3.利用时间格式化对象让字符串转换成时间 (自动转换0时区/东加西减)
                NSDate *filedate = [formatter dateFromString:filedatestring];
                
                //            NSDate *creationDate = [fileAttr valueForKey:NSFileCreationDate];
                
                if ([filedate compare:date] == NSOrderedAscending)
                {
                    NSLog(@"%@ will be deleted", logFile);
                    [fileManager removeItemAtPath:logFilePath error:&error];
                    NSLog(@"%@ was deleted, error number is %ld", logFilePath, (long)error.code);
                }
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"删除过期日志失败");
    } @finally {
        
    }
  
}

@end



