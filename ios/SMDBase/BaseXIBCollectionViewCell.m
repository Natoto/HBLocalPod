//
//  BaseXIBCollectionViewCell.m
//  hjb
//
//  Created by boob on 16/3/30.
//  Copyright © 2016年 YY.COM All rights reserved.
//

#import "BaseXIBCollectionViewCell.h"

@implementation BaseXIBCollectionViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setcelldictionary:(NSMutableDictionary *)dictionary{
    
    [super setcelldictionary:dictionary];
    NSNumber * titleFontsize = dictionary[key_cellstruct_titleFont];
    if (titleFontsize.floatValue > 8) {
        UIButton * btn_title = [self valueForKey:@"btn_title"];
        if ([[btn_title class] isSubclassOfClass:[UIButton class]]) {
            btn_title.titleLabel.font = [UIFont systemFontOfSize:titleFontsize.floatValue];
        }
    }
    NSString *textAlignment = [self.dictionary objectForKey:key_cellstruct_textAlignment];
    if (textAlignment) {
        UIButton * btn_title = [self valueForKey:@"btn_title"]; 
        if ([textAlignment isEqualToString:value_cellstruct_textAlignment_left]) {
            [btn_title setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        }
        else if ([textAlignment isEqualToString:value_cellstruct_textAlignment_center]) {
            [btn_title setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        }
        else if ([textAlignment isEqualToString:value_cellstruct_textAlignment_right]) {
            [btn_title setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        }
    }
    
}
@end
