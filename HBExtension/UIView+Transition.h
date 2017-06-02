//
//  UIView+Transition.h
//  HUANGBO
//
//  Created by HUANGBO on 15/3/26.
//  Copyright (c) 2015年 YY.COM All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    HBUITransitionDirectionRight,
    HBUITransitionDirectionLeft,
    HBUITransitionDirectionTop,
    HBUITransitionDirectionBottom
} HBUITransitionDirection;

typedef enum
{
    HBUITransitionTypeDefault,
    HBUITransitionTypeCube,
    HBUITransitionTypeFade,
    HBUITransitionTypeFlip,
    HBUITransitionTypePush
} HBUITransitionType;

@interface UIView(Transition)
//@property (nonatomic, retain) HBUITransition *	transition;

- (void)transitionFade;
- (void)transitionFade:(HBUITransitionDirection)from;

- (void)transitionCube;
- (void)transitionCube:(HBUITransitionDirection)from;

- (void)transitionPush;
- (void)transitionPush:(HBUITransitionDirection)from;

- (void)transitionFlip;
- (void)transitionFlip:(HBUITransitionDirection)from;

- (void)transitionMoveIn:(HBUITransitionDirection)from;

- (void)transiteFor:(UIView *)container
          direction:(HBUITransitionDirection)direction
               Type:(NSString *) type
        repeatcount:(NSInteger)repeatcount;
@end
