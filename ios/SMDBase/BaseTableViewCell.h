//
//  BaseTableViewCell.h
//  PENG
//
//  Created by zeno on 15/12/14.
//  Copyright © 2015年 nonato. All rights reserved.
//

#import <HBKit/HBKit.h>
#import "PENGProtocol.h"
#import "UIImageView+HBWebCache.h"
#import "HBCellKeys.h"
//#import "UIImage+LocalImage.h"

// NSValue * edgeinsetsValue
// [cellstruct.dictionary setObject:[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 10)] forKey:key_cellstruct_contentInsets];

//UITableViewCellAccessoryCheckmark


@interface BaseTableViewCell : HBBaseTableViewCell<PENGCellProtocol>
@property(nonatomic,strong) UIControl * AcessoryButton;


-(void)showSnapView;
-(void)draw:(CELL_STRUCT *)cellstruct;
@end

