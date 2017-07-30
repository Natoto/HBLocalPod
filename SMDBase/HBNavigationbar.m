//
//  HBNavigationbar.m
//  JXL
//
//  Created by BooB on 15-4-18.
//  Copyright (c) 2015年 BooB. All rights reserved.
//

#import "HBNavigationbar.h" 
//#import <Masonry/Masonry.h>

const int tag_hbnavigation_title = 4240024;

@interface UIView(navigationbar)
@property(nonatomic,assign) CGFloat bottom;
@end

@implementation UIView(navigationbar)
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


@end

@interface HBNavigationbar()
{
    CALayer *topLayer;
    CALayer *bottomLayer ;
}
@end

#ifndef  UISCREEN_WIDTH
#define UISCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#endif

#ifndef  KT_UIColorWithRGB
#define KT_UIColorWithRGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#endif

@implementation HBNavigationbar
@synthesize leftItem = _leftItem;
@synthesize rightItem = _rightItem; 
@synthesize titleView = _titleView;
@synthesize TintColor = _TintColor;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES;
        self.backgroundColor = [UIColor colorWithRed:234./255.0 green:234./255.0 blue:234./255.0 alpha:1.0f];
        [self addSubview:self.leftItem];
        [self addSubview:self.rightItem];
        [self addSubview:self.titleView];
        
        CGFloat BAR_HEIGHT = 44;
        CGFloat ITEM_WIDTH = 100;
        CGFloat STATUS_HEIGHT = 20;
        [self drawbottomlinelayer];
        [self leftItem];
        if (self.leftItem) {
            self.leftItem.frame = CGRectMake(10, 5, 60, BAR_HEIGHT);
        }
        if (self.rightItem) {
            self.rightItem.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - ITEM_WIDTH - 5 , 0, ITEM_WIDTH, BAR_HEIGHT);
        }
        
        self.leftItem.bottom = self.bottom; //CGPointMake( ITEM_WIDTH/2 + 10,STATUS_HEIGHT + BAR_HEIGHT/2);
        self.rightItem.center = CGPointMake( [UIScreen mainScreen].bounds.size.width - ITEM_WIDTH/2  , BAR_HEIGHT/2 + STATUS_HEIGHT);
        
        if (self.titleView ) {
            self.titleView.frame = CGRectMake(0, 0, 200, BAR_HEIGHT);
            self.titleView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, BAR_HEIGHT/2 + STATUS_HEIGHT);
        }
    }
    return self;
}

+(HBNavigationbar *)navigationbar
{
    CGFloat BAR_HEIGHT = 44;
    CGFloat STATUS_HEIGHT = 20;
    HBNavigationbar * navbar = [[HBNavigationbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, BAR_HEIGHT + STATUS_HEIGHT)];
    return navbar;
}

+(HBNavigationbar *)navigationtoolbar
{
    CGFloat BAR_HEIGHT = 44;
    CGFloat ITEM_WIDTH = 50;
    CGFloat STATUS_HEIGHT = 0;
    HBNavigationbar * navbar = [[HBNavigationbar alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, BAR_HEIGHT + STATUS_HEIGHT)];
    [navbar drawtoplinelayer];
    [navbar leftItem];
    if (navbar.leftItem) {
        navbar.leftItem.frame = CGRectMake(10, 5, ITEM_WIDTH, BAR_HEIGHT);
    }
    
    if (navbar.rightItem) {
        navbar.rightItem.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 50 , 0, ITEM_WIDTH, BAR_HEIGHT);
    }
    
    navbar.leftItem.center = CGPointMake( ITEM_WIDTH/2 + 10,STATUS_HEIGHT + BAR_HEIGHT/2);
    navbar.rightItem.center = CGPointMake( [UIScreen mainScreen].bounds.size.width - ITEM_WIDTH/2 , BAR_HEIGHT/2 + STATUS_HEIGHT);

    if (navbar.titleView ) {
        navbar.titleView.frame = CGRectMake(0, 0, 200, BAR_HEIGHT);
        navbar.titleView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, BAR_HEIGHT/2 + STATUS_HEIGHT);
    }
    return navbar;
}

/**
 *  清除底部分割线
 */
-(void)clearBottomLayer
{
    CALayer *imageLayer = bottomLayer;
    if (imageLayer) {
        imageLayer =  [self createLayer:CGRectMake(0, self.frame.size.height - 0.5, UISCREEN_WIDTH, 0.5) color:[UIColor clearColor]];
        [self.layer replaceSublayer:bottomLayer with:imageLayer];
        bottomLayer = nil;
    }
}

-(void)drawbottomlinelayer
{
    CALayer *imageLayer = bottomLayer;
    if (!imageLayer) {
        CALayer *imageLayer =  [self createLayer:CGRectMake(0, self.frame.size.height - 0.5, UISCREEN_WIDTH, 0.5) color:KT_UIColorWithRGB(204, 204, 204)];
        [self.layer addSublayer:imageLayer];
        bottomLayer = imageLayer;
    }
}

/**
 *  清除顶部分割线
 */
-(void)clearTopLayer
{
    CALayer *imageLayer = topLayer;
    if (imageLayer) {
        imageLayer = [self createLayer:CGRectMake(0, 0, UISCREEN_WIDTH, 0.5) color:[UIColor clearColor]];
        [self.layer replaceSublayer:topLayer with:imageLayer];
        topLayer = nil;
    }
}
-(void)drawtoplinelayer
{
    CALayer *imageLayer = topLayer;
    if (!imageLayer) {// [UIColor colorWithWhite:0.6 alpha:0.8]
        CALayer *imageLayer =  [self createLayer:CGRectMake(0, 0, UISCREEN_WIDTH, 0.5) color:KT_UIColorWithRGB(219, 219, 219)];
        [self.layer addSublayer:imageLayer];
        topLayer = imageLayer;
    }
}


