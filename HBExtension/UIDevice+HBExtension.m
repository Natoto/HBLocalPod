//
//  UIDevice+HBExtension.m
//  Pods
//
//  Created by boob on 17/1/24.
//
//

#import "UIDevice+HBExtension.h"
#import <sys/utsname.h>
@implementation UIDevice(HBExtension)
+ (BOOL)isScreenSize:(CGSize)size
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    if ( [UIScreen instancesRespondToSelector:@selector(currentMode)] )
    {
        CGSize size2 = CGSizeMake( size.height, size.width );
        CGSize screenSize = [UIScreen mainScreen].currentMode.size;
        
        if ( CGSizeEqualToSize(size, screenSize) || CGSizeEqualToSize(size2, screenSize) )
        {
            return YES;
        }
    }
    
    return NO;
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}



#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
static const char * __isjb_app = NULL;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

+ (BOOL)isJailBroken NS_AVAILABLE_IOS(4_0)
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    static const char * __isjb_apps[] =
    {
        "/Application/Cydia.app",
        "/Application/limera1n.app",
        "/Application/greenpois0n.app",
        "/Application/blackra1n.app",
        "/Application/blacksn0w.app",
        "/Application/redsn0w.app",
        NULL
    };
    
    __isjb_app = NULL;
    
    // method 1
    for ( int i = 0; __isjb_apps[i]; ++i )
    {
        if ( [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:__isjb_apps[i]]] )
        {
            __isjb_app = __isjb_apps[i];
            return YES;
        }
    }
    
    // method 2
    if ( [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] )
    {
        return YES;
    }
    
    // method 3
    if ( 0 == system("ls") )
    {
        return YES;
    }
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    return NO;
}


+ (NSString *)jailBreaker NS_AVAILABLE_IOS(4_0)
{
#if (TARGET_OS_IPHONE)
    if ( __isjb_app )
    {
        return [NSString stringWithUTF8String:__isjb_app];
    }
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    return @"";
}

+ (BOOL)isDevicePhone
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    NSString * deviceType = [UIDevice currentDevice].model;
    
    if ( [deviceType rangeOfString:@"iPhone" options:NSCaseInsensitiveSearch].length > 0 ||
        [deviceType rangeOfString:@"iPod" options:NSCaseInsensitiveSearch].length > 0 ||
        [deviceType rangeOfString:@"iTouch" options:NSCaseInsensitiveSearch].length > 0 )
    {
        return YES;
    }
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    return NO;
}



+ (BOOL)isDevicePad
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    NSString * deviceType = [UIDevice currentDevice].model;
    
    if ( [deviceType rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].length > 0 )
    {
        return YES;
    }
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    return NO;
}


+ (BOOL)isPhoneRetina4
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    if ( [self isDevicePad] )
    {
        return NO;
    }
    else
    {
        return [UIDevice isScreenSize:CGSizeMake(640, 1136)];
    }
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}


//iPhone4做原型时，可以用320*480,
//iPhone5做原型时，可以用320*568,
//iPhone6做原型时，可以用375*667,
//iPhone6 Plus原型，可以用414x736,


+ (BOOL)isPhoneRetina5
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    if ( [self isDevicePad] )
    {
        return NO;
    }
    else
    {
        return [UIDevice isScreenSize:CGSizeMake(375*2, 667*2)];
    }
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}


+ (BOOL)isPad
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return [UIDevice isScreenSize:CGSizeMake(768, 1024)];
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (BOOL)isPadRetina
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return [UIDevice isScreenSize:CGSizeMake(1536, 2048)];
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}



+ (BOOL)requiresPhoneOS
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return [[[NSBundle mainBundle].infoDictionary objectForKey:@"LSRequiresIPhoneOS"] boolValue];
#else// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return NO;
#endif// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}


+ (NSString *)OSVersion
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return [NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
#else// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return nil;
#endif// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (NSString *)appVersion
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
    NSString * value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    if ( nil == value || 0 == value.length )
    {
        value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersion"];
    }
    return value;
#else// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return nil;
#endif// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (NSString *)appIdentifier
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    static NSString * __identifier = nil;
    if ( nil == __identifier )
    {
        __identifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    }
    return __identifier;
#else// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return @"";
#endif// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (NSString *)appSchema
{
    return [self appSchema:nil];
}

+ (NSString *)appSchema:(NSString *)name
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    NSArray * array = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
    for ( NSDictionary * dict in array )
    {
        if ( name )
        {
            NSString * URLName = [dict objectForKey:@"CFBundleURLName"];
            if ( nil == URLName )
            {
                continue;
            }
            
            if ( NO == [URLName isEqualToString:name] )
            {
                continue;
            }
        }
        
        NSArray * URLSchemes = [dict objectForKey:@"CFBundleURLSchemes"];
        if ( nil == URLSchemes || 0 == URLSchemes.count )
        {
            continue;
        }
        
        NSString * schema = [URLSchemes objectAtIndex:0];
        if ( schema && schema.length )
        {
            return schema;
        }
    }
    
    return nil;
#else// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return nil;
#endif// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (NSString *)deviceModel
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return [UIDevice currentDevice].model;
#else// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return nil;
#endif// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}


/**
 * 设备型号
 */
+ (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    //iPod
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceString isEqualToString:@"iPad4,4"]
        ||[deviceString isEqualToString:@"iPad4,5"]
        ||[deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceString isEqualToString:@"iPad4,7"]
        ||[deviceString isEqualToString:@"iPad4,8"]
        ||[deviceString isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceString;
}

@end
