//
//  SMDAlertView.m
//  fenda
//
//  Created by boob on 16/11/23.
//  Copyright © 2016年 YY.COM. All rights reserved.
//

#import "SMDAlertView.h"
#import <Masonry/Masonry.h>
//#import "UIView+PENG.h"
//#import "NSString+HBExtension.h"

@interface NSString (smdalert)

- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width;
@end
@implementation NSString(smdalert)

- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width{
    CGFloat height = [self getTextHeightWithWidth:width font:font];
    return CGSizeMake(width, height);
}

- (CGFloat)getTextHeightWithWidth:(CGFloat)width font:(UIFont *)fontsize;
{
    if (!fontsize) {
        fontsize = [UIFont systemFontOfSize:15];
    }
    //获取当前系统版本
    CGFloat currentVersion = [[UIDevice currentDevice].systemVersion floatValue];
    CGFloat height;
    if (currentVersion >= 7.0)    //系统大于7.0
    {
        //label高度
        height = [self boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:fontsize forKey:NSFontAttributeName] context:nil].size.height;
    }
    else
    {
        //label高度
        height = [self sizeWithFont:fontsize constrainedToSize:CGSizeMake(width, 10000)].height;
    }
    return height;
}

@end
@interface UIView (smdalert)
-(void)setcornerRadius:(CGFloat )cornerRadius;
@end

@implementation UIView(smdalert)

-(void)setcornerRadius:(CGFloat )cornerRadius
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    [self layoutIfNeeded];
}

@end


@interface SMDAlertView()

@property (strong, nonatomic)  UIView   * bgView;


@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * message;


@property (nonatomic, copy) SMDDismissBlock SMDDismissBlock;
@property (nonatomic, copy) SMDCancelBlock SMDCancelBlock;

@property (nonatomic, strong) MASConstraint *cancelbtn_width_Constraint;
@end


@implementation SMDAlertView


-(UIFont *)titleFont{
    return [UIFont systemFontOfSize:16];
}
-(UIFont *)msgFont{
    return [UIFont systemFontOfSize:13];
}

-(CGSize)alertsize{
    return CGSizeMake(300, 200);
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadsubviews];
    }
    return self;
}

-(void)loadsubviews{
  
    UIView * alertview = [UIView new];
    [self addSubview:alertview];
    
    [alertview mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self).offset(-40);
//        make.height.equalTo(@(self.alertsize.height));
        make.size.mas_equalTo(self.alertsize);
        make.center.equalTo(self);
    }];
    
    UILabel * lbltitle = [UILabel new];
    [alertview addSubview:lbltitle];
    //标题
    [lbltitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alertview.mas_top).with.offset(5);
        make.left.equalTo(alertview.mas_left).with.offset(5);
        make.right.equalTo(alertview.mas_right).with.offset(-5);
        make.height.equalTo(@40);
    }];
    
    //分割线
    UIView * topline = [UIView new];
    [alertview addSubview:topline];
    topline.backgroundColor = [UIColor colorWithRed:234./255. green:235./255. blue:236./255. alpha:1];
    [topline mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbltitle.mas_bottom).with.offset(0);
        make.left.equalTo(alertview.mas_left).with.offset(0);
        make.right.equalTo(alertview.mas_right).with.offset(0);
        make.height.equalTo(@1);
    }];
    
    //消息
    UILabel * lblmsg = [UILabel new];
    [alertview addSubview:lblmsg];
    
    
    [lblmsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbltitle.mas_bottom).with.offset(5);
        make.left.equalTo(lbltitle.mas_left).with.offset(5);
        make.right.equalTo(lbltitle.mas_right).with.offset(-5);
    }];
    
    //详细详细消息
    UILabel * lbldetail = [UILabel new];
    [alertview addSubview:lbldetail];
    [lbldetail mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblmsg.mas_bottom).with.offset(1);
        make.left.equalTo(lblmsg.mas_left).with.offset(5);
        make.right.equalTo(lblmsg.mas_right).with.offset(-5);
        make.bottom.equalTo(alertview).with.offset(-50);
    }];
    //下划线
    UIView * bottomline = [UIView new];
    [alertview addSubview:bottomline];
    bottomline.backgroundColor = topline.backgroundColor;
    [bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alertview.mas_left).with.offset(0);
        make.right.equalTo(alertview.mas_right).with.offset(0);
        make.bottom.equalTo(alertview.mas_bottom).with.offset(-41);
        make.height.equalTo(@1);
    }];
    
    UIButton * btncancel = [UIButton buttonWithType:UIButtonTypeSystem];
    [alertview addSubview:btncancel];
     [btncancel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alertview.mas_left).with.offset(0);
       self.cancelbtn_width_Constraint = make.width.mas_equalTo(alertview.mas_width).with.multipliedBy(0.5f);
         make.height.mas_equalTo(@40);
         make.bottom.equalTo(alertview.mas_bottom).with.offset(0);
    }];
    
    UIView * bottomcenterline = [UIView new];
    [alertview addSubview:bottomcenterline];
    bottomcenterline.backgroundColor = topline.backgroundColor;
    [bottomcenterline mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btncancel.mas_right).with.offset(0);
        make.top.equalTo(btncancel.mas_top).with.offset(5);
        make.width.mas_equalTo(@1);
        make.height.equalTo(btncancel).offset(-10);
    
    }];
    
    UIButton * btnconfirm = [UIButton buttonWithType:UIButtonTypeSystem];
    [alertview addSubview:btnconfirm];
    [btnconfirm mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btncancel.mas_right).with.offset(0);
        make.right.equalTo(alertview.mas_right).with.offset(0);
        make.bottom.equalTo(alertview.mas_bottom).with.offset(0);
        make.height.mas_equalTo(@40);
    }];
    
