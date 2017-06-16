//
//  HJBRouterHelper.m
//  hjb
//
//  Created by BooB on 16/3/15.
//  Copyright © 2016年 YY.COM All rights reserved.
//

#import "HJBRouterHelper.h"
#import "HBRouter.h"

@class RootViewController; 

@implementation HJBRouterHelper
//没什么卵用
+(NSDictionary *)manifest
{
    return @{
             @"application" :@{
                     @"routes" :@{
                             @"index"  : @"RootViewController",//ROOT
                             @"RootViewController": @"RootViewController",
                             },
                     @"main" : @"index"
                     },
             };
}

+(void)initHBRouterWithRoot:(UIViewController *)mainNavigationctr
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *manifest = [HJBRouterHelper manifest];
        NSDictionary *applicationRoutes = [manifest valueForKeyPath:@"application.routes"];
//        NSString *applicationMain = [manifest valueForKeyPath:@"application.main"];
        NSLog(@"%@",applicationRoutes);
        [applicationRoutes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [[HBRouter sharedInstance] mapKey:key toControllerClassName:obj];
        }];
        [[HBRouter sharedInstance] mapKey:@"RootViewController" toControllerClassName:@"RootViewController"];
        [HBRouter sharedInstance].rootViewController = mainNavigationctr;
    });
}
@end


@implementation UIViewController(HJBRouterHelper)

-(void)addToRouter
{
    [[HBRouter sharedInstance] mapKey:NSStringFromClass([self class]) toControllerClassName:NSStringFromClass([self class])];
}

-(void)addToRouterWithClass:(Class)class
{
    [[HBRouter sharedInstance] mapKey:NSStringFromClass(class) toControllerClassName:NSStringFromClass(class)];
}
-(void)openViewControllerWithClass:(Class)class para:(NSDictionary *)param
{
    [[HBRouter sharedInstance] mapKey:NSStringFromClass(class) toControllerClassName:NSStringFromClass(class)];
    [[HBRouter sharedInstance] openURLString:NSStringFromClass(class) parameters:param];
}

/**
 *   [self openURLString:@"modal://YYJBAboutViewController" forkey:@"YYJBAboutViewController" parameters:nil];
 *   [self openURLString:@"YYJBAboutViewController" forkey:@"YYJBAboutViewController" parameters:nil];
 *  @param URLString  <#URLString description#>
 *  @param key        <#key description#>
 *  @param parameters <#parameters description#>
 */
-(void)openURLString:(NSString *)URLString forkey:(NSString *)key parameters:(NSDictionary *)parameters animate:(BOOL)animate
{
    NSArray * compants = [key componentsSeparatedByString:@"_"];
    [compants enumerateObjectsUsingBlock:^(NSString * subkey, NSUInteger idx, BOOL * _Nonnull stop) {
        [[HBRouter sharedInstance] mapKey:subkey toControllerClassName:subkey];
    }];
    [[HBRouter sharedInstance] openURLString:URLString parameters:parameters animation:animate];
    
}
-(void)openURLString:(NSString *)URLString forkey:(NSString *)key parameters:(NSDictionary *)parameters
{
    [self openURLString:URLString forkey:key parameters:parameters animate:YES];
    
}

+(void)openURLString:(NSString *)URLString forkey:(NSString *)key parameters:(NSDictionary *)parameters
{
    if (key) {
        [[HBRouter sharedInstance] mapKey:key toControllerClassName:key];
    }
    [[HBRouter sharedInstance] openURLString:URLString parameters:parameters];
    
}

+(void)openForkey:(NSString *)key  blockViewController:(UIViewController *(^)(void))block {
    
    [[HBRouter sharedInstance] mapKey:key toBlock:block];
    [[HBRouter sharedInstance] openURLString:key];
    
}
-(void)openForkey:(NSString *)key  blockViewController:(UIViewController *(^)(void))block {
    
    [[HBRouter sharedInstance] mapKey:key toBlock:block];
    [[HBRouter sharedInstance] openURLString:key];

}

