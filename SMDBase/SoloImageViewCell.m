//
//  SoloImageCell.m
//  PENG
//
//  Created by hb on 15/6/19.
//  Copyright (c) 2015年 pengpeng. All rights reserved.
//

#import "SoloImageViewCell.h"
//#import "PENG_Define.h"
#import "UIViewAdditions.h"

@interface SoloImageViewCell()
@property(nonatomic,assign) CGRect imageFrame;
//@property(nonatomic,retain) UIImageView * imageView;
@end

#ifndef KT_CORNER_PROFILE
#define KT_CORNER_PROFILE(_OBJ) _OBJ.layer.masksToBounds = YES;\
[_OBJ.layer setCornerRadius:CGRectGetHeight([_OBJ bounds]) / 2];\
_OBJ.layer.borderWidth = 0;\
_OBJ.layer.borderColor = [[UIColor whiteColor] CGColor];
#endif

@implementation SoloImageViewCell
NO_DEFAULT_TITLE
NO_DEFAULT_PLACEHOLDER

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageviewTap:)];
        self.imageView.userInteractionEnabled = YES;
        [self.imageView addGestureRecognizer:tap];
    }
    return self;
}

-(IBAction)imageviewTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(PENGView:subView:TapWithTag:)]) {
        [self.delegate PENGView:self subView:self.imageView TapWithTag:0];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.size = [self imageViewSize];
//    self.imageView.backgroundColor = [UIColor grayColor];
    self.imageView.center = CGPointMake(self.frame.size.width/2 , self.frame.size.height/2);
//    self SETALI alignmentRectInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    if ([self respondsToSelector:@selector(layoutMargins)]) {
        self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if ([self respondsToSelector:@selector(separatorInset)]) {
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if (self.CornerRadius) {
        KT_CORNER_PROFILE(self.imageView);
    }
}

-(void)setcellimageCornerRadius:(BOOL)CornerRadius
{
    self.CornerRadius = CornerRadius;
}

-(CGSize)imageViewSize
{
    NSValue * value = [self.dictionary objectForKey:key_soloImageView_size];
    
    if ([[value class] isSubclassOfClass:[NSValue class]]) {
        return value.CGSizeValue;
    }
    else if([[value class] isSubclassOfClass:[NSString class]]){
        NSString * sizestring =  [self.dictionary objectForKey:key_soloImageView_size];;
        CGSize size = CGSizeFromString(sizestring);
        return size;
    }
    return self.contentView.bounds.size;//CGSizeMake(80, 80);
}

-(void)setcelldictionary:(NSMutableDictionary *)dictionary{
 
//    NSNumber * radis = dictionary[key_soloImageView_radius];
//    if (radis && [[radis class] isSubclassOfClass:[NSNumber class]]) {
//        self.imageView.layer.cornerRadius = radis.floatValue;
//        self.imageView.clipsToBounds = YES;
//    }
}
-(void)setcellProfile:(NSString *)profile
{
//    [super setcellProfile:profile];
    if (!profile || !profile.length) {
        return;
    }
    if ([profile hasPrefix:@"http://"] || [profile hasPrefix:@"https://"]) {//如果是网络图片 就加载网络图片
        [self.imageView hb_setImageWithURL:[NSURL URLWithString:profile] placeholderImage:[UIImage imageNamed:@"nopic"] options:0 completed:^(UIImage *image, NSError *error, int cacheType, NSURL *imageURL) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(PENGView:subView:TapWithObject:)]) {
                CGSize imgsize = image.size;
                [self.delegate PENGView:self subView:self.imageView TapWithObject:NSStringFromCGSize(imgsize)];
            }
        }];
        return;
    }
    self.imageView.image = profile.length ? [UIImage imageNamed:profile]: nil;;
    
}

-(void)setcellobject:(id)object
{
    [super setcellobject:object];
    if (object && [[object class ] isSubclassOfClass:[UIImage class]]) {
        UIImage * image = (UIImage *)object;
        self.imageView.image = image;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
