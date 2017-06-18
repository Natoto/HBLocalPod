//
//  SMDPlayerControl.m
//  fenda
//
//  Created by boob on 2017/6/6.
//  Copyright © 2017年 YY.COM. All rights reserved.
//

#import "MMMaterialDesignSpinner.h"
#import "SMDPlayerControl.h"
#import "ASValueTrackingSlider.h"
#import "UIView+CustomControlView.h"

@interface SMDPlayerControl()
@property (nonatomic, strong) UIButton * actionButton;

@property (nonatomic, strong) MMMaterialDesignSpinner * activity;

@end

@implementation SMDPlayerControl

-(instancetype)init{
    
    self = [super init];
    if (self) {
        [self addSubview:self.activity];
        [self addSubview:self.actionButton];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(IBAction)viewTap:(id)sender
{
    [self buttonTap:self.actionButton];
}
-(void)zf_playerShowControlView{
    
    [self buttonTap:self.actionButton];
}

/** 加载的菊花 */
- (void)zf_playerActivity:(BOOL)animated {
    if (animated) {
        [self.activity startAnimating];
    } else {
        [self.activity stopAnimating];
    }
}

-(IBAction)buttonTap:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (self.zfp_delegate  && [self.zfp_delegate respondsToSelector:@selector(zf_controlView:playAction:)]) {
        NSLog(@"zfp_delgate:%@",NSStringFromClass([self.zfp_delegate class]));
        [self.zfp_delegate zf_controlView:self playAction:sender];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.actionButton.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    self.activity.center = CGPointMake(self.bounds.size.width/2., self.bounds.size.height/2);
    
}


-(UIButton *)actionButton{
    if (!_actionButton) {
        
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_actionButton setImage:nil forState:UIControlStateNormal];
        UIImage * img = ZFPlayerImage(@"ic_play");
        [_actionButton setImage:img forState:UIControlStateSelected];
        _actionButton.frame = CGRectMake(0, 0, 80, 80);
        _actionButton.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        [_actionButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (MMMaterialDesignSpinner *)activity {
    if (!_activity) {
        _activity = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        _activity.lineWidth = 1;
        _activity.duration  = 1;
        _activity.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    }
    return _activity;
}
@end
