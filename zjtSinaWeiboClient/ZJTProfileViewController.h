//
//  ZJTProfileViewController.h
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-7-14.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@class ZJTProfileCell;

@interface ZJTProfileViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (retain, nonatomic) IBOutlet UITableView *table;
@property (retain, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (retain, nonatomic) IBOutlet UIImageView *genderImageView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UIButton *followButton;
@property (retain, nonatomic) IBOutlet UIImageView *vipImageView;
@property (retain, nonatomic) IBOutlet UIButton *fansButton;
@property (retain, nonatomic) IBOutlet UIButton *idolButton;
@property (retain, nonatomic) IBOutlet UIButton *weiboButton;
@property (retain, nonatomic) IBOutlet UIButton *topicButton;
@property (retain, nonatomic) IBOutlet UIView *tableHeaderView;
@property (nonatomic,retain)  NSString *screenName;
@property (nonatomic, retain) User *user;
@property (retain, nonatomic) IBOutlet ZJTProfileCell *verifiedProfileCell;

@property (retain, nonatomic) IBOutlet ZJTProfileCell *locationProfileCell;
@property (retain, nonatomic) IBOutlet ZJTProfileCell *descriptionProfileCell;

@property (nonatomic,retain) NSArray *topicsArr;

@end

@interface ZJTProfileCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UILabel *contentLabel;
@property (nonatomic,retain) IBOutlet UILabel *titleLabel;

@end
