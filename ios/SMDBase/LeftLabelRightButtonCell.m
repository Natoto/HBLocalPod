//
//  LeftLabelRightButtonCell.m
//  hjb
//
//  Created by boob on 16/4/4.
//  Copyright © 2016年 YY.COM All rights reserved.
//

#import "LeftLabelRightButtonCell.h"
@interface LeftLabelRightButtonCell()
@property(nonatomic,strong) NSString * profile;
@property (nonatomic, strong) NSString * detail;
@end

@implementation LeftLabelRightButtonCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//NO_DEFAULT_TITLE_PROFILE
-(void)setcellProfile:(NSString *)profile
{
    if (!profile || !profile.length) {
        [self.btn_right setImage:nil forState:UIControlStateNormal];
        return;
    }
    self.profile = profile;
    if ([profile hasPrefix:@"http://"] || [profile hasPrefix:@"https://"]) {//如果是网络图片 就加载网络图片
        [self.btn_right hb_setImageWithURL:[NSURL URLWithString:profile] forState:UIControlStateNormal];
        return;
    }
    self.btn_right.hidden = [self rightbtnhidden];
    [self.btn_right setImage:[UIImage imageNamed:profile] forState:UIControlStateNormal];

}

-(BOOL)rightbtnhidden
{
    BOOL hidden = YES;
    if (self.profile && self.profile.length) {
        return NO;
    }
    if (self.detail && self.detail.length) {
        return NO;
    }
    return hidden;
}

-(void)setcellTitle:(NSString *)title
{
    self.lbl_title.text = title;
}

- (IBAction)buttonTap:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hbtableViewCell:subView:TapWithTag:)]) {
        [self.delegate hbtableViewCell:self subView:sender TapWithTag:0xd0];
    }
}


-(void)setcelldetailtitle:(NSString *)value
{
    self.detail = value;
    [self.btn_right setTitle:value forState:UIControlStateNormal];
    self.btn_right.hidden = [self rightbtnhidden];
    
}



-(void)setcelldictionary:(NSMutableDictionary *)dictionary
{
    [super setcelldictionary:dictionary];
    //----- from plist string --------
    NSNumber * titlefontsize = [dictionary objectForKey:key_cellstruct_titleuifont];
    if (titlefontsize && [[titlefontsize class] isSubclassOfClass:[NSNumber class]]) {
        self.lbl_title.font = [UIFont systemFontOfSize:titlefontsize.floatValue];// titlefont;
    }
    
    NSString * titlecolorstr = [dictionary objectForKey:key_cellstruct_titleuicolor];
    if (titlecolorstr && [[titlecolorstr class] isSubclassOfClass:[NSString class]]) {
        self.lbl_title.textColor = [CELL_STRUCT_Common colorWithStructKey:titlecolorstr];
    }
    
    
    NSNumber * detailfontsize = [dictionary objectForKey:key_cellstruct_detailuifont];
    if (detailfontsize && [[detailfontsize class] isSubclassOfClass:[NSNumber class]]) {
        UIFont * font = [UIFont systemFontOfSize:detailfontsize.floatValue]; 
        self.btn_right.titleLabel.font = font;
    }
    
    NSString * detailcolorstr = [dictionary objectForKey:key_cellstruct_detailuicolor];
    if (detailcolorstr && [[detailcolorstr class] isSubclassOfClass:[NSString class]]) {
        UIColor * color = [CELL_STRUCT_Common colorWithStructKey:detailcolorstr];
        [self.btn_right setTitleColor:color forState:UIControlStateNormal];
        // forState:<#(UIControlState)#> .textColor = color;
    }
    
    NSNumber * btnable = [dictionary objectForKey:key_cellstruct_llrbrightenable];
    if (btnable) {
        self.btn_right.enabled = btnable.boolValue;
    }
    else
    {
        self.btn_right.enabled = YES;
    }
}

@end