//    [btnconfirm setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
//    [btncancel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [btnconfirm setTitleColor:[UIColor colorWithRed:115./255. green:85./255. blue:248./255. alpha:1] forState:UIControlStateNormal];
    [btncancel setTitleColor:[UIColor colorWithRed:157./255. green:155./255. blue:161./255. alpha:1] forState:UIControlStateNormal];
    [btnconfirm setTitle:@"确定" forState:UIControlStateNormal];
    [btncancel setTitle:@"取消" forState:UIControlStateNormal];
    
    
    self.lbl_title = lbltitle;
    self.lbl_detail = lbldetail;
    self.lbl_message = lblmsg;
    self.btn_cancel = btncancel;
    self.btn_confirm = btnconfirm;
    self.alertView = alertview;
    
    self.lbl_detail.numberOfLines = 0;
    self.lbl_message.numberOfLines = 0;
    self.lbl_message.lineBreakMode = NSLineBreakByWordWrapping;
    self.lbl_title.textAlignment = NSTextAlignmentCenter;
    self.lbl_message.textAlignment = NSTextAlignmentCenter;
    self.lbl_detail.textAlignment = NSTextAlignmentCenter;
    self.lbl_detail.font = self.msgFont;
    self.lbl_title.font = self.titleFont;
    self.lbl_message.font = self.msgFont;
    self.lbl_detail.textColor = [UIColor grayColor];
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.bgView.frame = self.bounds;
    [self.alertView setcornerRadius:5];
    self.alertView.backgroundColor = [UIColor colorWithWhite:1 alpha:.95];
    
    
    CGPoint anchorPoint = CGPointMake(0.5,0.5);
    self.alertView.layer.anchorPoint = anchorPoint;
    self.alertView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    
    [self.btn_confirm addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_cancel addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    self.alertView.clipsToBounds = NO;
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
}

