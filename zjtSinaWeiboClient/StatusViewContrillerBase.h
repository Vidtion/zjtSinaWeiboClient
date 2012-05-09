//
//  StatusViewContrillerBase.h
//  zjtSinaWeiboClient
//
//  Created by jtone z on 11-11-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusCell.h"
#import "PullRefreshTableViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "ImageBrowser.h"

@class WeiBoMessageManager;

@interface FirstViewController : PullRefreshTableViewController<EGORefreshTableHeaderDelegate,UITableViewDelegate,UITableViewDataSource,StatusCellDelegate,ImageBrowserDelegate>{

    WeiBoMessageManager *manager;
    NSNotificationCenter *defaultNotifCenter;
    
    UITableView         *table;
    NSString            *userID;
    UINib               *statusCellNib;
    NSMutableArray      *statuesArr;
    NSMutableDictionary *headDictionary;
    NSMutableDictionary *imageDictionary;
    ImageBrowser        *browserView;
    
    BOOL                shouldShowIndicator;
    BOOL                shouldLoad;
    BOOL                shouldLoadAvatar;
    
    BOOL                isFirstCell;
    
	EGORefreshTableHeaderView *_refreshHeaderView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
}

@property (retain, nonatomic)   IBOutlet UITableView    *table;
@property (nonatomic, copy)     NSString                *userID;
@property (nonatomic, retain)   UINib                   *statusCellNib;
@property (nonatomic, retain)   NSMutableArray          *statuesArr;
@property (nonatomic, retain)   NSMutableDictionary     *headDictionary;
@property (nonatomic, retain)   NSMutableDictionary     *imageDictionary;
@property (nonatomic, retain)   ImageBrowser            *browserView;

@end
