//
//  LeftLabelRightButtonCell.h
//  hjb
//
//  Created by boob on 16/4/4.
//  Copyright © 2016年 YY.COM All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

static NSString * key_cellstruct_llrbrightenable = @"key_cellstruct_llrbrightenable";

@interface LeftLabelRightButtonCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn_right;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;


-(void)setcellTitle:(NSString *)title;
-(void)setcelldetailtitle:(NSString *)value;
-(void)setcelldictionary:(NSMutableDictionary *)dictionary;
@end
