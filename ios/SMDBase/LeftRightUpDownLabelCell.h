//
//  RightUpDownLabelCell.h
//  hjb
//
//  Created by BooB on 16/3/17.
//  Copyright © 2016年 YY.COM All rights reserved.
//

#import "BaseTableViewCell.h"

@interface LeftUpDownRightLabelCell : BaseTableViewCell

@property(nonatomic,strong) UILabel * lbl_rightup;
@property(nonatomic,strong) UILabel * lbl_leftup;
@property(nonatomic,strong) UILabel * lbl_leftdown;

//左上
-(void)setcellTitle:(NSString *)title;

//左下
-(void)setcelldetailtitle:(NSString *)detailtitle;

//右上
-(void)setcellValue:(NSString *)value;

//字体颜色配置
-(void)setcelldictionary:(NSMutableDictionary *)dictionary;
@end


@interface LeftRightUpDownLabelCell : LeftUpDownRightLabelCell

//@property(nonatomic,strong) UILabel * lbl_rightup;
@property(nonatomic,strong) UILabel * lbl_rightdown;

//@property(nonatomic,strong) UILabel * lbl_leftup;
//@property(nonatomic,strong) UILabel * lbl_leftdown;

//右下label
-(void)setcellValue2:(NSString *)value;
-(void)setcelldictionary:(NSMutableDictionary *)dictionary;
@end
