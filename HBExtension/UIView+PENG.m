//
//  UIView+PENG.m
//  PENG
//
//  Created by zeno on 15/9/24.
//  Copyright © 2015年 nonato. All rights reserved.
//

#import "UIView+PENG.h"
//#import "PENG_Define.h"
#import <objc/runtime.h>


#ifndef KT_UIColorWithRGB
#define KT_UIColorWithRGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#endif

#define PENG_COLOR_LINE  KT_UIColorWithRGB(219, 219, 219) //219 219 219

@implementation UIView(PENGPENG)
@dynamic viewtoplayer;
@dynamic viewbottomlayer;
@dynamic viewleftlayer;
@dynamic viewrightlayer;



/**
 * 假设要加载的Class为MyNibView,
 xib中必须将File Owner设置成NSObject而非MyNibView！这里我还不是很清楚什么原因，估计是由于Nib的file owner为nil或者其他值
 将顶层的UIView的class设置成MyNibView，并通过他设置IBOutlet的映射关系。
 顶层的UIView则会被加载后放到数组的第一个位置。
 */
+ (id)viewFromNib{
    
    UIView *result = nil;
    NSArray * array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    for (id anObject in array) {
        if ([anObject isKindOfClass:[self class]]){
            result = anObject;
            break;
        }
    }
    return result;
    
}

/**
 *  清除顶部分割线
 */
-(void)cleartopLayer
{
    CALayer *imageLayer = self.viewtoplayer;
    if (imageLayer) {
        imageLayer = [self createviewLayer:CGRectMake(0, 0, self.bounds.size.width, 0.5) color:[UIColor clearColor]];
        [self.layer replaceSublayer:self.viewtoplayer with:imageLayer];
        self.viewtoplayer = nil;
    }
}

-(void)drawtoplinelayer
{
    CALayer *imageLayer = self.viewtoplayer;
    if (!imageLayer) {
        imageLayer =  [self createviewLayer:CGRectMake(0, 0, self.bounds.size.width, 0.5) color:PENG_COLOR_LINE];
        [self.layer addSublayer:imageLayer];
        self.viewtoplayer = imageLayer;
    }
}


/**
 *  清除底部分割线
 */
-(void)clearviewbottomlayer
{
    CALayer *imageLayer = self.viewbottomlayer;
    if (imageLayer) {
        imageLayer =  [self createviewLayer:CGRectMake(0, self.frame.size.height - 0.5, self.bounds.size.width, 0.5) color:[UIColor clearColor]];
        [self.layer replaceSublayer:self.viewbottomlayer with:imageLayer];
        self.viewbottomlayer = nil;
    }
}

-(void)drawbottomlinelayer
{
    CALayer *imageLayer = self.viewbottomlayer;
    if (!imageLayer) {
        imageLayer =  [self createviewLayer:CGRectMake(0, self.frame.size.height - 0.5, self.bounds.size.width, 0.5) color:PENG_COLOR_LINE];
        [self.layer addSublayer:imageLayer];
        self.viewbottomlayer = imageLayer;
    }
}



/**
 *  清除左边部分割线
 */
-(void)clearleftlayer
{
    CALayer *imageLayer = self.viewleftlayer;
    if (imageLayer) {
        imageLayer =  [self createviewLayer:CGRectMake(0, 0, 0.5, self.frame.size.height) color:[UIColor clearColor]];
        [self.layer replaceSublayer:self.viewleftlayer with:imageLayer];
        self.viewleftlayer = nil;
    }
}

-(void)drawleftlayer
{
    CALayer *imageLayer = self.viewleftlayer;
    if (!imageLayer) {
        imageLayer =  [self createviewLayer:CGRectMake(0, 0, 0.5, self.frame.size.height) color:PENG_COLOR_LINE];
        [self.layer addSublayer:imageLayer];
        self.viewleftlayer = imageLayer;
    }
}



/**
 *  清除右边部分割线
 */
-(void)clearrightlayer
{
    CALayer *imageLayer = self.viewrightlayer;
    if (imageLayer) {
        imageLayer =  [self createviewLayer:CGRectMake(self.frame.size.width - 0.5, 0, 0.5, self.frame.size.height) color:[UIColor clearColor]];
        [self.layer replaceSublayer:self.viewrightlayer with:imageLayer];
        self.viewrightlayer = nil;
    }
}

-(void)drawrightlayer
{
    CALayer *imageLayer = self.viewrightlayer;
    if (!imageLayer) {
        imageLayer =  [self createviewLayer:CGRectMake(self.frame.size.width - 0.5, 0, 0.5, self.frame.size.height) color:PENG_COLOR_LINE];
        [self.layer addSublayer:imageLayer];
        self.viewrightlayer = imageLayer;
    }
}


