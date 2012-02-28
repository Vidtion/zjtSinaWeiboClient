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


- (void)dealloc
{
    [nameLB release];
    [timeLB release];
    [contentLB release];
    [replyBtn release];
    [super dealloc];
}

@end
