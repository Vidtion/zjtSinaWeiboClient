//
//  StatusCell.h
//  zjtSinaWeiboClient
//
//  Created by jianting zhu on 12-1-5.
//  Copyright (c) 2012年 Dunbar Science & Technology. All rights reserved.
//

#import "LPBaseCell.h"

@interface StatusCell : LPBaseCell
{
    
}
@property (retain, nonatomic) IBOutlet UIImageView *avatarImage;
@property (retain, nonatomic) IBOutlet UITextView *contentTF;
@property (retain, nonatomic) IBOutlet UIButton *commentButton;
@property (retain, nonatomic) IBOutlet UILabel *userNameLB;
@property (retain, nonatomic) IBOutlet UIButton *forwardButton;
@property (retain, nonatomic) IBOutlet UIImageView *bgImage;
@property (retain, nonatomic) IBOutlet UIImageView *contentImage;

@property (retain, nonatomic) IBOutlet UIView *retwitterMainV;


-(CGFloat)getTFHeight;
@property (retain, nonatomic) IBOutlet UIImageView *retwitterBgImage;
@property (retain, nonatomic) IBOutlet UITextView *retwitterContentTF;
@property (retain, nonatomic) IBOutlet UIImageView *retwitterContentImage;

@end
