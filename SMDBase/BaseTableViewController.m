//
//  BaseTableViewController.m
//  PENG
//
//  Created by zeno on 15/12/14.
//  Copyright © 2015年 nonato. All rights reserved.
//

#import "BaseTableViewController.h"
#import "UIView+Transition.h"
#import <MJRefresh/MJRefresh.h>
//#import "UIView+Loading.h"
#import "PengGifRefresh.h"
#import <MJRefresh/MJRefreshStateHeader.h>
//#import "HiidoSdkModel.h"

#import "HBDirWatchdog.h"
#import "UIDevice+HBExtension.h"


#ifndef	weakify
#if __has_feature(objc_arc)
#define weakify( x )	autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x;
#else	// #if __has_feature(objc_arc)
#define weakify( x )	autoreleasepool{} __block __typeof__(x) __block_##x##__ = x;
#endif	// #if __has_feature(objc_arc)
#endif	// #ifndef	weakify

#ifndef	strongify
#if __has_feature(objc_arc)
#define strongify( x )	try{} @finally{} __typeof__(x) x = __weak_##x##__;
#else	// #if __has_feature(objc_arc)
#define strongify( x )	try{} @finally{} __typeof__(x) x = __block_##x##__;
#endif	// #if __has_feature(objc_arc)
#endif	// #ifndef	@normalize


@interface BaseTableViewController ()
{
    
    HBDirWatchdog * watchDog;
}
@end

@implementation BaseTableViewController
@synthesize noHeaderFreshView = _noHeaderFreshView;
@synthesize noFooterView = _noFooterView;

-(void)setNoHeaderFreshView:(BOOL)noHeaderFreshView
{
    if ([self respondsToSelector:@selector(app_use_gifHeader)] && [self app_use_gifHeader]) {
        _noHeaderFreshView = noHeaderFreshView;
        if ([self respondsToSelector:@selector(config_user_gifheader)]) {
            [self config_user_gifheader];
            return;
        }
        if (noHeaderFreshView) {
            [self.tableView.header removeFromSuperview];
        }
        else
        {
            PengGifHeader * header = [PengGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshView)];
            // 隐藏时间
            header.lastUpdatedTimeLabel.hidden = YES;
            // 隐藏状态
            header.stateLabel.hidden = YES;
            self.tableView.header = header;
        }
    }
    else
    {
        [super setNoHeaderFreshView:noHeaderFreshView];
    }
   
}



-(void)setNoFooterView:(BOOL)noFooterView
{
    if ([self respondsToSelector:@selector(app_use_gifFooter)] && [self app_use_gifFooter]) {
        
        _noFooterView = noFooterView;
        if ([self respondsToSelector:@selector(config_user_gifheader)]) {
            [self config_user_giffooter];
            return;
        }
        if (_noFooterView) {
            [self.tableView.footer removeFromSuperview];
        }
        else
        {
            PengGifFooter * footer = [PengGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNextPageView)];
            // 隐藏时间
            //        footer.lastUpdatedTimeLabel.hidden = YES;
            // 隐藏状态
            footer.stateLabel.hidden = YES;
            self.tableView.footer = footer;
        }
    }
    else {
        [super setNoFooterView:noFooterView];
    }
}
/**
 *  从PLIST 文件中加载配置信息
 *
 *  @param plistname plist文件的名字
 */
-(void)loadplistConfig:(NSString *)plistname
{
    
#if DEBUG && TARGET_IPHONE_SIMULATOR 
    
    NSString *rootPath = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"projectPath"];
    
    NSString *scriptRootPath = [rootPath stringByAppendingPathComponent:@"resource.bundle"];
    NSString *mainScriptPath = [NSString stringWithFormat:@"%@/%@.plist", scriptRootPath, plistname];
    
    @weakify(self)
    watchDog = [[HBDirWatchdog alloc] initWithPath:scriptRootPath update:^{
        @strongify(self)
        [self loadplistConfig:plistname filepath:mainScriptPath];
        [self configcellstructs];
        [self.tableView reloadData];
    }];
    [watchDog start];
    [super loadplistConfig:plistname filepath:mainScriptPath];
    