-(void)loadTitle:(NSString *)title  message:(NSString *)message
         detail:(NSString *)detail  cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtons:(NSArray *)otherButtons{
    
    CGFloat alertwidth = self.alertView.bounds.size.width;
    CGFloat lblwidth = alertwidth - 16;
    SMDAlertView  * alertview = self;
    CGSize titlesize =  [title sizeWithFont:[UIFont systemFontOfSize:16] byWidth:lblwidth];
    CGSize detailsize =  [detail sizeWithFont:[UIFont systemFontOfSize:13] byWidth:lblwidth];
    CGSize messagesize = [message sizeWithFont:[UIFont systemFontOfSize:13] byWidth:lblwidth];
    
    alertview.lbl_title.text = title;
    self.lbl_detail.text = detail;
    alertview.lbl_message.text = message.length<=200?message:[message substringToIndex:199];
 
    if (otherButtons.count) {
        [alertview.btn_confirm setTitle:otherButtons[0] forState:UIControlStateNormal];
    }
    
    CGFloat height =  titlesize.height + detailsize.height + messagesize.height + 50;
    CGFloat maxheight =([UIScreen mainScreen].bounds.size.height -200);
    height = height > 160 ? height:160;
    height = height < maxheight ? height:maxheight;
    
    [alertview.alertView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    if (cancelButtonTitle) {
        [alertview.btn_cancel setTitle:cancelButtonTitle forState:UIControlStateNormal];
    }else {
        [alertview.btn_cancel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(alertview).multipliedBy(0);
        }];
    } 
}
-(void)loadTitle:(NSString *)title
         message:(NSString *)message
cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtons:(NSArray *)otherButtons {
    
    [self loadTitle:title message:message detail:nil cancelButtonTitle:cancelButtonTitle otherButtons:otherButtons];
//    alertview.alertView.frame = CGRectMake(0, 0, 274, height);
//    alertview.alertView.center = alertview.center;
}

-(void)dismiss{
    [self buttonTap:nil];
}

-(void)dismiss:(BOOL)animation sender:(id)sender{
    
    self.isshow = NO;
    if (sender == self.btn_confirm) {
        if (self.SMDDismissBlock) {
            self.SMDDismissBlock(0);
        }
        if (!animation) {
            [self removeFromSuperview];
            return;
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0;
            self.alertView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    else{
        if (self.SMDCancelBlock) {
            self.SMDCancelBlock();
        }
        if (!animation) {
            [self removeFromSuperview];
            return;
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0;
            self.alertView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
    }
}
-(IBAction)buttonTap:(id)sender
{
    [self dismiss:YES sender:sender];
}
+ (instancetype ) alertViewWithTitle:(NSString*) title
                             message:(NSString*) message
                              detail:(NSString *) detail
                      cancelButtonTitle:(NSString*) cancelButtonTitle
                      otherButtonTitles:(NSArray*) otherButtons
                              onDismiss:(SMDDismissBlock) dismissed
                               onCancel:(SMDCancelBlock) cancelled{
    
    SMDAlertView * alertview = [[SMDAlertView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height)];
    alertview.SMDDismissBlock = dismissed;
    alertview.SMDCancelBlock = cancelled;
    [alertview loadTitle:title message:message detail:detail cancelButtonTitle:cancelButtonTitle otherButtons:otherButtons];
    [alertview show];
    return alertview;
    
    
}

-(void)show{
    
    [self show:YES];
}

-(void)show:(BOOL)animate{
    
    self.isshow = YES;
    UIWindow * window = [[[UIApplication sharedApplication] windows] firstObject];
    
    [window addSubview:self];
    
    [self layoutIfNeeded];
    if (animate) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }else{ 
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }

    
}

+ (instancetype ) alertViewWithTitle:(NSString *) title
                             message:(NSString *) message
                              detail:(NSString *) detail
                   cancelButtonTitle:(NSString*) cancelButtonTitle{
    
    SMDAlertView * alert = [SMDAlertView alertViewWithTitle:title message:message  detail:detail cancelButtonTitle:nil otherButtonTitles:@[cancelButtonTitle] onDismiss:nil onCancel:nil];
    
    return alert;
}

+ (instancetype ) alertViewWithTitle:(NSString*) title
                               message:(NSString*) message
                     cancelButtonTitle:(NSString*) cancelButtonTitle {
    SMDAlertView *  alert = [[SMDAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:cancelButtonTitle
                                                otherButtonTitles: nil];
    [alert show];
    return alert ;
}

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ...
{
    SMDAlertView * alert = [SMDAlertView alertViewWithTitle:title message:message  detail:nil cancelButtonTitle:nil otherButtonTitles:@[cancelButtonTitle] onDismiss:nil onCancel:nil];
    
    return alert;
}

@end
