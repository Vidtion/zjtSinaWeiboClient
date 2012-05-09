//
//  ZJTStatusBaseVC.h
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-5-9.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import "PullRefreshTableViewController.h"
#import "StatusCell.h"
#import "PullRefreshTableViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "ImageBrowser.h"
#import "WeiBoMessageManager.h"
#import "Status.h"
#import "User.h"
#import "ASIHTTPRequest.h"
#import "HHNetDataCacheManager.h"
#import "GifView.h"
#import "SHKActivityIndicator.h"
#import "ZJTDetailStatusVC.h"

@interface ZJTStatusBaseVC : PullRefreshTableViewController<EGORefreshTableHeaderDelegate,StatusCellDelegate,ImageBrowserDelegate>{
    
    WeiBoMessageManager *manager;
    NSNotificationCenter *defaultNotifCenter;
    
    UINib               *statusCellNib;
    NSMutableArray      *statuesArr;
    NSMutableDictionary *headDictionary;
    NSMutableDictionary *imageDictionary;
    ImageBrowser        *browserView;
    
    BOOL                shouldShowIndicator;
    BOOL                shouldLoad;
    
    BOOL                isFirstCell;
    
	EGORefreshTableHeaderView *_refreshHeaderView;
    
	BOOL _reloading;
}

@property (nonatomic, retain)   UINib                   *statusCellNib;
@property (nonatomic, retain)   NSMutableArray          *statuesArr;
@property (nonatomic, retain)   NSMutableDictionary     *headDictionary;
@property (nonatomic, retain)   NSMutableDictionary     *imageDictionary;
@property (nonatomic, retain)   ImageBrowser            *browserView;

- (void)getImages;
- (void)doneLoadingTableViewData;


@end
