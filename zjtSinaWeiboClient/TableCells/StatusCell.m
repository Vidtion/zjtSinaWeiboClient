//
//  StatusCell.m
//  zjtSinaWeiboClient
//
//  Created by jianting zhu on 12-1-5.
//  Copyright (c) 2012年 Dunbar Science & Technology. All rights reserved.
//

#import "StatusCell.h"

@implementation StatusCell
@synthesize avatarImage;
@synthesize contentTF;
@synthesize commentButton;
@synthesize userNameLB;
@synthesize forwardButton;
@synthesize bgImage;

-(CGFloat)getTFHeight
{
    [contentTF layoutIfNeeded];
    
    CGRect frame = contentTF.frame;
    frame.size = contentTF.contentSize;
    contentTF.frame = frame;
    
    bgImage.image = [[UIImage imageNamed:@"table_header_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    
    return contentTF.contentSize.height;
}

- (void)dealloc {
    [forwardButton release];
    [commentButton release];
    [avatarImage release];
    [contentTF release];
    [userNameLB release];
    [bgImage release];
    [super dealloc];
}
@end
