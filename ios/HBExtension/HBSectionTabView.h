//
//  SectionTab.h
//  PENG
//
//  Created by hb on 15/8/7.
//  Copyright (c) 2016年 yy.com All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HBSectionTabViewDelegate;

@interface HBSectionTabView : UIControl
@property(nonatomic,assign) NSObject <HBSectionTabViewDelegate>  *delegate;//<CF_HomeSectionTabViewDelegate>
@property(nonatomic,retain) UIColor * selectedColor;
@property(nonatomic,retain) UIColor * unselectedColor;
@property(nonatomic,assign) BOOL       showSplitLine;
@property(nonatomic,retain,readonly) NSArray *  titleArray;
//@property(nonatomic,assign) BOOL  showLeftItem;
//@property(nonatomic,assign) BOOL  showRightItem;
//@property(nonatomic,assign) BOOL  showBackItem;

//@property(nonatomic,assign) NSInteger  selectIndex;//当前选择 设置不发送通知
-(instancetype)initWithFrame:(CGRect)frame tabTitleArray:(NSArray *)array selectedColor:(UIColor *)selectedColor unselectedColor:(UIColor *)unselectedColor;
/**
 *  选择某一个tag
 *
 *  @param index ITEM序号
 */

-(void)selectItemWithIndex:(NSInteger)index;
-(void)unselectItemWithIndex:(NSInteger)index;
@property (nonatomic, assign,readonly) NSInteger selectIndex;
@end


@protocol HBSectionTabViewDelegate
-(void)HBSectionTabView:(HBSectionTabView *)SectionTabView SelectTabIndex:(NSInteger)tabindex;
@optional

-(CGFloat)sectiontab_underselctlinewidth; 
@end
