//
//       _      ______
//	/\ _\ \    /\  __ \
//	\   _  \   \ \  __<
//	 \ \  \ \   \ \_____\
//	  \/   \/    \/_____/
//
//
//
//  Created by boob on 16/4/29.
//  Copyright © 2016年 YY.COM All rights reserved.
//
#import "PENGProtocol.h"
#import "BaseTableViewCell.h"
#import "EditCellProtocol.h"

static NSString * key_cellstruct_rightbgcolor = @"key_cellstruct_rightbgcolor";
static NSString * key_cellstruct_righttitlecolor = @"key_cellstruct_righttitlecolor";

static NSString * key_cellstruct_txtxibsecureTextEntry = @"key_cellstruct_txtxibsecureTextEntry";
static NSString * key_cellstruct_txtxibHorizontalAlignment = @"key_cellstruct_txtxibHorizontalAlignment";

@interface TextFieldXibCell: BaseTableViewCell
 
@property (weak, nonatomic) IBOutlet UITextField    * txt_content;

@end
