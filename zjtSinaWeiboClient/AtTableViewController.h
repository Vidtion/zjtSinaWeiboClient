//
//  AtTableViewController.h
//  zjtSinaWeiboClient
//
//  Created by Zhu Jianting on 12-8-7.
//  Copyright (c) 2012年 WS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPFriendCell.h"

@class WeiBoMessageManager;
@class User;

@protocol AtTableViewControllerDelegate <NSObject>

-(void)atTableViewControllerCellDidClickedWithScreenName:(NSString*)name;

@end

@interface AtTableViewController : UITableViewController<UISearchDisplayDelegate, UISearchBarDelegate>
{
    NSArray *_userArr;
    WeiBoMessageManager *_manager;
    UINib *_followerCellNib;
    User *_user;
    
}
@property (nonatomic,retain) NSArray *userArr;
@property (nonatomic,retain) NSMutableArray *filteredUserArr;
@property (nonatomic,retain) UINib *followerCellNib;
@property (nonatomic,retain) User *user;
@property (nonatomic,assign) id<AtTableViewControllerDelegate> delegate;
@property (nonatomic,retain) UISearchBar *searchBar;
@property (nonatomic,retain) UISearchDisplayController *searchDisplayCtrl;

@end