-(void)openURLString:(NSString *)URLString
        forKeyAndNib:(NSString *)key
          parameters:(NSDictionary *)parameters
{
    if (key) {
       [[HBRouter sharedInstance] mapKey:key toBlock:^UIViewController *{
           Class cls = NSClassFromString(key);
           UIViewController * ctr = [[cls alloc] initWithNibName:key bundle:nil];
           return ctr;
       }];
    }
    [[HBRouter sharedInstance] openURLString:URLString parameters:parameters];
}
 

@end


/*
 [[XYRouter sharedInstance] mapKey:@"aaa" toControllerClassName:@"UIViewController"];
 Getting viewController for key
 
 当取出ViewController的时候, 如果有单例[ViewController sharedInstance], 默认返回单例, 如果没有, 返回[[ViewController alloc] init].
 
 UIViewController *vc = [[XYRouter sharedInstance] viewControllerForKey:@"aaa"];
 Maping a viewController instance
 
 如果不想每次都创建对象, 也可以直接映射一个实例
 
 [[XYRouter sharedInstance] mapKey:@"bbb" toControllerInstance:[[UIViewController alloc] init]];
 Maping a viewController instance with a block
 
 如果想更好的定制对象, 可以用block
 
 [[XYRouter sharedInstance] mapKey:@"nvc_TableVC" toBlock:^UIViewController *{
 TableViewController *vc = [[TableViewController alloc] init];
 UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
 return nvc;
 }];
 Opening path
 
 你可以使用key去push出一个viewController
 
 [[XYRouter sharedInstance] openURLString:@"aaa"];
 path还支持相对路径, 如下面的代码可以在当前目录下push出一个TableVC后, 再push出TestVC1.
 
 [[XYRouter sharedInstance] openURLString:@"./TableVC/TestVC1"];
 
 目前支持这些描述:
 
 在当前目录push ./
 在上一个目录push ../
 在根目录根push /
如果要回到之前的某一个页面可以用  /xxx/xxx
 
 Assigning parameters
 
 在跳转的时候还可以传递参数
 
 @interface TestVC1 : BaseMFViewController
 @property (nonatomic, assign) NSInteger i;
 @property (nonatomic, copy) NSString *str1;
 @property (nonatomic, copy) NSString *str2;
 @end
 
 [[XYRouter sharedInstance] openURLString:@"TestVC1?str1=a&str2=2&i=1"];
 Changing rootViewController
 
 可以用scheme:window替换windows.rootViewController
 
 // rootViewController : nvc_TableVC
 [[XYRouter sharedInstance] openURLString:@"window://nvc_TableVC/TestVC1"];
 Presenting rootViewController
 
 可以用scheme:modal来呈现一个模态视图
 
 // rootViewController : nvc_TableVC
 [[XYRouter sharedInstance] openURLString:@"modal://nvc_TableVC/TestModalVC/"];
 
 // rootViewController : TestModalVC
 [[XYRouter sharedInstance] openURLString:@"modal://TestModalVC/?str1=a&str2=2&i=1"];
 Dismissing rootViewController
 
 关闭这个模态视图直接用dismiss
 
 [[XYRouter sharedInstance] openURLString:@"dismiss"];
 
 
 
 // 处理pop到上层的viewcontroller 的情况
 - (BOOL)__handlePopBackWithURL:(NSURL *)URL
 {
 NSString *scheme = URL.scheme;
 NSString *host   = URL.host;
 
 if ([@"pop" isEqualToString:scheme] && host.length > 0)
 {
 UIViewController *vc = [self viewControllerForKey:host];
 NSArray *components          =  [URL pathComponents];
 if (components.count >=2) {
 __block BOOL canpop = YES;
 __block UIViewController * popctr = nil;
 for (NSInteger idx = 1; idx < vc.navigationController.viewControllers.count; idx ++) {
 UIViewController * obj = vc.navigationController.viewControllers[idx];
 if (components.count > idx) {
 NSString * viewcontroller = components[idx];
 if (![viewcontroller isEqualToString:NSStringFromClass([obj class])]) {
 canpop = NO;
 }else{
 if (idx == components.count -1) {
 popctr = obj;
 }
 }
 }
 }
 if (popctr) {
 [vc.navigationController popToViewController:popctr animated:YES];
 }
 return YES;
 }
 }
 return NO;
 }
 */
