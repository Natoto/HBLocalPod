//
//  PPCircleProcessView.m
//  PPGPUImageTool
//
//  Created by zibin on 2017/4/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PPCircleProcessView.h"
#define PPCircleProcessView_ProcessWidth 5.0f
#define PPCircleProcessView_TimeMargin 0.1
#define PPCircleProcessView_DefaultMargin 20

#define PPColorRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
@interface PPCircleProcessView()
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CAShapeLayer *processLayer;
@property (nonatomic, assign) CGSize circleSize;
@property (nonatomic, copy) void(^processBlock)(NSInteger current);
@property (nonatomic, strong) UIImageView *centerView;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat timeCount;
@property (nonatomic, assign) CGFloat maxTime;
@end

@implementation PPCircleProcessView
- (instancetype)initWithMaxTime:(CGFloat)maxTime circleSize:(CGSize)circleSize callBackCurrentProcessTime:(void(^)(NSInteger current))processBlock;
{
   if(self = [super init])
   {
       self.circleSize = circleSize;
       self.processBlock = processBlock;
       if(maxTime == 0)
           maxTime = 15.0;
       self.maxTime = maxTime;
       [self.layer insertSublayer:self.circleLayer atIndex:0];
       [self.layer addSublayer:self.processLayer];
       [self addSubview:self.centerView];
   }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.circleLayer.frame = self.layer.bounds;
    self.processLayer.frame = self.layer.bounds;
    self.centerView.center = CGPointMake(self.circleSize.width *0.5, self.circleSize.height *0.5);
    
}


#pragma mark - handel
//开始动画
-(void)startAnimation
{
    self.timeCount = 0;
    _centerView.backgroundColor = self.strokeColor;
    _processLayer.strokeColor = self.strokeColor.CGColor;
    
       __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:1.0 animations:^{
       weakSelf.transform = CGAffineTransformScale(self.transform,1.2, 1.2);
       weakSelf.centerView.bounds = CGRectMake(0, 0, weakSelf.circleSize.width-PPCircleProcessView_DefaultMargin, weakSelf.circleSize.height-PPCircleProcessView_DefaultMargin);
    }];
    [self startTimer];
    
}

//停止动画
-(void)stopAnimation
{
    [self stopTimer];
    self.transform = CGAffineTransformIdentity;
    self.centerView.bounds = CGRectZero;
    self.processLayer.strokeEnd =0;
}

- (void)updateProcess
{
    self.timeCount +=PPCircleProcessView_TimeMargin;
    self.processLayer.strokeEnd += PPCircleProcessView_TimeMargin/self.maxTime;
    
    if(self.timeCount>=self.maxTime)
    {
        [self stopAnimation];
    }
    
}
- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:PPCircleProcessView_TimeMargin target:self selector:@selector(updateProcess) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer
{
    [self.timer invalidate];
     self.timer = nil;
    self.timeCount = 0;
}

#pragma mark - lazy
- (CAShapeLayer *)circleLayer
{
  if(_circleLayer == nil)
  {
      _circleLayer = [CAShapeLayer layer];
      UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.circleSize.width *0.5, self.circleSize.height *0.5) radius:self.circleSize.width *0.5 startAngle:0 endAngle:2 * M_PI clockwise:YES];
      _circleLayer.path = path.CGPath;
      _circleLayer.lineWidth = PPCircleProcessView_ProcessWidth;
      _circleLayer.fillColor = nil;
      _circleLayer.strokeColor = [UIColor whiteColor].CGColor;
  }
    return _circleLayer;
}

- (CAShapeLayer *)processLayer
{
  if(_processLayer == nil)
  {
      _processLayer = [CAShapeLayer layer];
      _processLayer.fillColor =nil;
      _processLayer.lineWidth = PPCircleProcessView_ProcessWidth;
      _processLayer.strokeColor = self.strokeColor.CGColor;
      _processLayer.strokeStart = 0;
      _processLayer.strokeEnd = 0;
      _processLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.circleSize.width, self.circleSize.height) cornerRadius:self.circleSize.width *0.5].CGPath;
  }
    return _processLayer;
}

-(UIColor *)strokeColor{
    if (!_strokeColor) {
        _strokeColor = PPColorRGB(33,201,152);
    }
    return _strokeColor;
}

-(UIImageView *)centerView
{
  if(_centerView == nil)
  {
      _centerView = [UIImageView new];
      _centerView.backgroundColor = self.strokeColor;
      _centerView.layer.cornerRadius = (self.circleSize.width-PPCircleProcessView_DefaultMargin) *0.5;
      _centerView.layer.masksToBounds = YES;
  }
    return _centerView;
}
@end
