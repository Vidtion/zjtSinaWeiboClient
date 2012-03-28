//
//  AddCommentVC.h
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-3-28.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Status.h"

typedef enum {
    kRepost = 0,        //转发微博
    kReplyAComment,     //回复一条评论
    kReplyAStatus,      //对一条微博进行评论
}VCType;

@interface AddCommentVC : UIViewController
{
    
}
@property (retain, nonatomic) IBOutlet UIImageView *imageV;
@property (retain, nonatomic) IBOutlet UITextView *contentV;
@property (retain, nonatomic) NSString *contentStr;
@property (retain, nonatomic) NSString *weiboID;
@property (retain, nonatomic) Status *status;
@property (assign, nonatomic) VCType vctype;

@end