-(CALayer *)createviewLayer:(CGRect)frame color:(UIColor *)color
{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = frame; //CGRectMake(0, 0, UISCREEN_WIDTH, 0.5);
    imageLayer.cornerRadius = 0;  //设置layer圆角半径
    imageLayer.masksToBounds = YES;  //隐藏边界
    imageLayer.borderColor = color.CGColor;//[UIColor colorWithWhite:0.6 alpha:0.8].CGColor;  //边框颜色
    imageLayer.borderWidth = 0.5;
    return imageLayer;
}

static char  key_toplayer_p;
static char  key_viewbottomlayer_p;
static char  key_leftlayer_p;
static char  key_rightlayer_p;

-(CALayer *)viewleftlayer
{
    CALayer * layer = (CALayer *)objc_getAssociatedObject(self, &key_leftlayer_p);
    return layer;
}

-(void)setViewleftlayer:(CALayer *)viewleftlayer
{
    objc_setAssociatedObject(self, &key_leftlayer_p, viewleftlayer, OBJC_ASSOCIATION_RETAIN);
}

-(CALayer *)viewrightlayer
{
    CALayer * layer = (CALayer *)objc_getAssociatedObject(self, &key_rightlayer_p);
    return layer;
}

-(void)setViewrightlayer:(CALayer *)rightlayer
{
    objc_setAssociatedObject(self, &key_rightlayer_p, rightlayer, OBJC_ASSOCIATION_RETAIN);
}

-(CALayer *)viewtoplayer
{
    CALayer * layer = (CALayer *)objc_getAssociatedObject(self, &key_toplayer_p);
    return layer;
}

-(void)setViewtoplayer:(CALayer *)toplayer
{
    objc_setAssociatedObject(self, &key_toplayer_p, toplayer, OBJC_ASSOCIATION_RETAIN);
}
-(CALayer *)viewbottomlayer
{
    CALayer * layer = (CALayer *)objc_getAssociatedObject(self, &key_viewbottomlayer_p);
    return layer;
}

-(void)setViewbottomlayer:(CALayer *)viewbottomlayer
{
    objc_setAssociatedObject(self, &key_viewbottomlayer_p, viewbottomlayer, OBJC_ASSOCIATION_RETAIN);
}

-(void)setcornerRadius:(CGFloat )cornerRadius
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    [self layoutIfNeeded];
}

-(void)setppcornerRadius:(CGFloat )cornerRadius
{
    CAShapeLayer *mask = (CAShapeLayer *)self.layer.mask;
    if (nil == mask) {
        mask = [CAShapeLayer layer];\
         mask.fillColor = [UIColor blackColor].CGColor;\
        self.layer.mask = mask;
    }
    mask.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds  cornerRadius:cornerRadius].CGPath;
    
//    UIImage * snapshot = [self kt_drawRectWithRoundedCorner:cornerRadius borderWidth:0 backgroundColor:[UIColor clearColor] borderColor:[UIColor blackColor]];
//    //[UIImage hb_drawRectWithRoundedCornerWithImage:[UIImage snapshotImageAfterScreenUpdates:YES WithView:self] Corner:cornerRadius size:self.bounds.size];
//    UIImageView * imageview = [self viewWithTag:0xffff];
//    if (!imageview) {
//         imageview = [[UIImageView  alloc] initWithImage:snapshot];
//        imageview.tag = 0xffff;
//        [self addSubview:imageview];
//    }
//    imageview.image = snapshot;
}

-(void)setppcornerRadius:(CGFloat )cornerRadius strokeColor:(UIColor *)strokeColor
{ 
    CAShapeLayer *acircle = [CAShapeLayer layer];\
    acircle.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds  cornerRadius:cornerRadius].CGPath;\
    acircle.fillColor = [UIColor blackColor].CGColor;\
    self.layer.mask = acircle;
    
//    //带光圈的
//    CAShapeLayer *borderLayer=[CAShapeLayer layer];
//    borderLayer.path    =   acircle.path;
//    borderLayer.fillColor  = [UIColor clearColor].CGColor;
//    borderLayer.strokeColor    = strokeColor.CGColor;//[UIColor redColor].CGColor;
//    borderLayer.lineWidth      = 1;
//    borderLayer.frame = self.bounds;
//    [self.layer addSublayer:borderLayer];
}


