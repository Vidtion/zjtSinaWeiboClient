//
//  TwitterVC.h
//  zjtSinaWeiboClient
//
//  Created by Zhu Jianting on 12-3-14.
//  Copyright (c) 2012年 WS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POIViewController.h"

@class WeiBoMessageManager;

@interface TwitterVC : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,POIViewControllerDelegate>
{
    WeiBoMessageManager *manager;
    BOOL _shouldPostImage;
}
@property (retain, nonatomic) IBOutlet UIScrollView *theScrollView;
@property (retain, nonatomic) IBOutlet UIImageView *theImageView;
@property (retain, nonatomic) IBOutlet UIImageView *TVBackView;

@property (retain, nonatomic) IBOutlet UILabel *countLabel;
@property (retain, nonatomic) IBOutlet UITextView *theTextView;
@property (retain, nonatomic) IBOutlet UIView *mainView;
@end
