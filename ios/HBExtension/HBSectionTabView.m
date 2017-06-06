//
//  SectionTab.m
//  PENG
//
//  Created by hb on 15/8/7.
//  Copyright (c) 2016年 yy.com All rights reserved.
//

#import "HBSectionTabView.h"
#import "UIButton+PENGPENG.h"
//#import "PENG_Define.h"

@interface HBSectionTabView()
@property(nonatomic,retain) UIButton * selectButton;

@property(nonatomic,retain) UIView  *  underSelectline;

@property(nonatomic,assign) CGFloat margin;
@end

@implementation HBSectionTabView
@synthesize selectedColor = _selectedColor;
@synthesize unselectedColor = _unselectedColor;

#define  TAG_BUTTON_START 1120

-(instancetype)initWithFrame:(CGRect)frame tabTitleArray:(NSArray *)array selectedColor:(UIColor *)selectedColor unselectedColor:(UIColor *)unselectedColor
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //self.backgroundColor = PENG_COLOR_NAVIGATIONBAR;
        //[self drawtabviewsociallayer];
        _titleArray = array;
        self.selectedColor = selectedColor;
        self.unselectedColor = unselectedColor;
        CGFloat WIDTH = [self widthOfButton];
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([[obj class] isSubclassOfClass:[NSString class]])
            {
                CGRect btnframe = CGRectMake(_margin+idx * WIDTH, 0, WIDTH, frame.size.height);
               UIButton * button = [UIButton CreateButtonWithFrame:btnframe andTxt:(NSString *)obj];
                button.showsTouchWhenHighlighted = NO;
                [button setTitleColor:self.selectedColor forState:UIControlStateSelected];
                [button setTitleColor:self.unselectedColor forState:UIControlStateHighlighted];
                [button setFont:[UIFont systemFontOfSize:16]];
                [button setTitleColor:self.unselectedColor forState:UIControlStateNormal];
                [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
               button.tag = TAG_BUTTON_START + idx;
               [self addSubview:button];
                
                if (idx < array.count -1) {
                    UIView * line = [self verLine];
                    line.hidden = !self.showSplitLine;
                    line.center = CGPointMake((idx + 1) * WIDTH, frame.size.height/2);
                    [self addSubview:line];
                } 
                if (0 == idx) {
                    self.selectButton = button;
                    self.selectButton.selected = YES;
                }
            }
        }];
        [self underSelectline];
    }
    return self;
}
 
-(void)drawtabviewsociallayer
{
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.bounds.size.width, 0.5)];
    line.backgroundColor =  [UIColor colorWithWhite:0.6 alpha:0.8];
    [self addSubview:line];
}

/**
 *  选择某一个tag
 *
 *  @param index ITEM序号
 */
-(void)selectItemWithIndex:(NSInteger)index
{
    NSInteger tag = index + TAG_BUTTON_START;
    UIButton * selectbtn = (UIButton *)[self viewWithTag:tag];
    if (selectbtn) {
        [self buttonTap:selectbtn];
    }
}
 
-(void)unselectItemWithIndex:(NSInteger)index
{
    self.selectButton.selected = NO;
    self.underSelectline.frame = CGRectZero;
    self.selectButton = nil;
}
-(IBAction)buttonTap:(id)sender
{
    UIButton * selectbtn = (UIButton *)sender;
    if (self.selectButton != selectbtn) {
        self.selectButton.selected = NO;
        self.selectButton = selectbtn;
        
        NSInteger tagindex = selectbtn.tag - TAG_BUTTON_START;
        _selectIndex = tagindex;
        CGRect  underlineframe = CGRectMake(_margin+([self widthOfButton]- [self sectiontab_underselctlinewidth])/2.0+tagindex *[self widthOfButton] ,
                                            self.bounds.size.height - EsplanadeSectionTabView0121_underSelectline, [self sectiontab_underselctlinewidth], EsplanadeSectionTabView0121_underSelectline);
        [UIView animateKeyframesWithDuration:0.2 delay:0 options:0 animations:^{
            self.underSelectline.frame = underlineframe;
        } completion:^(BOOL finished) {
            self.selectButton.selected = YES;
            self.underSelectline.frame = underlineframe;
        }];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(HBSectionTabView:SelectTabIndex:)]) {
             [self.delegate HBSectionTabView:self SelectTabIndex:tagindex];
        }
    }
}

-(CGFloat)widthOfButton
{
    _margin = 30;
    CGFloat weight = (self.bounds.size.width-_margin*2)/_titleArray.count;
    return weight;
}

-(UIView *)verLine
{
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 10)];
    line.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    return line;
}

float EsplanadeSectionTabView0121_underSelectline = 4;

-(CGFloat)sectiontab_underselctlinewidth
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectiontab_underselctlinewidth)]) {
        CGFloat width = [self.delegate  sectiontab_underselctlinewidth];
        return width;
    }
    return 45.;
}

-(UIView *)underSelectline
{
    if (!_underSelectline)
    {
        CGRect frame = CGRectMake(_margin+([self widthOfButton] - [self sectiontab_underselctlinewidth])/2.0, self.bounds.size.height - EsplanadeSectionTabView0121_underSelectline,[self sectiontab_underselctlinewidth], EsplanadeSectionTabView0121_underSelectline);
        if (self.delegate && [self.delegate respondsToSelector:@selector(sectiontab_underselctlinewidth)]) {
            CGFloat width = [self.delegate  sectiontab_underselctlinewidth];
            frame.size.width = width;
        } 
        _underSelectline = [[UIView alloc] initWithFrame:frame];
        _underSelectline.backgroundColor = self.selectedColor;
        [self addSubview:_underSelectline];
        [self sendSubviewToBack:_underSelectline];
    }
    return _underSelectline;
}
@end