-(void)setlayercolor:(UIColor *)color
{
    self.layer.masksToBounds = YES;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 0.5;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#ifndef kt_HEXCOLORA
#define KT_HEXCOLORA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
#endif

+(UIView *)BigButtonview:(CGRect)frame btnframe:(CGRect)buttonFrame title:(NSString *)title target:(id)target sel:(SEL)selector
{
    UIView * view = [[UIView alloc] initWithFrame:frame];
    //    frame.origin.x = 10;
    //    frame.origin.y = 10;
    //    frame.size.height = frame.size.height - 15;
    //    frame.size.width = frame.size.width - 20;
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom]; //[[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame=frame;
    button.showsTouchWhenHighlighted = YES;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    button.backgroundColor = KT_HEXCOLORA(0X00a0a3,1);
    button.layer.cornerRadius = 5;
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return view;
}

- (id)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
    }
    return nil;
}



-(void)yy_show{
    [self yy_show:YES];
}

-(void)yy_show:(BOOL)animate{
    if (animate) {
        UIWindow * window = [UIApplication sharedApplication].windows.firstObject;
        [window addSubview:self];
        [UIView animateWithDuration:.3 animations:^{
            self.alpha = 1;
        }];
    }else{
        UIWindow * window = [UIApplication sharedApplication].windows.firstObject;
        [window addSubview:self];
        self.alpha = 1;
    }
    
}

-(void)yy_hide{
    [self yy_hide:YES];
}

-(void)yy_hide:(BOOL)animate{
    if (animate) {
        [UIView animateWithDuration:.3 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else{
        self.alpha = 0;
        [self removeFromSuperview];
    }
    
}

-(void)addgradientlayer:(UIColor *)fromcolor tocolor:(UIColor *)tocolor {
    UIColor * _inputColor0 = fromcolor;//[UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    UIColor * _inputColor1 = tocolor;//[UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    CGPoint _inputPoint0 = CGPointMake(1, 1);
    CGPoint _inputPoint1 = CGPointMake(1, 0);
    CAGradientLayer *layer = [CAGradientLayer new];
    layer.colors = @[(__bridge id)_inputColor0.CGColor, (__bridge id)_inputColor1.CGColor];
    layer.startPoint = _inputPoint0;
    layer.endPoint = _inputPoint1;
    layer.frame = self.bounds;
    self.backgroundColor = [UIColor clearColor];//[UIColor colorWithWhite:1 alpha:.1];
    [self.layer insertSublayer:layer atIndex:0];
}
@end


//-(UIImage *)kt_drawRectWithRoundedCorner:(CGFloat)radius borderWidth:(CGFloat)borderWidth //(radius radius: CGFloat,
//backgroundColor: (UIColor *)backgroundColor
//borderColor: (UIColor *) borderColor{
//    CGSize sizeToFit = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
//    CGFloat halfBorderWidth = borderWidth/ 2.0;
//    
//    UIGraphicsBeginImageContextWithOptions(sizeToFit, false, [UIScreen mainScreen].scale);
//    CGContextRef  context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, borderWidth);
//    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
//    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
//    
//    CGFloat width = sizeToFit.width, height = sizeToFit.height;
//    CGContextMoveToPoint(context, width - halfBorderWidth, radius + halfBorderWidth) ; // 开始坐标右边开始
//    CGContextAddArcToPoint(context, width - halfBorderWidth, height - halfBorderWidth, width - radius - halfBorderWidth, height - halfBorderWidth, radius);  // 右下角角度
//    CGContextAddArcToPoint(context, halfBorderWidth, height - halfBorderWidth, halfBorderWidth, height - radius - halfBorderWidth, radius); // 左下角角度
//    CGContextAddArcToPoint(context, halfBorderWidth, halfBorderWidth, width - halfBorderWidth, halfBorderWidth, radius); // 左上角
//    CGContextAddArcToPoint(context, width - halfBorderWidth, halfBorderWidth, width - halfBorderWidth, radius + halfBorderWidth, radius); // 右上角
//    
//    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
//    UIImage * output = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return output;
//}
//@implementation UIImage(uiviewpeng)
//
//+(UIImage *)hb_drawRectWithRoundedCornerWithImage:(UIImage *)image Corner:(CGFloat)radius size:(CGSize)size
//{
//    
//    CGRect rect = CGRectMake(0, 0, size.width, size.height);
//    UIGraphicsBeginImageContextWithOptions(rect.size, false, [UIScreen mainScreen].scale);
//    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)].CGPath);
//    CGContextClip(UIGraphicsGetCurrentContext());
//    [image drawInRect:rect];
//    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
//    UIImage * output = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return output;
//}
//
//+ (UIImage *)snapshotImageWithView:(UIView *)view {
//    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0);
//    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return snap;
//}
//
//+(UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates WithView:(UIView *)view {
//    if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
//        return [self snapshotImageWithView:view];
//    }
//    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0);
//    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:afterUpdates];
//    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return snap;
//}
//
//@end
//
