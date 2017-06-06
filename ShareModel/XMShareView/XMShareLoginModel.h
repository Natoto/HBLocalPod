//
//  XMShareLoginModel.h
//  Pods
//
//  Created by boob on 16/12/31.
//
//

#import <Foundation/Foundation.h>


//  分享类型
typedef NS_ENUM(NSInteger, SHARE_LOGIN){
    
    //  微信会话
    SHARE_LOGIN_WEIXIN,
    //  QQ会话
    SHARE_LOGIN_QQ,
    
};



@interface XMShareLoginModel : NSObject

+ (instancetype)sharedInstance;

-(void)loginType:(SHARE_LOGIN)type;

@end
