//
//  LPFriendCell.m
//  HHuan
//
//  Created by yonghongchen on 11-11-17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "LPFriendCell.h"

@implementation LPFriendCell
@synthesize invitationBtn;
@synthesize nameLabel;
@synthesize headerView;
@synthesize lidStr;
@synthesize type;
@synthesize cellBG;
@synthesize delegate = _delegate;
@synthesize lpCellIndexPath = _lpCellIndexPath;

- (IBAction)cellButtonClicked:(id)sender 
{
    [_delegate lpCellDidClicked:self];
}

- (void)dealloc
{
    self.lpCellIndexPath = nil;
    self.invitationBtn = nil;
    self.nameLabel = nil;
    self.headerView = nil;
    self.lidStr = nil;
    self.type = nil;
    self.cellBG = nil;
    [super dealloc];
}
@end
