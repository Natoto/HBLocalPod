//
//  UIViewController+HBHUD.m
//  HUANGBO
//
//  Created by HUANGBO on 15/1/25.
//  Copyright (c) 2015年 YY.COM All rights reserved.
//
#import "NSObject+HBHUD.h"
//#import "MBProgressHUD.h"
#import <objc/runtime.h>

#define KEY_OBJECT_HUD @"UIViewController.HBHUD"
#define KEY_HUD @"dismissblock"
#define key_hudbgcolor  @"hudbgcolorkey"
#define key_hudoffset  @"key_hudoffset"

@implementation NSObject(HBHUD)
static char OperationKey;



//static char messageTipsKey;

-(void)presentMessageTips:(NSString *)message animated:(BOOL)animated
{
    [self presentMessageTips_:message];
}

-(void)presentAlertTips:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}
  
-(void)presentAlertTitle:(NSString *)title
                 message:(NSString *)message
                    from:(UIViewController *)from
                   block:(void(^)())block {
    
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if(block) block();
    }];
    [alert addAction:actionOk];
    //添加一个文本框到弹框控制器
    //显示弹框控制器
    [from presentViewController:alert animated:YES completion:nil];
    
}



-(void)presentSheetTitle:(NSString *)title
                 message:(NSString *)message
                    from:(UIViewController *)from
                   block:(void(^)())block
                  cancel:(void(^)())cancle{
    
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    //创建一个取消和一个确定按钮
    UIAlertAction *actionCancle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if(cancle) cancle();
    }];
    //因为需要点击确定按钮后改变文字的值，所以需要在确定按钮这个block里面进行相应的操作
    UIAlertAction *actionOk=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if(block) block();
    }];
    //将取消和确定按钮添加进弹框控制器
    [alert addAction:actionCancle];
    [alert addAction:actionOk];
    //添加一个文本框到弹框控制器
    //显示弹框控制器
    [from presentViewController:alert animated:YES completion:nil];
    
}

-(void)presentAlertTitle:(NSString *)title message:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}


 -(void)presentMessageTips:(NSString *)message
{
    [self presentMessageTips_:message];
}

-(void)presentMessageTips:(NSString *)message dismisblock:(void (^)())dismissblock
{
    [self presentMessageTips_:message dismisblock:dismissblock];
}


-(void)presentFailureTips:(NSString *)message
{
     [self presentMessageTips_:message];
}

-(MBProgressHUD *)presentMessageTips_:(NSString *)message
{
    UIView * superview = [self SuperView];
    if(!superview) return nil;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superview animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.color = self.hudbgcolor;
    hud.yOffset = self.hudoffset.floatValue;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [hud hide:YES];
    });
    return hud;
}


- (void)presentMessageTips_:(NSString *)message dismisblock:(void(^)())dismissblock
{
    UIView * superview = [self SuperView];
    if(!superview) return;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superview animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.yOffset = self.hudoffset.floatValue;
    hud.color = self.hudbgcolor;
    hud.yOffset = self.hudoffset.floatValue;
    hud.userInteractionEnabled = NO;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [hud showAnimated:YES whileExecutingBlock:^{
          sleep(1.5);
    } onQueue:queue completionBlock:^{
        [hud removeFromSuperview];
        dismissblock();
    }];
}

//- (void)presentLoadingTips:(NSString *)message dismisblock:(void(^)())dismissblock
//{
//    
//    MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    [self setHUD:HUD];
//    
//    // Set determinate mode
//    HUD.mode = MBProgressHUDModeDeterminate;
//    
//    HUD.delegate = self;
//    HUD.labelText = message;
//    // myProgressTask uses the HUD instance to update progress
//    [HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//    });
//}

-(MBProgressHUD *)presentLoadinghud
{
    UIView * superview = [self SuperView];
    if(!superview) return nil;
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:superview animated:YES];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"closeBtn"] forState:UIControlStateNormal];
    button.frame = CGRectMake(5, [UIScreen mainScreen].bounds.size.height - 30, 25, 25);
    [button addTarget:self action:@selector(hideloadingTips:) forControlEvents:UIControlEventTouchUpInside];
    [HUD addSubview:button];
    return HUD;
}

