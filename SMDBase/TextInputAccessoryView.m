//
//  TextInputAccessoryView.m
//  PENG
//
//  Created by zeno on 15/9/14.
//  Copyright (c) 2015年 nonato. All rights reserved.
//

#import "TextInputAccessoryView.h" 

@interface TextInputAccessoryView()
@property(nonatomic,retain) UIButton * btn_comfirm;
@end

@implementation TextInputAccessoryView


- (UIButton *)CreateButtonWithFrame:(CGRect)frame andTxt:(NSString *)TXT buttonType:(UIButtonType)buttonType
{
    UIButton *button=[UIButton buttonWithType:buttonType];
    [button setTitle:TXT forState:UIControlStateNormal];
    button.frame=frame;
    button.showsTouchWhenHighlighted = YES;
    return button;
}

-(UIButton *)btn_comfirm
{
    if (!_btn_comfirm) {
        _btn_comfirm = [self CreateButtonWithFrame:CGRectMake(self.bounds.size.width - 70, 0, 60, 25) andTxt:@"OK" buttonType:UIButtonTypeSystem];
        _btn_comfirm.layer.borderColor = [UIColor grayColor].CGColor;
        _btn_comfirm.layer.borderWidth = 0.5;
        _btn_comfirm.layer.masksToBounds = YES;
        _btn_comfirm.showsTouchWhenHighlighted = NO;
    }
    return _btn_comfirm;
}

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.btn_comfirm addTarget:target action:action forControlEvents:controlEvents];
}

+(instancetype)defaultAccessoryView
{
    TextInputAccessoryView * acview = [[TextInputAccessoryView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    return acview;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.btn_comfirm];
        [self drawtabviewsociallayer];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.btn_comfirm.center = CGPointMake(self.bounds.size.width - 40, self.bounds.size.height/2);
}
-(IBAction)comfirm:(id)sender
{
    
}

-(void)drawtabviewsociallayer
{
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.bounds.size.width, 0.5)];
    line.backgroundColor =  [UIColor colorWithWhite:0.6 alpha:0.8];
    [self addSubview:line];
}

@end