//
//  StickerView.m
//  StickerDemo
//
//  Created by CKJ on 16/1/26.
//  Copyright © 2016年 CKJ. All rights reserved.
//

#import "HBStickerView.h"
#import "SingleHandGestureRecognizer.h"
#import "PPStickLabel.h"
#import "PPStickTextView.h"
#import "PPStickImageView.h"
#define kStickerControlViewSize 30
#define kStickerHalfControlViewSize 15

#define kStickerMinScale 0.5f
#define kStickerMaxScale 10.0f

@interface HBStickerView () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIImageView *deleteControl;
@property (strong, nonatomic) UIImageView *resizeControl;
@property (strong, nonatomic) UIImageView *rightTopControl;
@property (strong, nonatomic) UIImageView *leftBottomControl;

@property (strong, nonatomic) CAShapeLayer *shapeLayer;
@property (assign, nonatomic) BOOL enableRightTopControl;
@property (assign, nonatomic) BOOL enableLeftBottomControl;


@property (nonatomic, assign) CGAffineTransform  oldTransform;
@property (nonatomic, assign) CGPoint oldCenter;

@end

@implementation HBStickerView

#pragma mark - Initial


- (instancetype)initWithContentFrame:(CGRect)frame contentImage:(UIImage *)contentImage  {
    self = [super initWithFrame:CGRectMake(frame.origin.x - kStickerHalfControlViewSize, frame.origin.y - kStickerHalfControlViewSize, frame.size.width + kStickerControlViewSize, frame.size.height + kStickerControlViewSize)];
    if (self) {
        self.stickType = HBSTICK_IMAGE;
        self.contentView = [[UIImageView alloc] initWithFrame:CGRectMake(kStickerHalfControlViewSize, kStickerHalfControlViewSize, frame.size.width, frame.size.height)];
        self.contentImage = contentImage;
        [self addSubview:self.contentView];
        [self createsubviews];
    }
    return self;
}

- (instancetype)initWithContentFrame:(CGRect)frame contentImage:(UIImage *)contentImage isbgimage:(BOOL)isbg {
    self = [super initWithFrame:CGRectMake(frame.origin.x - kStickerHalfControlViewSize, frame.origin.y - kStickerHalfControlViewSize, frame.size.width + kStickerControlViewSize, frame.size.height + kStickerControlViewSize)];
    if (self) {
        if (isbg) {
            self.stickType = HBSTICK_BGIMAGE;
            self.contentView = [[PPStickImageView alloc] initWithFrame:CGRectMake(kStickerHalfControlViewSize, kStickerHalfControlViewSize, frame.size.width, frame.size.height)];
        }
        else{
        self.stickType = HBSTICK_IMAGE;
        self.contentView = [[UIImageView alloc] initWithFrame:CGRectMake(kStickerHalfControlViewSize, kStickerHalfControlViewSize, frame.size.width, frame.size.height)];
        }
        self.contentImage = contentImage;
        [self addSubview:self.contentView];
        [self createsubviews];
    }
    return self;
}
- (instancetype)initWithContentFrame:(CGRect)frame contentView:(UIView *)contentView {
    self = [super initWithFrame:CGRectMake(frame.origin.x - kStickerHalfControlViewSize, frame.origin.y - kStickerHalfControlViewSize, frame.size.width + kStickerControlViewSize, frame.size.height + kStickerControlViewSize)];
    if (self) {
        contentView.frame = CGRectMake(kStickerHalfControlViewSize, kStickerHalfControlViewSize, frame.size.width, frame.size.height);
        self.contentView = contentView;
        [self addSubview:self.contentView];
        [self createsubviews];
    }
    return self;
}

