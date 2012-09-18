//
//  FollowerVC.h
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-4-25.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPFriendCell.h"
#import "PullRefreshTableViewController.h"

@class WeiBoMessageManager;
@class User;

@interface FollowerVC : PullRefreshTableViewController<LPFriendCellDelegate>
{
    NSArray *_userArr;
    BOOL _isFollowingViewController;
    WeiBoMessageManager *_manager;
    UINib *_followerCellNib;
    User *_user;
}

@property (nonatomic,retain) NSArray *userArr;
@property (nonatomic,assign) BOOL isFollowingViewController;
@property (nonatomic,retain) UINib *followerCellNib;
@property (nonatomic,retain) User *user;

@property (nonatomic,retain) IBOutlet UITableView *table;
@end
