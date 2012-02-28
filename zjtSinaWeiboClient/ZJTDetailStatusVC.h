//
//  ZJTDetailStatusVC.h
//  zjtSinaWeiboClient
//
//  Created by jianting zhu on 12-2-28.
//  Copyright (c) 2012年 Dunbar Science & Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJTDetailStatusVC : UIViewController
{
    UIView *headerView;
    UITableView *table;
    UIImageView *avatarImageV;
    UILabel *twitterNameLB;
    UITextView *contentTF;
    UIImageView *contentImageV;
    UIView *retwitterMainV;
    UITextView *retwitterTF;
    UIImageView *retwitterImageV;
    UILabel *timeLB;
    UILabel *countLB;
}
@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) IBOutlet UITableView *table;
@property (retain, nonatomic) IBOutlet UIImageView *avatarImageV;
@property (retain, nonatomic) IBOutlet UILabel *twitterNameLB;
@property (retain, nonatomic) IBOutlet UITextView *contentTF;
@property (retain, nonatomic) IBOutlet UIImageView *contentImageV;
@property (retain, nonatomic) IBOutlet UIView *retwitterMainV;
@property (retain, nonatomic) IBOutlet UITextView *retwitterTF;
@property (retain, nonatomic) IBOutlet UIImageView *retwitterImageV;
@property (retain, nonatomic) IBOutlet UILabel *timeLB;
@property (retain, nonatomic) IBOutlet UILabel *countLB;


@end
