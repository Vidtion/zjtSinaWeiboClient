//
//  ZJTCommentCell.h
//  zjtSinaWeiboClient
//
//  Created by jianting zhu on 12-2-28.
//  Copyright (c) 2012年 Dunbar Science & Technology. All rights reserved.
//

#import "LPBaseCell.h"

@interface ZJTCommentCell : LPBaseCell
{
    UILabel *nameLB;
    UILabel *timeLB;
    UILabel *contentLB;
    UIButton *replyBtn;
}
@property (retain, nonatomic) IBOutlet UILabel *nameLB;
@property (retain, nonatomic) IBOutlet UILabel *timeLB;
@property (retain, nonatomic) IBOutlet UILabel *contentLB;
@property (retain, nonatomic) IBOutlet UIButton *replyBtn;

@end
