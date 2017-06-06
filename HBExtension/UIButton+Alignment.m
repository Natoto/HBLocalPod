//
//  UIButton+Alignment.m
//  JXL
//
//  Created by hb on 15/5/11.
//  Copyright (c) 2015年 BooB. All rights reserved.
//

#import "UIButton+Alignment.h"

@implementation UIButton(Alignment)


- (void)setLayout:(OTSUIButtonLayoutStyle )aLayoutStyle
          spacing:(CGFloat)aSpacing
{
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    CGFloat totalHeight = (imageSize.height + titleSize.height + aSpacing);
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets titleEdgeInsets = UIEdgeInsetsZero;
    if (aLayoutStyle == OTSImageLeftTitleRightStyle) {
        imageEdgeInsets = UIEdgeInsetsMake(0, -(aSpacing / 2.0f), 0, 0 );
        titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, - (aSpacing / 2.0f));
    }
    else if (aLayoutStyle == OTSTitleLeftImageRightStyle) {
        imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(titleSize.width * 2 + aSpacing / 2.0f));
        titleEdgeInsets = UIEdgeInsetsMake(0, -(imageSize.width * 2 + aSpacing / 2.0f), 0, 0);
    }else if (aLayoutStyle == OTSImageTopTitleBootomStyle){
        imageEdgeInsets = UIEdgeInsetsMake( -(totalHeight - imageSize.height),
                                           0.0,
                                           0.0,
                                           - titleSize.width);
        titleEdgeInsets  = UIEdgeInsetsMake(0.0,
                                            -imageSize.width,
                                            - (totalHeight - titleSize.height),
                                            0.0);
    }else if (aLayoutStyle == OTSTitleTopImageBootomStyle){
        imageEdgeInsets = UIEdgeInsetsMake(0.0,
                                           0.0,
                                           -(totalHeight - imageSize.height),
                                           - titleSize.width);
        
        titleEdgeInsets = UIEdgeInsetsMake(-(totalHeight - titleSize.height),
                                           0.0,
                                           -imageSize.width,
                                           0.0);
    }
    self.imageEdgeInsets = imageEdgeInsets;
    self.titleEdgeInsets = titleEdgeInsets;
}

@end
