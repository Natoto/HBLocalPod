//
//  BaseCollectionViewController.m
//  PENG
//
//  Created by zeno on 15/12/14.
//  Copyright © 2015年 nonato. All rights reserved.
//

#import "BaseCollectionViewController.h"
#import "HBSignalBus.h"
#import "NSObject+HBHUD.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "PengGifRefresh.h"
#import <MJRefresh/MJRefresh.h>
//#import "HiidoSdkModel.h"

#import "HBDirWatchdog.h"

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

@interface BaseCollectionViewController ()
{
    
    HBDirWatchdog * watchDog;
}
@end

@implementation BaseCollectionViewController
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
            [self.collectionView.header removeFromSuperview];
        }
        else
        {
            PengGifHeader * header = [PengGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshView)];
            // 隐藏时间
            header.lastUpdatedTimeLabel.hidden = YES;
            // 隐藏状态
            header.stateLabel.hidden = YES;
            self.collectionView.header = header;
        }
    }
    else
    {
        [super setNoHeaderFreshView:noHeaderFreshView];
    }
   
}

-(void)setNoFooterView:(BOOL)noFooterView
{
    if ([self respondsToSelector:@selector(app_use_gifFooter)] &&  [self app_use_gifFooter]) {
        _noFooterView = noFooterView;
        if ([self respondsToSelector:@selector(config_user_gifheader)]) {
            [self config_user_giffooter];
            return;
        }
        if (_noFooterView) {
            [self.collectionView.footer removeFromSuperview];
        }
        else
        {
            PengGifFooter * footer = [PengGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNextPageView)];
            // 隐藏时间
            //        footer.lastUpdatedTimeLabel.hidden = YES;
            // 隐藏状态
            footer.stateLabel.hidden = YES;
            self.collectionView.footer = footer;
        }
    }
    else
    {
        [super setNoFooterView:noFooterView];
    }
 
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //不自动偏移位置
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }
//    self.fd_prefersNavigationBarHidden = YES;
//    self.view.backgroundColor =   KT_UIColorWithRGB(239,239,239);
    ADD_HBSIGNAL_OBSERVER(self, @"networkerror", @"HTTPSEngine");
    if (self.navigationController.childViewControllers.count > 1 && self.navigationController.topViewController == self) {
        self.showBackItem = YES;
    }
//    [self adjustContentOffSet:HEIGHT_NAVIGATIONBAR bottom:0];
    self.collectionView.backgroundColor = self.view.backgroundColor;
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
        [self.collectionView reloadData];
    }];
    [watchDog start];
    [super loadplistConfig:plistname filepath:mainScriptPath];
    
#else
    NSString *rootPath = [[NSBundle mainBundle] pathForResource:plistname ofType:@"plist" inDirectory:@"resource.bundle"];
    [super loadplistConfig:plistname filepath:rootPath];
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(NSString *)valiateCellClass:(NSString *)cellclass
{
    if ([cellclass isEqualToString:@"HBBaseTableViewCell"]) {
        return @"BaseXIBCollectionViewCell";
    }
    return cellclass;
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
-(void)startHeaderLoading{
    [self.collectionView.header beginRefreshing];
}

-(void)noticeNoMoreData{
    [self.collectionView.footer noticeNoMoreData];
}

-(void)dealloc
{
    NSLogMethod
    [[NSNotificationCenter  defaultCenter] removeObserver:self];
//    REMOVE_HBSIGNAL_OBSERVER(self, notify_NetworkError,  notify_sender_Network)
}
@end
