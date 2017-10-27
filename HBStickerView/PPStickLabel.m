//
//  PPStickLabel.m
//  POPA
//
//  Created by boob on 2017/4/27.
//  Copyright © 2017年 YY.COM. All rights reserved.
//

#import "PPStickLabel.h"

@implementation PPStickLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)didMoveToWindow {
    
    self.contentScaleFactor = [UIScreen mainScreen].scale * 9.0;
    
}
@end
