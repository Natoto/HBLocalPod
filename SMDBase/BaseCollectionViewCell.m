//
//  ImageCollectionCell.m
//  samurai-peng
//
//  Created by zeno on 16/3/7.
//  Copyright © 2016年 YY.COM All rights reserved.
//
#import "UIView+PENG.h"
#import "BaseCollectionViewCell.h"
#import "UIImageView+HBWebCache.h"
@implementation BaseCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self layoutIfNeeded];
}

-(void)setcellProfile:(NSString *)profile
{
    if (profile && [profile containsString:@"http"]) {
        [self.imageView hb_setImageWithURL:[NSURL URLWithString:profile]];
    }
    else
    {
        self.imageView.image = profile.length ? [UIImage imageNamed:profile]:nil;
    }
}

-(UIImageView *)imageView
{
    if (!_imageView) {
        UIImageView * imgview = [UIImageView new];
        imgview.autoresizingMask = UIViewAutoresizingFlexibleWidth|
        UIViewAutoresizingFlexibleHeight;
        imgview.contentMode = UIViewContentModeScaleAspectFill;
        imgview.clipsToBounds = YES;
        [self.contentView addSubview:imgview];
        imgview.frame = self.contentView.bounds;
        _imageView = imgview;
    }
    return _imageView;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    NSNumber * showTopLine = [self.dictionary objectForKey:key_cellstruct_showtoplayer];
    if (showTopLine) {
        [self drawToplinelayer];
    }
    else
    {
        [self clearTopLayer];
    }
    NSNumber * showBottomLine = [self.dictionary objectForKey:key_cellstruct_showbottomlayer];
    if (showBottomLine) {
        [self drawBottomlinelayer];
    }else
    {
        [self clearBottomLayer];
    }
    
    NSNumber * showLeftLine = [self.dictionary objectForKey:key_cellstruct_showLeftLine];
    if (showLeftLine) {
        [self drawleftlayer];
    }else
    {
        [self clearleftlayer];
    }
    
    NSNumber * showRightLine = [self.dictionary objectForKey:key_cellstruct_showRightLine];
    if (showRightLine) {
        [self drawrightlayer];
    }else
    {
        [self clearrightlayer];
    }
    
    
}
@end
