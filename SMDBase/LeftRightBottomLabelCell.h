//
//  LeftRightBottomLabelCell.h
//  hjb
//
//  Created by boob on 16/4/4.
//  Copyright © 2016年 YY.COM All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
@interface LeftRightBottomLabelCell : BaseTableViewCell

@property(nonatomic,weak) IBOutlet UILabel * lbl_rightup;
@property(nonatomic,weak) IBOutlet UILabel * lbl_leftup;
@property(nonatomic,weak) IBOutlet UILabel * lbl_leftdown;
@end
