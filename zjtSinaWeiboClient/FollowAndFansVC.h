//
//  FollowAndFansVC.h
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-7-2.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPFriendCell.h"

@class WeiBoMessageManager;
@class User;


@interface FollowAndFansVC : UIViewController
{
    UITableView *_followTable;
    UITableView *_fansTable;
    WeiBoMessageManager *_manager;
    UINib *_followerCellNib;
    User *_user;
    NSArray *_followUserArr;
    NSArray *_fansUserArr;
}

@property (nonatomic,retain)IBOutlet UITableView *followTable;
@property (nonatomic,retain)IBOutlet UITableView *fansTable;
@property (nonatomic,retain) UINib *followerCellNib;
@property (nonatomic,retain) User *user;
@property (nonatomic,retain) NSArray *followUserArr;
@property (nonatomic,retain) NSArray *fansUserArr;

@end
