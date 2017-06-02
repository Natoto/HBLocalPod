//
//  BaseTableViewController.h
//  PENG
//
//  Created by zeno on 15/12/14.
//  Copyright © 2015年 nonato. All rights reserved.
//

#import <HBKit/HBKit.h>
#import "BaseViewController.h"
#import "BaseViewControllerProtocol.h"
#import "PENGProtocol.h"
#import "NSObject+HBHUD.h"
#define TABLEVIEW_REGISTER_CELLCLASS(TABLEVIEW,CELLCLSSTR) {[TABLEVIEW registerClass:NSClassFromString(CELLCLSSTR) forCellReuseIdentifier:CELLCLSSTR];}

#define TABLEVIEW_CELL_SEPARATOR_NONE self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
static NSString * key_cellstruct_sectionbguicolor = @"key_cellstruct_sectionuicolor";

@interface BaseTableViewController : HBBaseTableViewController<PENGCellProtocol,BaseViewControllerProtocol>
//@property(nonatomic,retain) HBNavigationbar * navigationbar;
//@property(nonatomic,retain) HBNavigationbar * navigationtoolsbar;

/**
 *  是否显示loading动画 需要重载
 *
 *  @return 是否
 */
-(BOOL)isShowLoadingView;
//当前controller创建时间 用于返回的时候发通知
@property (nonatomic,strong) NSNumber *  thiscreateTime;

-(void)removeDataDictionaryForSection:(NSInteger)section;

/**
 *  从PLIST 文件中加载配置信息
 *
 *  @param plistname plist文件的名字
 */
-(void)loadplistConfig:(NSString *)plistname;



/**
 *  移除某一section的cellstruct
 *
 *  @param sectionindex section序号
 */
-(void)removeSectionStructsFromdataDictionary:(NSInteger)sectionindex;


-(void)noticeNoMoreData;
-(void)configcellstructs;//空方法

-(NSInteger)countDataDictionaryForSection:(NSInteger)section;
@end
