//
//  ZJTCommentCell.m
//  zjtSinaWeiboClient
//
//  Created by jianting zhu on 12-2-28.
//  Copyright (c) 2012年 Dunbar Science & Technology. All rights reserved.
//

#import "ZJTCommentCell.h"

@implementation ZJTCommentCell

@synthesize nameLB;
@synthesize timeLB;
@synthesize contentLB;
@synthesize replyBtn;

@synthesize delegate;

@synthesize cellIndexPath;
@synthesize avatarImage;
@synthesize vipImageView;

-(IBAction)replyBtnClicked:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(commentCellDidSelect:indexPath:)]) 
    {
        [delegate commentCellDidSelect:self indexPath:self.cellIndexPath];
    }
}

- (void)dealloc
{
    self.cellIndexPath = nil;
    
    [nameLB release];
    [timeLB release];
    [contentLB release];
    [replyBtn release];
    [avatarImage release];
    [vipImageView release];
    [super dealloc];
}

@end
