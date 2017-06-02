//
//  UIView+Transition.m
//  HUANGBO
//
//  Created by HUANGBO on 15/3/26.
//  Copyright (c) 2015年 YY.COM All rights reserved.
//

#import "UIView+Transition.h"

@implementation UIView(Transition)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
 
- (void)transitionCube
{
    [self transitionCube:HBUITransitionDirectionRight];
}

- (void)transitionCube:(HBUITransitionDirection)from
{
    [self transiteFor:self direction:from Type:@"cube"];
}

- (void)transitionMoveIn:(HBUITransitionDirection)from
{
    [self transiteFor:self direction:from Type:kCATransitionMoveIn];
}
- (void)transitionPush
{
    [self transitionPush:HBUITransitionDirectionRight];
}

- (void)transitionPush:(HBUITransitionDirection)from
{
    [self transiteFor:self direction:from Type:kCATransitionPush];
}

- (void)transitionFlip
{
    [self transitionFlip:HBUITransitionDirectionRight];
}

- (void)transitionFlip:(HBUITransitionDirection)from
{
    [self transiteFor:self direction:from Type:@"oglFlip"];
}



- (void)transitionFade
{
    [self transitionFade:HBUITransitionDirectionRight];
}

- (void)transitionFade:(HBUITransitionDirection)from
{
    [self transiteFor:self direction:from Type:kCATransitionFade];
}

- (NSString *)CATransitionFrom:(HBUITransitionDirection)dir;
{
    if ( dir == HBUITransitionDirectionRight )
    {
        return kCATransitionFromRight;
    }
    else if ( dir == HBUITransitionDirectionLeft )
    {
        return kCATransitionFromLeft;
    }
    else if ( dir == HBUITransitionDirectionTop )
    {
        return kCATransitionFromTop;
    }
    else if ( dir == HBUITransitionDirectionBottom )
    {
        return kCATransitionFromBottom;
    }
    
    return kCATransitionFromRight;
}


- (void)transiteFor:(UIView *)container direction:(HBUITransitionDirection)direction  Type:(NSString *) type
{
    CATransition * animation = [CATransition animation];
    if ( animation )
    {
        if ([type isEqualToString:kCATransitionFade]) {
            [animation setDuration:0.2f];
        }
        else
        [animation setDuration:0.5f];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];//
        [animation setType:type];
        [animation setSubtype:[self CATransitionFrom:direction]];
        [animation setRemovedOnCompletion:YES];
        [container.layer addAnimation:animation forKey:@"animation"];
    }
}


- (void)transiteFor:(UIView *)container
          direction:(HBUITransitionDirection)direction
               Type:(NSString *) type
        repeatcount:(NSInteger)repeatcount
{
    CATransition * animation = [CATransition animation];
    if ( animation )
    {
        if ([type isEqualToString:kCATransitionFade]) {
            [animation setDuration:0.2f];
        }
        else
            [animation setDuration:2.f];
        
        [animation setRepeatCount:repeatcount];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        [animation setType:type];
        [animation setSubtype:[self CATransitionFrom:direction]];
        [animation setRemovedOnCompletion:YES];
        [container.layer addAnimation:animation forKey:@"animation"];
    }
}


//#pragma CATransition动画实现
//- (void) transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view
//{
//    //创建CATransition对象
//    CATransition *animation = [CATransition animation];
//    
//    //设置运动时间
//    animation.duration = 0.7f;
//    
//    //设置运动type
//    animation.type = type;
//    if (subtype != nil) {
//        
//        //设置子类
//        animation.subtype = subtype;
//    }
//    
//    //设置运动速度
//    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
//    
//    [view.layer addAnimation:animation forKey:@"animation"];
//    
//}

@end