#else
    NSString *rootPath = [[NSBundle mainBundle] pathForResource:plistname ofType:@"plist" inDirectory:@"resource.bundle"];
    [super loadplistConfig:plistname filepath:rootPath];
#endif
}

-(void)configcellstructs{
}

-(void)startHeaderLoading
{
    [self.tableView.mj_header beginRefreshing];
} 

-(void)viewDidLoad
{
    [super viewDidLoad]; 
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {//这个是需要的
//        self.edgesForExtendedLayout = UIRectEdgeAll;//UIRectEdgeNone;
//    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setExtraCellLineHidden:self.tableView];
    [self.view sendSubviewToBack:self.tableView];
    
    if(IOS11_OR_LATER){
        self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    }
    else{
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }
    
    if (self.navigationController.childViewControllers.count > 1 && self.navigationController.topViewController == self) {
        self.showBackItem = YES;
    }
}


-(BOOL)isShowLoadingView
{
    return NO;
}

-(void)FinishedLoadData
{
    [super FinishedLoadData];
//    [self.view hideloadingview];
}

-(void)noticeNoMoreData
{
    [self.tableView.footer noticeNoMoreData];
}

-(void)finishReloadingData
{
    [super finishReloadingData];
    
    
//    [self.view hideloadingview];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   UIView * view = [super tableView:tableView viewForHeaderInSection:section];
   CELL_STRUCT *cell_struce = [self.dataDictionary objectForKey:KEY_INDEXPATH(section, 0)];
   UIColor * sectioncolor = [cell_struce.dictionary objectForKey:key_cellstruct_sectionbguicolor];
   if (sectioncolor && [[sectioncolor class] isSubclassOfClass:[UIColor class]]) {
        view.backgroundColor = sectioncolor;
    }
    return view;
}
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)removeDataDictionaryForSection:(NSInteger)section
{
    NSMutableArray * sectionkeys = [NSMutableArray new];
    [self.dataDictionary.allKeys enumerateObjectsUsingBlock:^(NSString * sectionrowkey, NSUInteger idx, BOOL * stop) {
        NSString * sectionstr = KEY_SECTION_INDEX_STR(sectionrowkey);
        if (sectionstr && sectionstr.integerValue == section) {
            [sectionkeys addObject:sectionrowkey];
        }
    }];
    if (sectionkeys.count) {
        [self.dataDictionary removeObjectsForKeys:sectionkeys];
    }
}

-(NSInteger)countDataDictionaryForSection:(NSInteger)section
{
    __block NSInteger count = 0;
    NSMutableArray * sectionkeys = [NSMutableArray new];
    [self.dataDictionary.allKeys enumerateObjectsUsingBlock:^(NSString * sectionrowkey, NSUInteger idx, BOOL * stop) {
        NSString * sectionstr = KEY_SECTION_INDEX_STR(sectionrowkey);
        if (sectionstr && sectionstr.integerValue == section) {
            count++;
        }
    }];
    return count;
}


#pragma mark - 页面跳转统计
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [HiidoSdkModel enterPage:[self class] title:self.navigationbar.title];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [HiidoSdkModel leavePageId:self.navigationbar.title destPageId:nil];
}


#pragma mark - 网络错误
ON_HBSIGNAL(Network, notify_NetworkError, notify)
{
    NSLogMethod;
    [self dismissAllTips];
    [self FinishedLoadData];
}

-(void)dealloc
{
    NSLogMethod
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    REMOVE_HBSIGNAL_OBSERVER(self, notify_NetworkError,  notify_sender_Network)
}

/**
 *  移除某一section的cellstruct
 *
 *  @param sectionindex section序号
 */
-(void)removeSectionStructsFromdataDictionary:(NSInteger)sectionindex
{
    [self.dataDictionary.allKeys enumerateObjectsUsingBlock:^(NSString * key, NSUInteger idx, BOOL *stop) {
        NSString * section = KEY_SECTION_INDEX_STR(key);
        if (section.integerValue == sectionindex) {
            [self.dataDictionary removeObjectForKey:key];
        }
    }];
}
@end
