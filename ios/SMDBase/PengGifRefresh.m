//
//  PengGifHeader.m
//  PENG
//
//  Created by zeno on 16/1/12.
//  Copyright © 2016年 nonato. All rights reserved.
//

#import "PengGifRefresh.h"

@implementation PengGifHeader
-(void)prepare
{
    [super prepare];    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (int i = 1; i<=10; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pengloading%d", i]];
        if(image)
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 1; i<=10; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pengloading%d", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];

}

@end



@implementation PengGifFooter
-(void)prepare
{
    [super prepare];
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (int i = 1; i<=10; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pengloading%d", i]];
        if (image) {
            [idleImages addObject:image];
        }
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 1; i<=10; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pengloading%d", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
}


- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
//    if (self.state != MJRefreshStateIdle || self.mj_y == 0) return;
//    
//    if (_scrollView.mj_insetT + _scrollView.mj_contentH > _scrollView.mj_h) { // 内容超过一个屏幕
//        // 这里的_scrollView.mj_contentH替换掉self.mj_y更为合理
//        if (_scrollView.mj_offsetY >= _scrollView.mj_contentH - _scrollView.mj_h + self.mj_h * 0.5 + _scrollView.mj_insetB - self.mj_h) {
//            // 防止手松开时连续调用
//            CGPoint old = [change[@"old"] CGPointValue];
//            CGPoint new = [change[@"new"] CGPointValue];
//            if (new.y <= old.y) return;
//            // 当底部刷新控件完全出现时，才刷新
//            [self beginRefreshing];
//        }
//    }
}

@end
