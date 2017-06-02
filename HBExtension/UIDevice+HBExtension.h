//
//  UIDevice+HBExtension.h
//  Pods
//
//  Created by boob on 17/1/24.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#define IS_IPAD             (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE           (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA           ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH        ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT       ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH   (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH   (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5         (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0
#define IS_IPHONE_5_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 667.0)

#define IS_IPHONE_6         (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P        (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IOS10_OR_LATER		( [[[UIDevice currentDevice] systemVersion] floatValue]>= 10.0 )
#define IOS9_OR_LATER		( [[[UIDevice currentDevice] systemVersion] floatValue]>= 9.0 )
#define IOS8_OR_LATER		(  [[[UIDevice currentDevice] systemVersion] floatValue]>= 8.0 )
#define IOS7_OR_LATER		(  [[[UIDevice currentDevice] systemVersion] floatValue]>=7.0 )
#define IOS6_OR_LATER		(  [[[UIDevice currentDevice] systemVersion] floatValue]>= 6.0 )
#define IOS5_OR_LATER		( [[[UIDevice currentDevice] systemVersion] floatValue]>= 5.0 )
#define IOS4_OR_LATER		(  [[[UIDevice currentDevice] systemVersion] floatValue]> 4.0 )
#define IOS3_OR_LATER		( [[[UIDevice currentDevice] systemVersion] floatValue]>= 3.0 )


#define IOS9_OR_EARLIER		( !IOS10_OR_LATER )
#define IOS8_OR_EARLIER		( !IOS9_OR_LATER )
#define IOS7_OR_EARLIER		( !IOS8_OR_LATER )
#define IOS6_OR_EARLIER		( !IOS7_OR_LATER )
#define IOS5_OR_EARLIER		( !IOS6_OR_LATER )
#define IOS4_OR_EARLIER		( !IOS5_OR_LATER )
#define IOS3_OR_EARLIER		( !IOS4_OR_LATER )

//Note: If iPhone 6 is in zoomed mode the UI is a zoomed up version of iPhone 5. This is reflected in the macros.

#define IS_SCREEN_55_INCH	IS_IPHONE_6P
#define IS_SCREEN_47_INCH	IS_IPHONE_6
#define IS_SCREEN_4_INCH	IS_IPHONE_5
#define IS_SCREEN_35_INCH	([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960),  [[UIScreen mainScreen] currentMode].size) : NO)

#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#define IOS7_OR_LATER		(NO)
#define IOS6_OR_LATER		(NO)
#define IOS5_OR_LATER		(NO)
#define IOS4_OR_LATER		(NO)
#define IOS3_OR_LATER		(NO)

#define IS_SCREEN_4_INCH	(NO)
#define IS_SCREEN_35_INCH	(NO)
#define IS_SCREEN_47_INCH	(NO)
#define IS_SCREEN_55_INCH	(NO)

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)



@interface UIDevice(HBExtension)

+ (NSString*)deviceVersion;
@end
