//
//  LeftRightUpDownLabelXIBCell.h
//  HjbPay
//
//  Created by boob on 16/4/20.
//  Copyright © 2016年 YY.COM All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
@interface LeftRightUpDownLabelXIBCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons_imgheight;

@property (weak, nonatomic) IBOutlet UIImageView *img_profile;
@property(nonatomic,weak) IBOutlet UILabel * lbl_rightup;
@property(nonatomic,weak) IBOutlet UILabel * lbl_leftup;
@property(nonatomic,weak) IBOutlet UILabel * lbl_leftdown;
@property(nonatomic,weak) IBOutlet UILabel * lbl_rightdown;


//左上
-(void)setcellTitle:(NSString *)title;
//左下
-(void)setcelldetailtitle:(NSString *)detailtitle;
//右上  [NSString stringWithFormat:@"<span style=\"color:#60D978;font-size:15px;\">%@</span>",string];
-(void)setcellValue:(NSString *)value;
//右下
-(void)setcellValue2:(NSString *)value;
@end
