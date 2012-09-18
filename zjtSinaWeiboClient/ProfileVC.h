//
//  ProfileVC.h
//  zjtSinaWeiboClient
//
//  Created by jianting zhu on 12-2-25.
//  Copyright (c) 2012年 Dunbar Science & Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusCell.h"
#import "PullRefreshTableViewController.h"
#import "User.h"
#import "ImageBrowser.h"

@class WeiBoMessageManager;
@class ImageBrowser;

#define kTextViewPadding            16.0
#define kLineBreakMode              UILineBreakModeWordWrap

@interface ProfileVC : PullRefreshTableViewController<UITableViewDelegate,UITableViewDataSource,StatusCellDelegate,ImageBrowserDelegate>
{
    WeiBoMessageManager *manager;
    NSNotificationCenter *defaultNotifCenter;
    
    UITableView         *table;
    NSString            *userID;
    NSString            *screenName;
    UINib               *statusCellNib;
    NSMutableArray      *statuesArr;
    NSMutableDictionary *imageDictionary;
    ImageBrowser        *browserView;
    
    
    BOOL                shouldShowIndicator;
    BOOL                shouldLoad;
    BOOL                shouldLoadAvatar;
    BOOL                isFirstCell;
    
    int _page;
    long long _maxID;
}

@property (retain, nonatomic)   IBOutlet UITableView    *table;
@property (nonatomic, copy)     NSString                *userID;
@property (nonatomic, retain)   UINib                   *statusCellNib;
@property (nonatomic, retain)   NSMutableArray          *statuesArr;
@property (nonatomic, retain)   NSMutableDictionary     *imageDictionary;
@property (nonatomic, retain)   ImageBrowser            *browserView;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) UIImage *avatarImage;
@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) IBOutlet UIImageView *headerVImageV;
@property (retain, nonatomic) IBOutlet UILabel *headerVNameLB;
@property (retain, nonatomic) IBOutlet UILabel *weiboCount;
@property (retain, nonatomic) IBOutlet UILabel *followerCount;
@property (retain, nonatomic) IBOutlet UILabel *followingCount;
@property (retain, nonatomic) NSString *screenName;
@end