-(void)createsubviews{
    
    self.resizeControl = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.center.x + self.contentView.bounds.size.width / 2 - kStickerHalfControlViewSize, self.contentView.center.y + self.contentView.bounds.size.height / 2 - kStickerHalfControlViewSize, kStickerControlViewSize, kStickerControlViewSize)];
    self.resizeControl.image = [UIImage imageNamed:@"StickerView.bundle/btn_resize.png"];
    [self addSubview:self.resizeControl];
    
    self.deleteControl = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.center.x - self.contentView.bounds.size.width / 2 - kStickerHalfControlViewSize, self.contentView.center.y - self.contentView.bounds.size.height / 2 - kStickerHalfControlViewSize, kStickerControlViewSize, kStickerControlViewSize)];
    self.deleteControl.image = [UIImage imageNamed:@"StickerView.bundle/btn_delete.png"];
    [self addSubview:self.deleteControl];
    
    self.rightTopControl = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.center.x + self.contentView.bounds.size.width / 2 - kStickerHalfControlViewSize, self.contentView.center.y - self.contentView.bounds.size.height / 2 - kStickerHalfControlViewSize, kStickerControlViewSize, kStickerControlViewSize)];
    [self addSubview:self.rightTopControl];
    
    self.leftBottomControl = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.center.x - self.contentView.bounds.size.width / 2 - kStickerHalfControlViewSize, self.contentView.center.y + self.contentView.bounds.size.height / 2 - kStickerHalfControlViewSize, kStickerControlViewSize, kStickerControlViewSize)];
    [self addSubview:self.leftBottomControl];
    
    [self initShapeLayer];
    [self setupConfig];
    [self attachGestures];

}

#pragma mark - 创建文字贴纸

- (instancetype)initWithContentFrame:(CGRect)frame text:(NSString *)text {
    
    self = [super initWithFrame:CGRectMake(frame.origin.x - kStickerHalfControlViewSize, frame.origin.y - kStickerHalfControlViewSize, frame.size.width + kStickerControlViewSize, frame.size.height + kStickerControlViewSize)];
    if (self) {
        self.stickType = HBSTICK_TXT;
        PPStickLabel * label = [[PPStickLabel alloc] initWithFrame:CGRectMake(kStickerHalfControlViewSize, kStickerHalfControlViewSize, frame.size.width, frame.size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:40];
        label.adjustsFontSizeToFitWidth = YES;
        label.text = text;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.contentView = label;
        [self addSubview:self.contentView];
//        self.transform = CGAffineTransformScale(self.transform,1/9., 1/9);
        [self createsubviews];
    }
    return self;
}

-(BOOL)canBecomeFirstResponder{
    return [self.contentView canBecomeFirstResponder];
}
-(BOOL)becomeFirstResponder{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.oldCenter = self.center;
        NSLog(@"become: %.2f,%.2f",self.center.x,self.center.y);
        self.oldTransform = self.contentView.transform;
        self.contentView.transform = CGAffineTransformIdentity;
        [self relocalControlView:self.contentView.transform];
    }];
  return [self.contentView becomeFirstResponder];
}

-(BOOL)resignFirstResponder{
    
    [UIView animateWithDuration:0.5 animations:^{
        NSLog(@"resign:%.2f,%.2f,%@",self.center.x,self.center.y,[NSValue valueWithCGRect:self.frame]);
        self.center = self.oldCenter;
        self.contentView.transform = self.oldTransform;
        [self relocalControlView:self.contentView.transform];
    }]; 
    return [self.contentView resignFirstResponder];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    NSLog(@"layout: %.2f,%.2f",self.center.x,self.center.y);
}
- (void)initShapeLayer {
    _shapeLayer = [CAShapeLayer layer];
    CGRect shapeRect = self.contentView.frame;
    [_shapeLayer setBounds:shapeRect];
    [_shapeLayer setPosition:CGPointMake(self.contentView.frame.size.width / 2, self.contentView.frame.size.height / 2)];
    [_shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [_shapeLayer setStrokeColor:[[UIColor whiteColor] CGColor]];
    [_shapeLayer setLineWidth:2.0f];
    [_shapeLayer setLineJoin:kCALineJoinRound];
    _shapeLayer.allowsEdgeAntialiasing = YES;
    [_shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:5], [NSNumber numberWithInt:3], nil]];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, shapeRect);
    [_shapeLayer setPath:path];
    CGPathRelease(path);
}

