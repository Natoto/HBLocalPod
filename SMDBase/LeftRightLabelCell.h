//
//  LeftRightLabelCell.h
//  hjb
//
//  Created by boob on 16/4/3.
//  Copyright © 2016年 YY.COM All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
//static NSString * key_cellstruct_textAlignment2 = @"key_cellstruct_textAlignment2";
/*注意：
 iOS7.0以后的UILabel会自动将Text行尾的空白字符全部去除，除了常见的半角空格（\0x20）和制表符(\t)之外，全角空格(\u3000)也被计算在内，甚至连多余的换行符（\r，\n）也被自动去除了
 */
@interface LeftRightLabelCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_left;
@property (weak, nonatomic) IBOutlet UILabel *lbl_right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ns_leftwidth;

@end
