//  Created by Rafael Kayumov (RealPoc).
//  Copyright (c) 2013 Rafael Kayumov. License: MIT.

#import <UIKit/UIKit.h>
#import "RKTabItem.h"
#import "RedPoint.h"

typedef struct HorizontalEdgeInsets {
    CGFloat left, right;
} HorizontalEdgeInsets;

static inline HorizontalEdgeInsets HorizontalEdgeInsetsMake (CGFloat left, CGFloat right) {
    HorizontalEdgeInsets insets = {left, right};
    return insets;
}

@class RKTabItem;
@class RKTabView;

@protocol RKTabViewDelegate <NSObject>

//Called for all types except TabTypeButton
- (void)tabView:(RKTabView *)tabView tabBecameEnabledAtIndex:(int)index tab:(RKTabItem *)tabItem;
//Called Only for unexcludable items. (TabTypeUnexcludable)
- (void)tabView:(RKTabView *)tabView tabBecameDisabledAtIndex:(int)index tab:(RKTabItem *)tabItem;

@end

@interface RKTabView : UIView

@property (nonatomic, assign) IBOutlet id<RKTabViewDelegate> delegate;
@property (readwrite) BOOL darkensBackgroundForEnabledTabs;
@property (readwrite) BOOL drawSeparators;
@property (readwrite) BOOL anomalyStyle;  //不规则大小
@property (readwrite) BOOL cannrepeateTap;//可重复点击
@property (nonatomic, strong) UIColor *enabledTabBackgrondColor;
@property (nonatomic, strong) UIFont *titlesFont;
@property (nonatomic, strong) UIColor *titlesFontColor;
@property (nonatomic, strong) NSArray *tabItems;
@property (nonatomic, readwrite) HorizontalEdgeInsets horizontalInsets;

-(UIControl *)tabViewForIndex:(NSInteger)index;

- (UIControl *)tabForItem:(RKTabItem *)tabItem;
- (id)initWithFrame:(CGRect)frame andTabItems:(NSArray *)tabItems;
-(void)selectTabItem:(RKTabItem *)aitem;
-(void)selectTabItemWithIndex:(NSInteger)index;
-(void)unselectTabItemWithIndex:(NSInteger)index;

-(void)setTabItemWithNewmessage:(BOOL)newmsg index:(NSInteger)index;

+(CGFloat)heightOfTabView;
@property (nonatomic, assign,readonly) NSInteger selectIndex;
@property (nonatomic, assign) BOOL showtopline;
@end
