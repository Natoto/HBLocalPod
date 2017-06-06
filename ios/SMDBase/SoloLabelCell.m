//
//  SoloLabelCell.m
//  JXL
//
//  Created by hb on 15/5/21.
//  Copyright (c) 2015年 BooB. All rights reserved.
//

#import "SoloLabelCell.h"
#import "NIAttributedLabel.h"
#import "UIViewAdditions.h"
#import "UIView+PENG.h"
#import "NSAttributedString+AttributedStringWithHTML.h"
//#import "PENG_Define.h"
@interface SoloLabelCell()<NIAttributedLabelDelegate>
@end
@implementation SoloLabelCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
-(void)setcellProfile:(NSString *)profile{}

-(void)setcellTitle:(NSString *)title
{
    if (title!=nil&&![title isEqual:[NSNull null]]) {
        if ([self hasHtmlSpan:title]) {
            self.m_Label.attributedText = [NSAttributedString  attributedStringWithHTML:title];
        }else{
            self.m_Label.text = title;
        }
    }
}
-(BOOL)hasHtmlSpan:(NSString *)htmlstring
{
    return [htmlstring containsString:@"</span>"];
}
-(void)setcellTitleColor:(NSString *)color
{
    if (color) {
        self.m_Label.textColor = [CELL_STRUCT_Common colorWithStructKey:color];
    }
}

-(void)setcellAttributeTitle:(NSAttributedString *)attributeTitle
{
    if (attributeTitle.length) {
        self.m_Label.attributedText = attributeTitle;
    }
}

-(void)setcellimageCornerRadius:(BOOL)CornerRadius
{
    if (CornerRadius) {//TODO: CornerRadius = YES 时候没有圆角
        self.contentView.layer.cornerRadius = 0;
        self.contentView.layer.masksToBounds = YES;
        self.selectedBackgroundView.layer.cornerRadius = 0;
        self.selectedBackgroundView.layer.masksToBounds = YES;
    }
    else
    {
        self.contentView.layer.cornerRadius = 5;
        self.selectedBackgroundView.layer.cornerRadius = 5;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
//    self.m_Label.frame = CGRectMake(10, 0, self.contentView.width - 20, self.contentView.height);
    
    NSDictionary * dictionary = self.dictionary;
    
    NSValue * edgeinsetsValue =  [dictionary objectForKey:key_cellstruct_contentInsets];
    if (edgeinsetsValue && [[edgeinsetsValue class] isSubclassOfClass:[NSValue class]]) {
        UIEdgeInsets  edgeinsets= [edgeinsetsValue UIEdgeInsetsValue];
        CGRect frame = CGRectMake(edgeinsets.left, edgeinsets.top, self.bounds.size.width - edgeinsets.left - edgeinsets.right, self.bounds.size.height - edgeinsets.top - edgeinsets.bottom);
        self.contentView.frame = frame;
        self.selectedBackgroundView.frame = frame;
    }
    if (edgeinsetsValue && [[edgeinsetsValue class] isSubclassOfClass:[NSString class]]) {
        NSString * edgestring =  [dictionary objectForKey:key_cellstruct_contentInsets];
        UIEdgeInsets edgeinsets = UIEdgeInsetsFromString(edgestring);
        CGRect frame = CGRectMake(edgeinsets.left, edgeinsets.top, self.bounds.size.width - edgeinsets.left - edgeinsets.right, self.bounds.size.height - edgeinsets.top - edgeinsets.bottom);
        self.contentView.frame = frame;
        self.selectedBackgroundView.frame = frame;
    }
    
    
    NSNumber * showbottomlayer = [dictionary objectForKey:key_cellstruct_showbottomlayer];
    if (showbottomlayer && showbottomlayer.boolValue) {
        [self.contentView clearBottomLayer];
        [self.contentView drawBottomlinelayer];
    }
    NSNumber * showtoplayer = [dictionary objectForKey:key_cellstruct_showtoplayer];
    if (showtoplayer && showtoplayer.boolValue) {
        [self.contentView clearTopLayer];
        [self.contentView drawToplinelayer];
    }
    NSNumber * showright = [dictionary objectForKey:key_cellstruct_showrightlayer];
    if (showright && showright.boolValue) {
        [self.contentView clearrightlayer];
        [self.contentView drawrightlayer];
    }
    
    NSNumber * showleft = [dictionary objectForKey:key_cellstruct_showleftlayer];
    if (showleft && showleft.boolValue) {
        [self.contentView clearleftlayer];
        [self.contentView drawleftlayer];
    }
//    self.m_Label.frame = self.contentView.frame;
}

static UILabel * testLabel;
+(CGFloat)heighofCell:(NSString *)content
{
    if (!testLabel) {
        testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 20, 0)];
        testLabel.numberOfLines = 0;
        testLabel.font = [UIFont systemFontOfSize:13];
    }
    testLabel.text = content;
    CGSize size = [testLabel sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width, 0)];
    return fmaxf(size.height + 10, 44);
}

-(NIAttributedLabel *)m_Label
{
    if (!_m_Label) {
        _m_Label = [[NIAttributedLabel alloc] initWithFrame:self.contentView.bounds];
        _m_Label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _m_Label.numberOfLines = 0;
        _m_Label.lineBreakMode = NSLineBreakByCharWrapping;
        _m_Label.autoDetectLinks = YES;
        _m_Label.font = [UIFont systemFontOfSize:13];
        _m_Label.verticalTextAlignment = NIVerticalTextAlignmentMiddle;
        _m_Label.delegate = self;
        [self.contentView addSubview:_m_Label];
    }
    return _m_Label;
}

- (void)attributedLabel:(NIAttributedLabel *)attributedLabel didSelectTextCheckingResult:(NSTextCheckingResult *)result atPoint:(CGPoint)point {
    [[UIApplication sharedApplication] openURL:result.URL];
}

-(void)setcelldictionary:(NSMutableDictionary *)dictionary
{
    [super setcelldictionary:dictionary];
    
    NSString * viewbgclr = [dictionary objectForKey:@"key_view_background"];
    if (viewbgclr && [[viewbgclr class] isSubclassOfClass:[NSString class]] ) {
        self.backgroundColor = [CELL_STRUCT_Common colorWithStructKey:viewbgclr];
    }else
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    NSString * text_alignstr = [dictionary objectForKey:key_cellstruct_textAlignment];
    if ([text_alignstr isEqualToString:value_cellstruct_textAlignment_center]) {
        self.m_Label.textAlignment = NSTextAlignmentCenter;
        self.m_Label.verticalTextAlignment = NIVerticalTextAlignmentMiddle;
    }
    UIFont * font = [dictionary objectForKey:key_cellstruct_titleFont];
    if (font && [[font class] isSubclassOfClass:[UIFont class]]) {
        self.m_Label.font = font;
    }else if (font && [[font class] isSubclassOfClass:[NSNumber class]])
    {
        NSNumber * fontsize = (NSNumber *) [dictionary objectForKey:key_cellstruct_titleFont];;
        self.m_Label.font = [UIFont systemFontOfSize:fontsize.floatValue];
    }
    
    
    UIColor *txtcolor = [dictionary objectForKey:key_cellstruct_titlecolor];
    if (txtcolor && [[txtcolor class] isSubclassOfClass:[UIColor class]]) {
//        self.backgroundColor = [UIColor clearColor];
        self.m_Label.textColor = txtcolor;
    }
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
//    if (highlighted) {
//        self.m_Label.highlighted = NO;
//       
//    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