-(CALayer *)createLayer:(CGRect)frame color:(UIColor *)color
{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = frame; //CGRectMake(0, 0, UISCREEN_WIDTH, 0.5);
    imageLayer.cornerRadius = 0;  //设置layer圆角半径
    imageLayer.masksToBounds = YES;  //隐藏边界
    imageLayer.borderColor = color.CGColor;//[UIColor colorWithWhite:0.6 alpha:0.8].CGColor;  //边框颜色
    imageLayer.borderWidth = 0.5;
    return imageLayer;
}
-(void)setLeftItem:(UIControl *)leftItem
{
    if (leftItem!=_leftItem) {
        [_leftItem removeFromSuperview];
        _leftItem = leftItem;
        [self addSubview:_leftItem];
    }
}

-(UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIControl alloc] init];
    }
    return _titleView;
}
-(UIView *)leftItem
{
    if (!_leftItem) {
        _leftItem = [[UIControl alloc] init];
//        _leftItem.backgroundColor = HBRandomColor;
    }
    return _leftItem;
}

-(void)setRightItem:(UIControl *)rightItem
{
    if (rightItem!=_rightItem) {
        [_rightItem removeFromSuperview];
        _rightItem = rightItem;
        [self addSubview:_rightItem];
    }
}

-(UIView *)rightItem
{
    if (!_rightItem) {
        _rightItem = [[UIControl alloc] init];
//        _rightItem.backgroundColor = HBRandomColor;
    }
    return _rightItem;
}

-(void)setTitleView:(UIView *)titleView
{
    if (titleView != _titleView) {
        CGRect frame = self.titleView.frame;
        [_titleView removeFromSuperview];
         _titleView = titleView;
        _titleView.frame = frame;
        _titleView.tag = tag_hbnavigation_title;
        [self addSubview:_titleView];
        [_titleView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    }
}
-(UIColor *)TintColor{
    
    if (!_TintColor) {
        _TintColor = [UIColor whiteColor];
    }
    return _TintColor;
}
-(void)setTintColor:(UIColor *)tintColor
{
    _TintColor = tintColor;
    UILabel * lbl = (UILabel *)[self.titleView viewWithTag:tag_hbnavigation_title];
    if (lbl) {
        lbl.textColor = tintColor;
    }
}

-(void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
    UILabel * lbl = (UILabel *)[self.titleView viewWithTag:tag_hbnavigation_title];
    if (lbl) {
        lbl.font = titleFont;
    }
}
-(void)setTitle:(NSString *)title
{
    _title = title;
    CGRect frame = self.titleView.frame;
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor =  self.TintColor;
    label.font = [UIFont boldSystemFontOfSize:18.];;
    label.text = title;
    label.tag = tag_hbnavigation_title;
    [self.titleView removeFromSuperview];
    self.titleView = label;
    [self addSubview:self.titleView];
}


-(void)setText:(NSString *)text
{
    [self setTitle:text];
}

-(NSString *)text
{
    return [self title];
}
+(UIImage *)defaultbackImage
{
    UIImage * image = [UIImage imageNamed:@"fanhui"];
    return image;
}

-(UIButton *)setrightBarButtonItemWithImage:(UIImage *)image target:(id)target selector:(SEL)selector
{
  return [self setBarButtonItemWithImage:image leftbar:NO target:target selector:selector];
}

-(UIButton *)setrightBarButtonItemWithTitle:(NSString *)title target:(id)target selector:(SEL)selector
{
   return [self setBarButtonItemWithTitle:title leftbar:NO target:target selector:selector];
}

-(UIButton *)setleftBarButtonItemWithImage:(UIImage *)image target:(id)target selector:(SEL)selector
{
   return [self setBarButtonItemWithImage:image leftbar:YES target:target selector:selector];
}

-(UIButton *)setleftBarButtonItemWithTitle:(NSString *)title target:(id)target selector:(SEL)selector
{
   return [self setBarButtonItemWithTitle:title leftbar:YES target:target selector:selector];
}

-(UIButton *)setBarButtonItemWithTitle:(NSString *)title leftbar:(BOOL)left target:(id)target selector:(SEL)selector
{
   return [self setBarButtonItemWithTitle:title image:nil leftbar:left target:target selector:selector];
}
 

-(UIButton *)setBarButtonItemWithTitle:(NSString *)title image:(UIImage *)image leftbar:(BOOL)left target:(id)target selector:(SEL)selector
{
    
    UIButton *button = [UIButton new];
    button.titleLabel.font = [UIFont systemFontOfSize:16.];
    if (!image && title) {
        //button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTintColor:self.TintColor];
        [button setTitleColor:self.tintColor forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        
    }
    if (title){
            [button setTitle:title forState:UIControlStateNormal];
    }
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    if (selector) {
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
//         button.showsTouchWhenHighlighted = YES;
    }
    if (left) {
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.frame= _leftItem.frame;
        [_leftItem removeFromSuperview];
        _leftItem = button;
        [self.leftItem setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|
         UIViewAutoresizingFlexibleWidth] ;
        [self addSubview:_leftItem];
    }
    else
    {
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.frame= _rightItem.frame;
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [_rightItem removeFromSuperview];
        _rightItem = button;
        [self.rightItem setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|
         UIViewAutoresizingFlexibleWidth] ;
        [self addSubview:_rightItem];
    }
    return button;
}

-(UIButton *)setBarButtonItemWithImage:(UIImage *)image leftbar:(BOOL)left target:(id)target selector:(SEL)selector
{
   return [self setBarButtonItemWithTitle:nil image:image leftbar:left target:target selector:selector];
}

 
@end
