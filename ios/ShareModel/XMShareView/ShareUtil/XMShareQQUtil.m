//
//  XMShareQQUtil.m
//  XMShare
//
//  Created by Amon on 15/8/6.
//  Copyright (c) 2015年 GodPlace. All rights reserved.
//

#import "XMShareQQUtil.h"

@interface XMShareQQUtil()

@property (nonatomic, strong)  TencentOAuth *tencentOAuth;

@end

@implementation XMShareQQUtil



- (void)shareToQQ
{
    
    [self shareToQQBase:SHARE_QQ_TYPE_SESSION];
    
}

-(void)loginQQ{
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            kOPEN_PERMISSION_LIST_ALBUM,
                            kOPEN_PERMISSION_UPLOAD_PIC,
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            nil];
    
    [self.tencentOAuth authorize:permissions inSafari:NO];
    

 }

- (void)shareToQzone
{
    
    [self shareToQQBase:SHARE_QQ_TYPE_QZONE];
    
}

- (void)shareToQQBase:(SHARE_QQ_TYPE)type
{
    if (!_APP_KEY_QQ) {
        NSLog(@"请设置app_key_qq");
        return;
    }
    TencentOAuth *tencentOAuth = [[TencentOAuth alloc] initWithAppId:_APP_KEY_QQ andDelegate:self];
    self.tencentOAuth = tencentOAuth;
    NSLog(@"TencentOAuth accessToken:%@", self.tencentOAuth.accessToken);
    NSString *utf8String = self.shareUrl;
    NSString *theTitle = self.shareTitle;
    NSString *description = self.shareText;
    NSData *imageData = UIImageJPEGRepresentation(self.thumeImage, SHARE_IMG_COMPRESSION_QUALITY);
    
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:utf8String]
                                title:theTitle
                                description:description
                                previewImageData:imageData];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    
    if (type == SHARE_QQ_TYPE_SESSION) {
        
        //将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        NSLog(@"QQApiSendResultCode:%d", sent);
        
    }else{
        
        //将内容分享到qzone
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        NSLog(@"Qzone QQApiSendResultCode:%d", sent);
        
    }
}
-(void)tencentDidNotLogin:(BOOL)cancelled{
    NSLog(@"%s",__func__);
}

-(void)tencentDidNotNetWork{
    
    NSLog(@"%s",__func__);
    
}

-(void)tencentDidLogin{

    NSLog(@"%s",__func__);
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        // 记录登录用户的OpenID、Token以及过期时间
        NSLog(@"%@",self.tencentOAuth.accessToken);
        [self.tencentOAuth getUserInfo];//这个方法返回BOOL
        NSLog(@"openId : %@",self.tencentOAuth.openId);
        if (self.getQQUserOpenId) {
            self.getQQUserOpenId(self.tencentOAuth.openId);
        }
    }
    else
    {
        NSLog(@"登陆不成功 没有获取accessToken");
    }
}

- (void)getUserInfoResponse:(APIResponse*) response{
    NSLog(@"%@--",response);
    if (self.getinfoblock) {
        self.getinfoblock(response);
    }
}



+ (instancetype)sharedInstance
{
    
    static XMShareQQUtil* util;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        util = [[XMShareQQUtil alloc] init];
        
    });
    return util;
}


-(void)setAPP_KEY_QQ:(NSString *)APP_KEY_QQ{
    _APP_KEY_QQ = APP_KEY_QQ;
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:APP_KEY_QQ andDelegate:self];
}

- (instancetype)init
{
    
    static id obj=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [super init];
        if (obj) {
            //注意： 初始化授权 开发者需要在这里填入自己申请到的 AppID
        }
    });
    self=obj;
    return self;
}

@end
