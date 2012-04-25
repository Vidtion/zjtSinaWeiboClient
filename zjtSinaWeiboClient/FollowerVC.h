//
//  FollowerVC.h
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-4-25.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPFriendCell.h"

@class WeiBoMessageManager;

@interface FollowerVC : UITableViewController<LPFriendCellDelegate>
{
    NSArray *_usersArr;
    NSMutableDictionary *_userAvatarDic;
    BOOL _isFollowingViewController;
    WeiBoMessageManager *_manager;
    UINib *_followerCellNib;
}

@property (nonatomic,retain) NSArray *userArr;
@property (nonatomic,retain) NSMutableDictionary *userAvatarDic;
@property (nonatomic,assign) BOOL isFollowingViewController;
@property (nonatomic,retain) UINib *followerCellNib;
@end
