//
//  ZJTDetailStatusVC.m
//  zjtSinaWeiboClient
//
//  Created by jianting zhu on 12-2-28.
//  Copyright (c) 2012年 Dunbar Science & Technology. All rights reserved.
//

#import "ZJTDetailStatusVC.h"

@implementation ZJTDetailStatusVC
@synthesize headerView;
@synthesize table;
@synthesize avatarImageV;
@synthesize twitterNameLB;
@synthesize contentTF;
@synthesize contentImageV;
@synthesize retwitterMainV;
@synthesize retwitterTF;
@synthesize retwitterImageV;
@synthesize timeLB;
@synthesize countLB;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setHeaderView:nil];
    [self setTable:nil];
    [self setAvatarImageV:nil];
    [self setTwitterNameLB:nil];
    [self setContentTF:nil];
    [self setContentImageV:nil];
    [self setRetwitterMainV:nil];
    [self setRetwitterTF:nil];
    [self setRetwitterImageV:nil];
    [self setTimeLB:nil];
    [self setCountLB:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    [headerView release];
    [table release];
    [avatarImageV release];
    [twitterNameLB release];
    [contentTF release];
    [contentImageV release];
    [retwitterMainV release];
    [retwitterTF release];
    [retwitterImageV release];
    [timeLB release];
    [countLB release];
    [super dealloc];
}
@end