-(void)dismissAllTips
{
    UIView * superview = [self SuperView];
    if(!superview) return ;
    [MBProgressHUD hideAllHUDsForView:superview animated:YES];
 
}

-(MBProgressHUD *)presentLoadingTips:(NSString *)message
{
    UIView * superview = [self SuperView];
    if(!superview) return nil;
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:superview animated:YES];
    [self setHUD:HUD];
    HUD.mode = MBProgressHUDModeIndeterminate;//MBProgressHUDModeDeterminate;
    HUD.delegate = self;
    HUD.labelText = message;
    HUD.square = YES;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"closeBtn"] forState:UIControlStateNormal];
    button.frame = CGRectMake(5, [UIScreen mainScreen].bounds.size.height - 30, 25, 25);
    [button addTarget:self action:@selector(hideloadingTips:) forControlEvents:UIControlEventTouchUpInside];
    [HUD addSubview:button];
    return HUD;
}

-(void)hideloadingTips:(id)sender
{
    MBProgressHUD * hud = [self HUD];
    [hud hide:YES];
}

-(void)dismissTips
{
    MBProgressHUD * hud = [self HUD];
    [hud hide:YES];
}


- (void)myProgressTask {
    // This just increases the progress indicator in a loop
    
    MBProgressHUD * hud = [self HUD];
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        hud.progress = progress;
        usleep(50000);
    }
}



-(UIView *)SuperView
{
    UIView * superview = [UIApplication sharedApplication].keyWindow;
  if ([[self class] isSubclassOfClass:[UINavigationController class]]) {
        UINavigationController * ctr = (UINavigationController *)self;
        superview = ctr.view;
  }
  else if ([[self class] isSubclassOfClass:[UIViewController class]]) {
      UIViewController * ctr = (UIViewController *)self;
      superview = ctr.view;
   }
  else if ([[self class] isSubclassOfClass:[UIView class]]) {
        UIView * ctr = (UIView *)self;
        superview = ctr;
    }
    else if ([[self class] isSubclassOfClass:[UIWindow class]]) {
        UIWindow * ctr = (UIWindow *)self;
        superview = ctr;
        
    }
    else {
        UIWindow * wdw = [UIApplication sharedApplication].windows.firstObject;
        superview = wdw;
    }
    return superview;
}


-(void)setHUD:(MBProgressHUD *)HUD
{
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, &OperationKey);
    if(opreations == nil)
    {
        opreations = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &OperationKey, opreations, OBJC_ASSOCIATION_RETAIN);
    }
    [opreations setObject:HUD forKey:KEY_HUD];
}

-(MBProgressHUD *)HUD
{
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, &OperationKey);
    if(opreations == nil) return nil;
    MBProgressHUD * aHUD = [opreations objectForKey:KEY_HUD];
    return aHUD;
}


-(void)setHudoffset:(NSNumber *)hudoffset
{
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, &OperationKey);
    if(opreations == nil)
    {
        opreations = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &OperationKey, opreations, OBJC_ASSOCIATION_RETAIN);
    }
    [opreations setObject:hudoffset forKey:key_hudoffset];
}

-(NSNumber *)hudoffset
{
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, &OperationKey);
    if(opreations == nil) return nil;
    NSNumber * offset = [opreations objectForKey:key_hudoffset];
    return offset;
}


-(void)setHudbgcolor:(UIColor *)hudbgcolor
{
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, &OperationKey);
    if(opreations == nil)
    {
        opreations = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &OperationKey, opreations, OBJC_ASSOCIATION_RETAIN);
    }
    [opreations setObject:hudbgcolor forKey:key_hudbgcolor];
}

-(UIColor *)hudbgcolor
{
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, &OperationKey);
    if(opreations == nil) return nil;
    UIColor * color = [opreations objectForKey:key_hudbgcolor];
//    if(!color) color = [UIColor colorWithWhite:0 alpha:0.6];
    return color;
}

@end
