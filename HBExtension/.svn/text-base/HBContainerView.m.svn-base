//
//  HBPagableViewController.m
//  switchchildcontrollers
//
//  Created by zeno on 16/1/25.
//  Copyright © 2016年 YY.COM All rights reserved.
//

#import "HBContainerView.h"

@interface HBContainerView ()<UIScrollViewDelegate>
@property(nonatomic,strong) UIScrollView * scrollView;

@end

@implementation HBContainerView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.alwaysBounceVertical = NO;
        scrollView.bounces = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return self;
}

-(void)setContainerDelegate:(NSObject<HBContainerViewDelegate> *)containerDelegate
{
    _containerDelegate = containerDelegate;
    if (_containerDelegate) {
        self.scrollView.contentSize = CGSizeMake([self numberOfControllers] * self.frame.size.width, self.bounds.size.height);
        if ([self numberOfControllers])
        {
            [self addpage:0];
        }
    }
}

-(NSInteger)numberOfControllers
{
    NSInteger count = 0;
    if (self.containerDelegate && [self.containerDelegate respondsToSelector:@selector(numberOfControllersInHBContainer:)]) {
        count = [self.containerDelegate numberOfControllersInHBContainer:self];
    }
    return count;
}

-(UIView *)subcontrollerviewOfIndex:(NSInteger)index
{
    UIView * view = nil;
    if (self.containerDelegate && [self.containerDelegate respondsToSelector:@selector(hbcontainer:subControllerForIndex:)]) {
        UIViewController * ctr  = [self.containerDelegate hbcontainer:self subControllerForIndex:index];
        view = ctr.view;
    }
    return view;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int pageIndex = ceilf(scrollView.contentOffset.x/scrollView.bounds.size.width);
    [self addpage:pageIndex];
}

-(void)addpage:(NSInteger)pageIndex
{
    UIView * subview = [self subcontrollerviewOfIndex:pageIndex];
    if (subview && ![self.scrollView.subviews containsObject:subview]) {
        [self.scrollView addSubview:subview];
        subview.frame = CGRectMake(pageIndex * self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        
        NSLog(@"create %ld page",(long)pageIndex);
    }
}

#pragma mark - 图片停止时,调用该函数使得滚动视图复用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int pageIndex = scrollView.contentOffset.x/scrollView.bounds.size.width;
    
    if (self.containerDelegate && [self.containerDelegate respondsToSelector:@selector(hbcontainer:selectIndex:)]) {
        [self.containerDelegate hbcontainer:self selectIndex:pageIndex];
    }
}

-(void)swithSubControllerWithIndex:(NSInteger)selectIndex
{
    [self.scrollView setContentOffset:CGPointMake(selectIndex * self.scrollView.bounds.size.width, 0)];
}
@end
