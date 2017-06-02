//
//  UIButton+Alignment.h
//  JXL
//
//  Created by hb on 15/5/11.
//  Copyright (c) 2015年 BooB. All rights reserved.
//
typedef NS_ENUM(NSInteger, OTSUIButtonLayoutStyle) {
    OTSImageLeftTitleRightStyle = 0, //默认的方式 image左 title右
    OTSTitleLeftImageRightStyle = 1, // image右,title左
    OTSImageTopTitleBootomStyle = 2, //image上，title下
    OTSTitleTopImageBootomStyle = 3, // image下,title上
};
#import <UIKit/UIKit.h>

@interface UIButton(Alignment)

/**
 *	功能:设置UIButton的布局，图片和文字按照指定方向显示
 *
 *	@param aLayoutStyle:参见OTSUIButtonLayoutStyle
 *	@param aSpacing:图片和文字之间的间隔
 */
- (void)setLayout:(OTSUIButtonLayoutStyle )aLayoutStyle
          spacing:(CGFloat)aSpacing;
 
@end
