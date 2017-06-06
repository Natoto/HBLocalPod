//
//  LeftRightBottomLabelCell.m
//  hjb
//
//  Created by boob on 16/4/4.
//  Copyright © 2016年 YY.COM All rights reserved.
//

#import "LeftRightBottomLabelCell.h"

@implementation LeftRightBottomLabelCell

- (void)awakeFromNib {
    // Initialization code
}


-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)setcellTitle:(NSString *)title
{
    self.lbl_leftup.text = title;
}

-(void)setcelldetailtitle:(NSString *)detailtitle
{
    if (detailtitle.length) {
        self.lbl_leftdown.text = detailtitle;
    }
}

-(void)setcellValue:(NSString *)value
{
    self.lbl_rightup.text = value;
}

-(void)setcelldictionary:(NSMutableDictionary *)dictionary
{
    [super setcelldictionary:dictionary];
    NSNumber * titlefont = [dictionary objectForKey:key_cellstruct_titleuifont];
    if (titlefont && [[titlefont class] isSubclassOfClass:[NSNumber class]]) {
        self.lbl_leftup.font = [UIFont systemFontOfSize:titlefont.floatValue];// titlefont;
        self.lbl_rightup.font = [UIFont systemFontOfSize:titlefont.floatValue];
    }
    
    NSString * titlecolor = [dictionary objectForKey:key_cellstruct_titleuicolor];
    if (titlecolor && [[titlecolor class] isSubclassOfClass:[NSString class]]) {
        self.lbl_leftup.textColor = [CELL_STRUCT_Common colorWithStructKey:titlecolor];
        self.lbl_rightup.textColor = [CELL_STRUCT_Common colorWithStructKey:titlecolor];
    }
    
    NSNumber * detailfont = [dictionary objectForKey:key_cellstruct_detailuifont];
    if (detailfont && [[detailfont class] isSubclassOfClass:[NSNumber class]]) {
        UIFont * font = [UIFont systemFontOfSize:detailfont.floatValue];
        self.lbl_leftdown.font = font;
    }
    
    NSString * detailcolor = [dictionary objectForKey:key_cellstruct_detailuicolor];
    if (detailcolor && [[detailcolor class] isSubclassOfClass:[NSString class]]) {
        UIColor * color = [CELL_STRUCT_Common colorWithStructKey:detailcolor];
        self.lbl_leftdown.textColor = color;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(CGSize)sizeThatFits:(CGSize)size
{
    CGFloat height = 25 + 16;
    [self.lbl_leftdown sizeToFit];
    return CGSizeMake(size.width, self.lbl_leftdown.bounds.size.height + height);
  
}


@end
