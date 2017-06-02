//
//  UIView+Transition.m
//  HUANGBO
//
//  Created by HUANGBO on 15/3/26.
//  Copyright (c) 2015年 YY.COM All rights reserved.
//

#import "UIView+Transition.h"

@implementation UIView(Transition)

/**
 * 渐变切换
 */
- (void)startTransitionAnimation {
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.layer addAnimation:transition forKey:nil];
}
/**
 * 放大缩小
 */
- (void)startDuangAnimation {
    CGRect frame = self.frame;
    UIViewAnimationOptions op = UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState;
    [self.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [UIView animateWithDuration:0.15 delay:0 options:op animations:^{
        [self.layer setValue:@(0.80) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0 options:op animations:^{
            [self.layer setValue:@(1.3) forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 delay:0 options:op animations:^{
                [self.layer setValue:@(1) forKeyPath:@"transform.scale"];
                self.frame = frame;
            } completion:NULL];
        }];
    }];
}

-(void)rotateAnimation{
    
    CABasicAnimation* rotationAnimation;
     rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
     rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 1.0 ];
     rotationAnimation.duration = 0.5;
     rotationAnimation.cumulative = YES;
     rotationAnimation.repeatCount = 1;
     [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

    
//    /* 旋转 */
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"]; // 一次完整的动画所持续的时间
//    animation.duration = 1.f; // 重复次数
//    animation.repeatCount = HUGE_VALF; // 起始角度
//    animation.fromValue = [NSNumber numberWithFloat:0.0];
//    // 终止角度
//    animation.toValue = [NSNumber numberWithFloat:- 2 * M_PI]; // 添加动画
//    [self.layer addAnimation:animation forKey:@"rotate-layer"];
}

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