- (void)setupConfig {
    self.exclusiveTouch = YES;
    
    self.userInteractionEnabled = YES;
    self.contentView.userInteractionEnabled = YES;
    self.resizeControl.userInteractionEnabled = YES;
    self.deleteControl.userInteractionEnabled = YES;
    self.rightTopControl.userInteractionEnabled = YES;
    self.leftBottomControl.userInteractionEnabled = YES;
    
    _enableRightTopControl = NO;
    _enableLeftBottomControl = NO;
    _enabledShakeAnimation = YES;
    self.enabledBorder = YES;
    
    self.enabledDeleteControl = YES;
    self.enabledControl = YES;
}

- (void)attachGestures {
    // ContentView
    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
    [rotateGesture setDelegate:self];
    [self.contentView addGestureRecognizer:rotateGesture];
    
    UIPinchGestureRecognizer *pinGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleScale:)];
    [pinGesture setDelegate:self];
    [self.contentView addGestureRecognizer:pinGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMove:)];
    [panGesture setMinimumNumberOfTouches:1];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [self.contentView addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setDelegate:self];
    [self.contentView addGestureRecognizer:tapRecognizer];
    
    // ResizeControl
    SingleHandGestureRecognizer *singleHandGesture = [[SingleHandGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleHandAction:) anchorView:self.contentView];
    [self.resizeControl addGestureRecognizer:singleHandGesture];
    
    // DeleteControl
    UITapGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tapRecognizer2 setNumberOfTapsRequired:1];
    [tapRecognizer2 setDelegate:self];
    [self.deleteControl addGestureRecognizer:tapRecognizer2];
    
    // RightTopControl
    UITapGestureRecognizer *tapRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tapRecognizer3 setNumberOfTapsRequired:1];
    [tapRecognizer3 setDelegate:self];
    [self.rightTopControl addGestureRecognizer:tapRecognizer3];
    
    // LeftBottomControl
    UITapGestureRecognizer *tapRecognizer4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tapRecognizer4 setNumberOfTapsRequired:1];
    [tapRecognizer4 setDelegate:self];
    [self.leftBottomControl addGestureRecognizer:tapRecognizer4];
}

#pragma mark - Handle Gestures

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    if (gesture.view == self.contentView) {
        [self handleTapContentView];
    } else if (gesture.view == self.deleteControl) {
        if (_enabledDeleteControl) {
            // Default : remove from super view.
            [self removeFromSuperview];
            if (_delegate && [_delegate respondsToSelector:@selector(stickerViewDidTapDeleteControl:)]) {
                [_delegate stickerViewDidTapDeleteControl:self];
            }
        }
    } else if (gesture.view == self.rightTopControl) {
        if (_enableRightTopControl) {
            if (_delegate && [_delegate respondsToSelector:@selector(stickerViewDidTapRightTopControl:)]) {
                [_delegate stickerViewDidTapRightTopControl:self];
            }
        }
    } else if (gesture.view == self.leftBottomControl) {
        if (_enableLeftBottomControl) {
            if (_delegate && [_delegate respondsToSelector:@selector(stickerViewDidTapLeftBottomControl:)]) {
                [_delegate stickerViewDidTapLeftBottomControl:self];
            }
        }
    }
}

- (void)handleTapContentView {
    [self.superview bringSubviewToFront:self];
    // Perform animation
    if (_enabledShakeAnimation) {
        [self performShakeAnimation:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(stickerViewDidTapContentView:)]) {
        [_delegate stickerViewDidTapContentView:self];
    }
}

