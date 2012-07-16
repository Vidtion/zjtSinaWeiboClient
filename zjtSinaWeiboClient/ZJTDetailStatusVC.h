//
//  ZJTDetailStatusVC.h
//  zjtSinaWeiboClient
//
//  Created by jianting zhu on 12-2-28.
//  Copyright (c) 2012年 Dunbar Science & Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"
#import "Status.h"
#import "User.h"
#import "ImageBrowser.h"
#import "StatusCell.h"
#import "JSTwitterCoreTextView.h"

#define IMAGES_VIEW_HEIGHT 100.0f

@class WeiBoMessageManager;
@class Comment;

@interface ZJTDetailStatusVC : PullRefreshTableViewController<UITableViewDelegate,UITableViewDataSource,JSCoreTextViewDelegate,ImageBrowserDelegate,UIActionSheetDelegate>
{
    UIView      *headerView;
    UITableView *table;
    UIImageView *avatarImageV;
    UILabel     *twitterNameLB;
    UITextView  *contentTF;
    UIImageView *contentImageV;
    UIView      *retwitterMainV;
    UITextView  *retwitterTF;
    UIImageView *retwitterImageV;
    UILabel     *timeLB;
    UILabel     *countLB;
    
    UINib       *commentCellNib;
    JSTwitterCoreTextView *_JSContentTF;
    JSTwitterCoreTextView *_JSRetitterContentTF;
    
    WeiBoMessageManager *manager;
    
    //data
    Status  *status;
    User    *user;
    
    UIImage         *avatarImage;
    UIImage         *contentImage;
    NSMutableArray  *commentArr;
    
    BOOL _hasRetwitter;
    BOOL _haveRetwitterImage;
    BOOL _hasImage;
    BOOL shouldShowIndicator;
    
    int _page;
    NSString *_maxID;
}
@property (retain, nonatomic) IBOutlet UIImageView  *headerBackgroundView;
@property (retain, nonatomic) IBOutlet UIImageView  *mainViewBackView;

@property (retain, nonatomic) IBOutlet UIView       *headerView;
@property (retain, nonatomic) IBOutlet UITableView  *table;
@property (retain, nonatomic) IBOutlet UIImageView  *avatarImageV;
@property (retain, nonatomic) IBOutlet UILabel      *twitterNameLB;
@property (retain, nonatomic) IBOutlet UITextView   *contentTF;
@property (retain, nonatomic) IBOutlet UIImageView  *contentImageV;
@property (retain, nonatomic) IBOutlet UIView       *retwitterMainV;
@property (retain, nonatomic) IBOutlet UITextView   *retwitterTF;
@property (retain, nonatomic) IBOutlet UIImageView  *retwitterImageV;
@property (retain, nonatomic) IBOutlet UILabel      *timeLB;
@property (retain, nonatomic) IBOutlet UILabel      *countLB;
@property (retain, nonatomic) UINib                 *commentCellNib;
@property (retain, nonatomic) Status                *status;
@property (retain, nonatomic) User                  *user;
@property (retain, nonatomic) UIImage               *avatarImage;
@property (retain, nonatomic) UIImage               *contentImage;
@property (retain, nonatomic) NSMutableArray        *commentArr;
@property (assign, nonatomic) BOOL                  isFromProfileVC;
@property (retain, nonatomic) ImageBrowser          *browserView;
@property (nonatomic,retain)JSTwitterCoreTextView *JSContentTF;
@property (nonatomic,retain)JSTwitterCoreTextView *JSRetitterContentTF;
@property (retain, nonatomic) IBOutlet UIImageView *contentImageBackgroundView;
@property (retain, nonatomic) IBOutlet UIImageView *retwitterImageBackground;
@property (retain, nonatomic) IBOutlet UIImageView *retwitterCountImageView;
@property (retain, nonatomic) IBOutlet UIImageView *commentCountImageView;
@property (retain, nonatomic) IBOutlet UIImageView *vipImageView;
@property (retain, nonatomic) Comment *clickedComment;

@end
