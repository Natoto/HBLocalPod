//
//  CountDownButton.h
//  CountdownButtonDemo
//
//  Created by hb on 15/6/23.
//  Copyright (c) 2016年 yy.com All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountDownButton : UIButton
-(void)startCountDown;

@end

@interface UIButton(countdown)

-(void)startCountDownWithTimeout:(int)timeout;
@end