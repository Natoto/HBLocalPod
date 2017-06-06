//
//  LeftRightLabelCell.m
//  hjb
//
//  Created by boob on 16/4/3.
//  Copyright © 2016年 YY.COM All rights reserved.
//

#import "LeftRightLabelCell.h"
#import "NSAttributedString+AttributedStringWithHTML.h"

@implementation LeftRightLabelCell

- (void)awakeFromNib {
    // Initialization code
    self.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setcellTitle:(NSString *)title
{
    self.lbl_left.text = title;
}

-(void)setcelldetailtitle:(NSString *)detailtitle
{
    if (detailtitle!=nil&&![detailtitle isEqual:[NSNull null]]) {
        if ([self hasHtmlSpan:detailtitle]) {
            self.lbl_right.attributedText = [NSAttributedString  attributedStringWithHTML:detailtitle];
        }else{
            self.lbl_right.text = detailtitle;
        }
    }
   
}

-(BOOL)hasHtmlSpan:(NSString *)htmlstring
{
    return [htmlstring containsString:@"</span>"];
}

-(void)setcelldictionary:(NSMutableDictionary *)dictionary
{
    [super setcelldictionary:dictionary];
    
    NSString * viewbgclr = [dictionary objectForKey:@"key_view_background"];
    if (viewbgclr && [[viewbgclr class] isSubclassOfClass:[NSString class]] ) {
        self.backgroundColor = [CELL_STRUCT_Common colorWithStructKey:viewbgclr];
    } 
    NSString * txtalignment =  dictionary[key_cellstruct_textAlignment];
    NSString * txtalignment2 =  dictionary[key_cellstruct_textAlignment2];
    if ([txtalignment isEqualToString:value_cellstruct_textAlignment_right]) {
        self.lbl_left.textAlignment = NSTextAlignmentRight;
    }
    else if ([txtalignment isEqualToString:value_cellstruct_textAlignment_center]) {
        self.lbl_left.textAlignment = NSTextAlignmentCenter;
    }
    else{
        self.lbl_left.textAlignment = NSTextAlignmentLeft;
    }
    
    if ([txtalignment2 isEqualToString:value_cellstruct_textAlignment_center]) {
        self.lbl_right.textAlignment = NSTextAlignmentCenter;
    }
    else if ([txtalignment2 isEqualToString:value_cellstruct_textAlignment_right]) {
            self.lbl_right.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        self.lbl_right.textAlignment = NSTextAlignmentLeft;
    }
    
    NSNumber * leftwidth = [dictionary objectForKey:key_cellstruct_leftWidth];
    if (leftwidth) {
        self.ns_leftwidth.constant = leftwidth.floatValue;
    }
    else{
        self.ns_leftwidth.constant = 80.0;
    }
    
    
    //----- from plist string --------
    NSNumber * titlefontsize = [dictionary objectForKey:key_cellstruct_titleuifont];
    if (titlefontsize && [[titlefontsize class] isSubclassOfClass:[NSNumber class]]) {
        self.lbl_left.font = [UIFont systemFontOfSize:titlefontsize.floatValue];// titlefont;
    }
    
    NSString * titlecolorstr = [dictionary objectForKey:key_cellstruct_titleuicolor];
    if (titlecolorstr && [[titlecolorstr class] isSubclassOfClass:[NSString class]]) {
        self.lbl_left.textColor = [CELL_STRUCT_Common colorWithStructKey:titlecolorstr];
    }
    NSNumber * detailfontsize = [dictionary objectForKey:key_cellstruct_detailuifont];
    if (detailfontsize && [[detailfontsize class] isSubclassOfClass:[NSNumber class]]) {
        UIFont * font = [UIFont systemFontOfSize:detailfontsize.floatValue];
        self.lbl_right.font = font;
    }
    
    NSString * detailcolorstr = [dictionary objectForKey:key_cellstruct_detailuicolor];
    if (detailcolorstr && [[detailcolorstr class] isSubclassOfClass:[NSString class]]) {
        UIColor * color = [CELL_STRUCT_Common colorWithStructKey:detailcolorstr];
        self.lbl_right.textColor = color;
    }
    
    NSString * htmlattributionstring = [dictionary objectForKey:key_cellstruct_attributionstring];
    if (htmlattributionstring  && ![htmlattributionstring isEqual:[NSNull null]]) {
        if ([self hasHtmlSpan:htmlattributionstring]) {
            self.textLabel.attributedText = [NSAttributedString  attributedStringWithHTML:htmlattributionstring];
        }
    }
//    NSString * viewbgclr = [dictionary objectForKey:@"key_view_background"];
//    if (viewbgclr && [[viewbgclr class] isSubclassOfClass:[NSString class]] ) {
//        self.backgroundColor = [CELL_STRUCT_Common colorWithStructKey:viewbgclr];
//    }else
//    {
//        self.backgroundColor = [UIColor clearColor];
//    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.showTopLine) {
        [self drawToplinelayer];
    }
    else
    {
        [self clearTopLayer];
    }
    if (self.showBottomLine) {
        [self drawBottomlinelayer];
    }else
    {
        [self clearBottomLayer];
    }
    NSDictionary * dictionary = self.dictionary;
    NSValue * edgeinsetsValue =  [dictionary objectForKey:key_cellstruct_contentInsets];
    if (edgeinsetsValue && [[edgeinsetsValue class] isSubclassOfClass:[NSValue class]]) {
        UIEdgeInsets  edgeinsets= [edgeinsetsValue UIEdgeInsetsValue];
        CGRect frame = CGRectMake(edgeinsets.left, edgeinsets.top, self.bounds.size.width - edgeinsets.left - edgeinsets.right, self.bounds.size.height - edgeinsets.top - edgeinsets.bottom);
        if (!CGRectEqualToRect(self.contentView.frame, frame)){
            self.contentView.frame = frame;
            self.selectedBackgroundView.frame = frame;
        }
    }
    if (edgeinsetsValue && [[edgeinsetsValue class] isSubclassOfClass:[NSString class]]) {
        NSString * edgestring =  [dictionary objectForKey:key_cellstruct_contentInsets];
        UIEdgeInsets edgeinsets = UIEdgeInsetsFromString(edgestring);
        CGRect frame = CGRectMake(edgeinsets.left, edgeinsets.top, self.bounds.size.width - edgeinsets.left - edgeinsets.right, self.bounds.size.height - edgeinsets.top - edgeinsets.bottom);
        if (!CGRectEqualToRect(self.contentView.frame, frame)){
            self.contentView.frame = frame;
            self.selectedBackgroundView.frame = frame;
        }
    }
}
@end