- (void)handleMove:(UIPanGestureRecognizer *)gesture {

    CGPoint translation = [gesture translationInView:[self superview]];
    // Boundary detection
    CGPoint targetPoint = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    CGPoint targetPoint2 = targetPoint;
    
    targetPoint.x = MAX(0, targetPoint.x);
    targetPoint.y = MAX(0, targetPoint.y);
    targetPoint.x = MIN(self.superview.bounds.size.width, targetPoint.x);
    targetPoint.y = MIN(self.superview.bounds.size.height, targetPoint.y);
    
    [self setCenter:targetPoint];
    
    
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(stickerViewMovingControl:center:)]) {
            [_delegate stickerViewMovingControl:self center:targetPoint2];
        }
        
    }else if (gesture.state == UIGestureRecognizerStateEnded) {        
        if (_delegate && [_delegate respondsToSelector:@selector(stickerViewEndMoveControl:center:)]) {
            [_delegate stickerViewEndMoveControl:self center:targetPoint2];
        }
    }
    [gesture setTranslation:CGPointZero inView:[self superview]];
  
}

- (void)handleScale:(UIPinchGestureRecognizer *)gesture {
    
    CGFloat scale = gesture.scale;
    // Scale limit
    CGFloat currentScale = [[self.contentView.layer valueForKeyPath:@"transform.scale"] floatValue];
    if (scale * currentScale <= kStickerMinScale) {
        scale = kStickerMinScale / currentScale;
    } else if (scale * currentScale >= kStickerMaxScale) {
        scale = kStickerMaxScale / currentScale;
    }
    self.contentView.transform = CGAffineTransformScale(self.contentView.transform, scale, scale);
    gesture.scale = 1;
    [self relocalControlView:self.contentView.transform];
  
}
- (void)handleRotate:(UIRotationGestureRecognizer *)gesture {
    self.contentView.transform = CGAffineTransformRotate(self.contentView.transform, gesture.rotation);
    gesture.rotation = 0;
    [self relocalControlView:self.contentView.transform];
}

- (void)handleSingleHandAction:(SingleHandGestureRecognizer *)gesture {
    CGFloat scale = gesture.scale;
    // Scale limit
    CGFloat currentScale = [[self.contentView.layer valueForKeyPath:@"transform.scale"] floatValue];
    if (scale * currentScale <= kStickerMinScale) {
        scale = kStickerMinScale / currentScale;
    } else if (scale * currentScale >= kStickerMaxScale) {
        scale = kStickerMaxScale / currentScale;
    }

    self.contentView.transform = CGAffineTransformScale(self.contentView.transform, scale, scale);
    self.contentView.transform = CGAffineTransformRotate(self.contentView.transform, gesture.rotation);
    [gesture reset];
    
    [self relocalControlView:self.contentView.transform];
}

- (void)relocalControlView:(CGAffineTransform)transform {
    CGPoint originalCenter = CGPointApplyAffineTransform(self.contentView.center, CGAffineTransformInvert(transform));
    self.resizeControl.center = CGPointApplyAffineTransform(CGPointMake(originalCenter.x + self.contentView.bounds.size.width / 2.0f, originalCenter.y + self.contentView.bounds.size.height / 2.0f), transform);
    self.deleteControl.center = CGPointApplyAffineTransform(CGPointMake(originalCenter.x - self.contentView.bounds.size.width / 2.0f, originalCenter.y - self.contentView.bounds.size.height / 2.0f), transform);
    self.rightTopControl.center = CGPointApplyAffineTransform(CGPointMake(originalCenter.x + self.contentView.bounds.size.width / 2.0f, originalCenter.y - self.contentView.bounds.size.height / 2.0f), transform);
    self.leftBottomControl.center = CGPointApplyAffineTransform(CGPointMake(originalCenter.x - self.contentView.bounds.size.width / 2.0f, originalCenter.y + self.contentView.bounds.size.height / 2.0f), transform);
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - Hit Test

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.hidden || !self.userInteractionEnabled || self.alpha < 0.01) {
        return nil;
    }
    if (_enabledControl) {
        if ([self.resizeControl pointInside:[self convertPoint:point toView:self.resizeControl] withEvent:event]) {
            return self.resizeControl;
        }
        if (_enabledDeleteControl && [self.deleteControl pointInside:[self convertPoint:point toView:self.deleteControl] withEvent:event]) {
            return self.deleteControl;
        }
        if (_enableRightTopControl && [self.rightTopControl pointInside:[self convertPoint:point toView:self.rightTopControl] withEvent:event]) {
            return self.rightTopControl;
        }
        if (_enableLeftBottomControl && [self.leftBottomControl pointInside:[self convertPoint:point toView:self.leftBottomControl] withEvent:event]) {
            return self.leftBottomControl;
        }
    }
    if ([self.contentView pointInside:[self convertPoint:point toView:self.contentView] withEvent:event]) {
        return self.contentView;
    }
    // return nil for other area.
    return nil;
}

