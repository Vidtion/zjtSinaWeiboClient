//
//  TwitterVC.h
//  zjtSinaWeiboClient
//
//  Created by Zhu Jianting on 12-3-14.
//  Copyright (c) 2012年 WS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POIViewController.h"
#import "AtTableViewController.h"

@class WeiBoMessageManager;

@interface TwitterVC : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,POIViewControllerDelegate,AtTableViewControllerDelegate>
{
    WeiBoMessageManager *manager;
    BOOL _shouldPostImage;
    BOOL _isForReply;
    BOOL _isForComment;
    BOOL _isForRepost;
}
@property (retain, nonatomic) IBOutlet UIScrollView *theScrollView;
@property (retain, nonatomic) IBOutlet UIImageView *theImageView;
@property (retain, nonatomic) IBOutlet UIImageView *TVBackView;

@property (retain, nonatomic) IBOutlet UILabel *countLabel;
@property (retain, nonatomic) IBOutlet UITextView *theTextView;
@property (retain, nonatomic) IBOutlet UIView *mainView;

@property (retain, nonatomic) IBOutlet UIButton *locationButton;

@property (retain, nonatomic) IBOutlet UIButton *topicButton;
@property (retain, nonatomic) IBOutlet UIButton *photoButton;
@property (retain, nonatomic) IBOutlet UIButton *atButton;

//@property (nonatomic,assign) NSString *commentID;
//@property (nonatomic,assign) NSString *
@property (nonatomic,retain) NSString *weiboID;
@property (nonatomic,retain) NSString *commentID;

-(void)setupForReply;
-(void)setupForComment:(NSString*)comID weiboID:(NSString*)wbID;
-(void)setupForRepost:(NSString*)wbID;

@end
