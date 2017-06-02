//
//  BaseCollectionViewController.h
//  PENG
//
//  Created by zeno on 15/12/14.
//  Copyright © 2015年 nonato. All rights reserved.
//
#import <HBKit/HBKit.h>
#import "BaseViewControllerProtocol.h"

/* 配置实例
 -(NSInteger)configColumnCount
 {
 return 4;
 }
 -(NSInteger)collectionView:(UICollectionView *)collectionView  ColumnCountOfSection:(NSInteger)section
 {
 if (section == 0) {
 return 4;
 }
 return 1;
 }
 -(CGFloat)configMinimumColumnSpacing
 {
 return 1;
 }
 
 -(CGFloat)configMinimumInteritemSpacing
 {
 return 1;
 } 
 */
@interface BaseCollectionViewController : HBBaseCollectionViewController<BaseViewControllerProtocol>
@property(nonatomic,strong) NSNumber * thiscreateTime;
//@property(nonatomic,retain) HBNavigationbar * navigationbar;
//@property(nonatomic,retain) HBNavigationbar * navigationtoolsbar;
-(void)startHeaderLoading;
-(void)noticeNoMoreData;

-(void)removeDataDictionaryForSection:(NSInteger)section;
@end