#pragma mark - Other

- (void)performShakeAnimation:(UIView *)targetView {
    [targetView.layer removeAnimationForKey:@"anim"];
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5f;
    animation.values = @[[NSValue valueWithCATransform3D:targetView.layer.transform],
                         [NSValue valueWithCATransform3D:CATransform3DScale(targetView.layer.transform, 1.05, 1.05, 1.0)],
                         [NSValue valueWithCATransform3D:CATransform3DScale(targetView.layer.transform, 0.95, 0.95, 1.0)],
                         [NSValue valueWithCATransform3D:targetView.layer.transform]
                         ];
    animation.removedOnCompletion = YES;
    [targetView.layer addAnimation:animation forKey:@"anim"];
}

- (void)performTapOperation {
    [self handleTapContentView];
}

#pragma mark - Property

- (void)setDelegate:(id<StickerViewDelegate>)delegate {
    if (delegate == nil) {
        NSAssert(delegate, @"Delegate shounldn't be nil!");
        return;
    }
    _delegate = delegate;
    
    if ([_delegate respondsToSelector:@selector(stickerView:imageForRightTopControl:)]) {
        UIImage *rightTopImage = [_delegate stickerView:self imageForRightTopControl:CGSizeMake(kStickerControlViewSize, kStickerControlViewSize)];
        if (rightTopImage) {
            self.rightTopControl.image = rightTopImage;
            _enableRightTopControl = YES;
        }
    }
    if ([_delegate respondsToSelector:@selector(stickerView:imageForLeftBottomControl:)]) {
        UIImage *leftBottomImage = [_delegate stickerView:self imageForLeftBottomControl:CGSizeMake(kStickerControlViewSize, kStickerControlViewSize)];
        if (leftBottomImage) {
            self.leftBottomControl.image = leftBottomImage;
            _enableLeftBottomControl = YES;
        }
    }
}

- (void)setEnabledDeleteControl:(BOOL)enabledDeleteControl {
    _enabledDeleteControl = enabledDeleteControl;
    if (_enabledControl && _enabledDeleteControl) {
        self.deleteControl.hidden = NO;
    } else {
        self.deleteControl.hidden = YES;
    }
}

- (void)setEnabledControl:(BOOL)enabledControl {
    _enabledControl = enabledControl;
    self.deleteControl.hidden = _enabledControl ? !_enabledDeleteControl : YES;
    self.resizeControl.hidden = !_enabledControl;
    self.rightTopControl.hidden = !_enabledControl;
    self.leftBottomControl.hidden = !_enabledControl;
}

- (void)setEnabledBorder:(BOOL)enabledBorder {
    _enabledBorder = enabledBorder;
    if (_enabledBorder) {
        [self.contentView.layer addSublayer:self.shapeLayer];
    } else {
        [self.shapeLayer removeFromSuperlayer];
    }
}
-(void)setFrame:(CGRect)frame{

    [super setFrame:frame];
    if (self.enabledBorder) {
        [_shapeLayer removeFromSuperlayer];
        [self initShapeLayer];
    }
    else{
        [_shapeLayer removeFromSuperlayer];
    }
}
- (void)setContentImage:(UIImage *)contentImage {
    _contentImage = contentImage;
    if ([[self.contentView class] isSubclassOfClass:[UIImageView class]]) {
        UIImageView * imgview = (UIImageView *)self.contentView;
        imgview.image = _contentImage;
    }

}

@end
