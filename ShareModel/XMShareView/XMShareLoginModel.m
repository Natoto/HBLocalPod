
//
//  XMShareLoginModel.m
//  Pods
//
//  Created by boob on 16/12/31.
//
//

#import "XMShareLoginModel.h"
#import "XMShareQQUtil.h"
#import "XMShareQQUtil.h"

@implementation XMShareLoginModel


+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


-(void)loginType:(SHARE_LOGIN)type{

    switch (type ) {
        case SHARE_LOGIN_QQ:
        {
            [[XMShareQQUtil sharedInstance] loginQQ];
            break;
        }
        default:
            break;
    }
}

@end
