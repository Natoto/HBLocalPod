//
//  RedPoint.m
//  DZ
//
//  Created by Nonato on 14-6-9.
//  Copyright (c) 2014年 pengpeng. All rights reserved.
//

#import "RedPoint.h"

@implementation RedPoint

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor clearColor];
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{    
    [self drawCircleWithCenter:CGPointMake(rect.size.width/2, rect.size.height/2)
                        radius:rect.size.width/2];
}

//圆形
-(void)drawCircleWithCenter:(CGPoint)center
                     radius:(float)radius
{
    CGContextRef     context = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    CGPathAddArc(pathRef,
                 &CGAffineTransformIdentity,
                 center.x,
                 center.y,
                 radius,
                 -M_PI/2,
                 radius*2*M_PI-M_PI/2,
                 NO);
    CGPathCloseSubpath(pathRef);
    
    CGContextAddPath(context, pathRef);
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextFillPath(context);
    //    CGContextDrawPath(context,kCGPathFillStroke); //画空心圆 并且去掉前面两行
    CGPathRelease(pathRef);
}

@end
