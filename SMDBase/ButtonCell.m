//
//  ButtonCell.m
//  hjb
//
//  Created by zeno on 16/3/16.
//  Copyright © 2016年 YY.COM All rights reserved.
//

#import "ButtonCell.h"
#import <Masonry/Masonry.h>

@implementation ButtonCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_button];
        _detailLabel = [UILabel new];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.numberOfLines = 3;
        [self.contentView addSubview:_detailLabel];
        
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self).insets(UIEdgeInsetsMake(5, 12, 5, 8));
            make.left.equalTo(self.contentView).offset(12);
            make.top.equalTo(self.contentView).offset(5);
            make.bottom.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-250);
        }];
        
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-12);
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(_button.mas_right);
        }];
        
        [_button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)buttonTap:(id)sender{

    SEND_CELL_TAP_TO_DELEGATE(UIButton, sender)
}

-(void)setcellTitle:(NSString *)title
{
    [self.button setTitle:title forState:UIControlStateNormal];
}


-(void)setcellTitleFontsize:(NSNumber *)titleFontsize
{
    if (titleFontsize.floatValue > 8) {
        self.button.titleLabel.font = [UIFont systemFontOfSize:titleFontsize.floatValue];
    }
}

-(void)setcellTitleFont:(UIFont *)titleFont
{
    if (titleFont) {
//        self.textLabel.font = titleFont;
        self.button.titleLabel.font = titleFont;
    }
}

-(void)setcelldetailtitle:(NSString *)detailtitle{
//    [super setcelldetailtitle:detailtitle];
    self.detailLabel.text = detailtitle;
}
-(void)setcellTitleColor:(NSString *)color
{
    UIColor * titlecolor = [CELL_STRUCT_Common colorWithStructKey:color] ;
    if (titlecolor) {
        [self.button  setTitleColor:titlecolor forState:UIControlStateNormal];
    }
    else
    {
        [self.button  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}


-(void)setcellProfile:(NSString *)profile
{
    if (profile) {
        [self.button setImage:[UIImage imageNamed:profile] forState:UIControlStateNormal];
    }
    else{
        [self.button setImage:nil forState:UIControlStateNormal];
    }
}

-(void)setcelldictionary:(NSMutableDictionary *)dictionary
{
    [super setcelldictionary:dictionary];
    NSNumber * active = [dictionary objectForKey:key_cellstruct_active];
    if (active) {
        self.button.userInteractionEnabled = active.boolValue;
    }
    else{
        self.button.userInteractionEnabled = YES;
    }
    NSString *  contentindset = [dictionary objectForKey:key_cellstruct_contentInsets];
    if (contentindset) {
        UIEdgeInsets edgeinset = UIEdgeInsetsFromString(contentindset);
        [_button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(edgeinset);
        }];
    }
    
    NSString * sizestr = dictionary[key_cellstruct_contentsize];
    if (sizestr) {
        CGSize size = CGSizeFromString(sizestr);
        [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(size);
        }];
    }

    NSString * text_alignstr = [dictionary objectForKey:key_cellstruct_textAlignment];
    if ([text_alignstr isEqualToString:@"center"]) {
        self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    else if ([text_alignstr isEqualToString:@"left"]) {
        self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    else if ([text_alignstr isEqualToString:@"right"]) {
        self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    
    NSNumber * detailfontsize = [dictionary objectForKey:key_cellstruct_detailuifont];
    if (detailfontsize && [[detailfontsize class] isSubclassOfClass:[NSNumber class]]) {
        UIFont * font = [UIFont systemFontOfSize:detailfontsize.floatValue];
        self.detailLabel.font = font;
    }
    
    NSString * detailcolorstr = [dictionary objectForKey:key_cellstruct_detailuicolor];
    if (detailcolorstr && [[detailcolorstr class] isSubclassOfClass:[NSString class]]) {
        UIColor * color = [CELL_STRUCT_Common colorWithStructKey:detailcolorstr];
        self.detailLabel.textColor = color;
    }
}

@end
