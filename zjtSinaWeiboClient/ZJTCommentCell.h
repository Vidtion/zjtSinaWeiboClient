//
//  ZJTCommentCell.h
//  zjtSinaWeiboClient
//
//  Created by jianting zhu on 12-2-28.
//  Copyright (c) 2012年 Dunbar Science & Technology. All rights reserved.
//

#import "LPBaseCell.h"

@class ZJTCommentCell;

@protocol ZJTCommentCellDelegate <NSObject>

-(void)commentCellDidSelect:(ZJTCommentCell*)commentCell indexPath:(NSIndexPath*)indexPath;

@end

@interface ZJTCommentCell : LPBaseCell
{
    UILabel *nameLB;
    UILabel *timeLB;
    UILabel *contentLB;
    UIButton *replyBtn;
    id<ZJTCommentCellDelegate> delegate;
    NSIndexPath *cellIndexPath;
}
@property (retain, nonatomic) IBOutlet UILabel *nameLB;
@property (retain, nonatomic) IBOutlet UILabel *timeLB;
@property (retain, nonatomic) IBOutlet UILabel *contentLB;
@property (retain, nonatomic) IBOutlet UIButton *replyBtn;
@property (assign, nonatomic) id<ZJTCommentCellDelegate> delegate;
@property (retain, nonatomic) NSIndexPath *cellIndexPath;
@property (retain, nonatomic) IBOutlet UIImageView *avatarImage;
@property (retain, nonatomic) IBOutlet UIImageView *vipImageView;

@end
