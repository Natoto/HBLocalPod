
//
//  LeftRightUpDownLabelXIBCell.m
//  HjbPay
//
//  Created by boob on 16/4/20.
//  Copyright © 2016年 YY.COM All rights reserved.
//

#import "LeftRightUpDownLabelXIBCell.h"
#import "NSAttributedString+AttributedStringWithHTML.h"

@implementation LeftRightUpDownLabelXIBCell

- (void)awakeFromNib {
    // Initialization code
}


-(void)setcellProfile:(NSString *)profile
{
    if (profile.length) {
        
        if ([profile hasPrefix:@"http://"] || [profile hasPrefix:@"https://"]) {//如果是网络图片 就加载网络图片
            [self.img_profile hb_setImageWithURL:[NSURL URLWithString:profile] placeholderImage:[UIImage imageNamed:@"nopic"] options:0 completed:nil];
            return;
        }
        self.img_profile.image = profile.length ? [UIImage imageNamed:profile]: nil;;
        self.cons_imgheight.constant = self.bounds.size.height - 30.;
    }
    else
    {
        self.cons_imgheight.constant = 0;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setcellTitle:(NSString *)title
{
    self.lbl_leftup.text = title;
}

-(void)setcelldetailtitle:(NSString *)detailtitle
{
//    if (detailtitle.length) {
        self.lbl_leftdown.text = detailtitle;
//    }
}

-(void)setcellValue:(NSString *)value
{
    self.lbl_rightup.attributedText = [NSAttributedString  attributedStringWithHTML:value];
}

-(void)setcelldictionary:(NSMutableDictionary *)dictionary
{
    [super setcelldictionary:dictionary];
    NSNumber * titlefont = [dictionary objectForKey:key_cellstruct_titleuifont];
    if (titlefont && [[titlefont class] isSubclassOfClass:[NSNumber class]]) {
        self.lbl_leftup.font = [UIFont systemFontOfSize:titlefont.floatValue];// titlefont;
    }
    
    NSString * titlecolor = [dictionary objectForKey:key_cellstruct_titleuicolor];
    if (titlecolor && [[titlecolor class] isSubclassOfClass:[NSString class]]) {
        self.lbl_leftup.textColor = [CELL_STRUCT_Common colorWithStructKey:titlecolor];
    }
    NSNumber * detailfont = [dictionary objectForKey:key_cellstruct_detailuifont];
    if (detailfont && [[detailfont class] isSubclassOfClass:[NSNumber class]]) {
        UIFont * font = [UIFont systemFontOfSize:detailfont.floatValue];
        self.lbl_leftdown.font = font;
//        self.lbl_rightup.font = font;
        self.lbl_rightdown.font = font;
    }
    
    NSString * detailcolor = [dictionary objectForKey:key_cellstruct_detailuicolor];
    if (detailcolor && [[detailcolor class] isSubclassOfClass:[NSString class]]) {
        UIColor * color = [CELL_STRUCT_Common colorWithStructKey:detailcolor];
        self.lbl_leftdown.textColor = color;
//        self.lbl_rightup.textColor = color;
        self.lbl_rightdown.textColor = color;
    }
    
}

-(void)setcellValue2:(NSString *)value
{
//    if (value.length) {
        self.lbl_rightdown.text = value;
//    }
}


@end
