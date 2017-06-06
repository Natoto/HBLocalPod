//
//  UIView+Badge.h
//  JHTDoctor
//
//  Created by yangsq on 16/5/17.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Badge)

@property (strong, nonatomic) UILabel *badgeLabel;
@property (strong, nonatomic) UIImageView *badgeBackGroundImageView;

- (void)showBadgeView:(NSInteger)badge andPoint:(CGPoint)point;



@end
