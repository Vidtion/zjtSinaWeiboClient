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


@interface FollowAndFansVC : UIViewController<UITableViewDataSource,UITableViewDelegate,LPFriendCellDelegate>
{
    UITableView *_followTable;
    UITableView *_fansTable;
    WeiBoMessageManager *_manager;
    UINib *_followerCellNib;
    User *_user;
    NSMutableArray *_followUserArr;
    NSMutableArray *_fansUserArr;
    
    UISegmentedControl *_segmentCtrol;
    int _fansCursor;
    int _followCursor;
}

@property (nonatomic,retain)IBOutlet UITableView *followTable;
@property (nonatomic,retain)IBOutlet UITableView *fansTable;
@property (nonatomic,retain) UINib *followerCellNib;
@property (nonatomic,retain) User *user;
@property (nonatomic,retain) NSMutableArray *followUserArr;
@property (nonatomic,retain) NSMutableArray *fansUserArr;
@property (nonatomic,retain) UISegmentedControl *segmentCtrol;

@end
