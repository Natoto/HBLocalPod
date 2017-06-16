//
//  LoggerDefines.h
//  SDK
//
//  Created by wuwenqing on 14-6-20.
//  Copyright (c) 2014年 YY. All rights reserved.
//

#ifndef SDK_LoggerDefines_h
#define SDK_LoggerDefines_h

#define kSDKName @"HB"

#import "HBLogger.h"

#define logDebug(...)     [[HBLogger sharedLogger] logFuncDebug:__func__ line:__LINE__ module:kSDKName msg:__VA_ARGS__]
#define logInfo(...)      [[HBLogger sharedLogger] logFuncInfo :__func__ line:__LINE__ module:kSDKName msg:__VA_ARGS__]
#define logWarn(...)      [[HBLogger sharedLogger] logFuncWarn :__func__ line:__LINE__ module:kSDKName msg:__VA_ARGS__]
#define logError(...)     [[HBLogger sharedLogger] logFuncError:__func__ line:__LINE__ module:kSDKName msg:__VA_ARGS__]
#define logDelegate(...)  [[HBLogger sharedLogger] LogDelegate :__func__ line:__LINE__ module:kSDKName msg:__VA_ARGS__]
#define logDebugSync(...) [[HBLogger sharedLogger] LogFuncSync :__func__ line:__LINE__ module:kSDKName msg:__VA_ARGS__]

#ifndef DEBUG
#undef  logDebug
#define logDebug(...)
#undef  logDebugSync
#define logDebugSync(...)
#endif

#endif
