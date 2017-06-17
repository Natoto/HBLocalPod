//
//  BaseTableViewCell.m
//  PENG
//
//  Created by zeno on 15/12/14.
//  Copyright © 2015年 nonato. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "UIImageView+HBWebCache.h"
#import "NSAttributedString+AttributedStringWithHTML.h"
#import "UIView+Transition.h"
//#import "UIView+YYAdd.h"
 

@interface BaseTableViewCell()
@property (nonatomic, strong) UIImageView * snapImageView;
@end
@implementation BaseTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier plistdic:(NSDictionary *)plistdic{
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *view_bg = [[UIView alloc]initWithFrame:self.frame];
        view_bg.backgroundColor = KT_HEXCOLORA(0xd9d9d9,1);//KT_HEXCOLOR(0xd84637);//[UIColor grayColor];
        self.selectedBackgroundView = view_bg;
        self.clipsToBounds = YES;
    }
    return self;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *view_bg = [[UIView alloc]initWithFrame:self.frame];
        view_bg.backgroundColor = KT_HEXCOLORA(0xd9d9d9,1);//KT_HEXCOLOR(0xd84637);//[UIColor grayColor];
        self.selectedBackgroundView = view_bg;
        self.clipsToBounds = YES;
      
    }
    return self;
}

-(void)awakeFromNib{

    [super awakeFromNib];
    self.clipsToBounds = YES;
}

-(BOOL)hasHtmlSpan:(NSString *)htmlstring
{
    return [htmlstring containsString:@"</span>"];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat lineheight = 0.3;
    UIColor * linecolor =  KT_HEXCOLORA(0XEEEEEE, 0.5);
    self.toplayer.backgroundColor = linecolor;
    self.bottomlayer.backgroundColor = linecolor;
    
}

-(void)setcellRightValue:(NSString *)value
{
    if (value.length) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(hb_AcessoryButton:)]) {
            UIControl * control = [self.delegate hb_AcessoryButton:self];
            _AcessoryButton = control;
        }
        if (self.AcessoryButton) {
            if ([[self.AcessoryButton class] isSubclassOfClass:[UIButton class]]) {
                UIButton * btn = (UIButton *)self.AcessoryButton;
                [btn setTitle:value forState:UIControlStateNormal];
            }
            self.accessoryView = self.AcessoryButton;
        }
    }
    if(value && value.length == 0){
        self.accessoryView = nil;
    }
}

-(void)setcellProfile:(NSString *)profile
{
    if (!profile || !profile.length) {
        self.imageView.image = nil;
        return;
    }
    if ([profile hasPrefix:@"http://"] || [profile hasPrefix:@"https://"]) {//如果是网络图片 就加载网络图片
        [self.imageView hb_setImageWithURL:[NSURL URLWithString:profile] placeholderImage:[UIImage imageNamed:@"nopic"] options:0 completed:nil];
        return;
    }
    self.imageView.image = profile.length ? [UIImage imageNamed:profile]: nil;;
}


-(void)setcelldictionary:(NSMutableDictionary *)dictionary
{
    [super setcelldictionary:dictionary];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(exConfigForHBTableViewCell:)]) {
        [self.delegate exConfigForHBTableViewCell:self];
    }
    
    //----- from plist string --------
    NSNumber * titlefontsize = [dictionary objectForKey:key_cellstruct_titleuifont];
    if (titlefontsize && [[titlefontsize class] isSubclassOfClass:[NSNumber class]]) {
        self.textLabel.font = [UIFont fontWithName:self.textLabel.font.fontName size:titlefontsize.floatValue];;// titlefont;
        
        self.textLabel.font = [UIFont fontWithName:self.textLabel.font.fontName size:titlefontsize.floatValue];// titlefont;
    }
    
    NSString * titlecolorstr = [dictionary objectForKey:key_cellstruct_titleuicolor];
    if (titlecolorstr && [[titlecolorstr class] isSubclassOfClass:[NSString class]]) {
        self.textLabel.textColor = [CELL_STRUCT_Common colorWithStructKey:titlecolorstr];
    }
    NSNumber * detailfontsize = [dictionary objectForKey:key_cellstruct_detailuifont];
    if (detailfontsize && [[detailfontsize class] isSubclassOfClass:[NSNumber class]]) {
        UIFont * font = [UIFont fontWithName:self.textLabel.font.fontName size:detailfontsize.floatValue];
        self.detailTextLabel.font = font;
    }
    
    NSString * detailcolorstr = [dictionary objectForKey:key_cellstruct_detailuicolor];
    if (detailcolorstr && [[detailcolorstr class] isSubclassOfClass:[NSString class]]) {
        UIColor * color = [CELL_STRUCT_Common colorWithStructKey:detailcolorstr];
        self.detailTextLabel.textColor = color;
    }
    
    NSNumber * accesorytype = [dictionary objectForKey:key_cellstruct_AccessoryType];
    if (accesorytype) {
        self.accessoryType = accesorytype.integerValue;
    }
    
    NSString * htmlattributionstring = [dictionary objectForKey:key_cellstruct_attributionstring];
    if (htmlattributionstring) {
        if ([self hasHtmlSpan:htmlattributionstring]) {
            self.textLabel.attributedText = [NSAttributedString  attributedStringWithHTML:htmlattributionstring];
        }
    }
    
    NSString * selectedbgcolor = [dictionary objectForKey:key_cellstruct_selectedbgcolor];
    if (selectedbgcolor) {
        UIColor * color = [CELL_STRUCT_Common colorWithStructKey:selectedbgcolor];
        self.selectedBackgroundView.backgroundColor = color;
    }
}

-(UIButton *)AcessoryButton
{
    UIButton * button;
    if (!_AcessoryButton) {
        button = [UIButton  buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 70, 25);
        [button setTitle:@"已关注" forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13] ];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _AcessoryButton = button;
    }
    else
    {
        button = (UIButton *)_AcessoryButton ;
    }
    return button;
}

-(void)draw:(CELL_STRUCT *)cellstruct{
    
    BaseTableViewCell * cell = self;
    [cell setcellTitleLabelNumberOfLines:cellstruct.titleLabelNumberOfLines];
    [cell setcelldetailtitle:cellstruct.detailtitle];
    [cell setcellplaceholder:cellstruct.placeHolder];
    [cell setcellTitle:cellstruct.title];
    [cell setcellTitleFontsize:cellstruct.titlefontsize];
    [cell setcellTitleFont:cellstruct.titleFont];
    [cell setcellAttributeTitle:cellstruct.attributeTitle];
    [cell setcellValue2:cellstruct.subvalue2];
    [cell setcellProfile:cellstruct.picture];
    [cell setcellpicturecolor:cellstruct.picturecolor];
    [cell setcellValue:cellstruct.value];
    [cell setcellRightValue:cellstruct.rightValue];
    [cell setcellobject:cellstruct.object];
    [cell setcellobject2:cellstruct.object2];
    [cell setcellTitleColor:cellstruct.titlecolor];
    [cell setcelldictionary:cellstruct.dictionary];
    [cell setcellArray:cellstruct.array];
    [cell setcellimageCornerRadius:cellstruct.imageCornerRadius];
   
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
//         self.snapImageView.image = [self.contentView snapshotImage];
//    });
//    self.snapImageView.hidden = YES;
}

-(void)showSnapView{
//    [self bringSubviewToFront:self.snapImageView];
//    self.snapImageView.hidden = NO;
}
@end
