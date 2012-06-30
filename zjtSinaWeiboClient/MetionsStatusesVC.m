//
//  MetionsStatusesVC.m
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-6-21.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import "MetionsStatusesVC.h"

@interface MetionsStatusesVC ()

@end

@implementation MetionsStatusesVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"@我";
    [defaultNotifCenter addObserver:self selector:@selector(didGetMetionsStatus:)    name:MMSinaGotMetionsStatuses   object:nil];
    
}

- (void)viewDidUnload
{
    [defaultNotifCenter removeObserver:self name:MMSinaGotMetionsStatuses object:nil];
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated
{
    if (self.statuesArr != nil) {
        return;
    }
    
    [manager getMetionsStatuses];
    
    [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view]; 
//    [[ZJTStatusBarAlertWindow getInstance] showWithString:@"正在载入，请稍后..."];
}

-(void)didGetMetionsStatus:(NSNotification*)sender
{    
    [self stopLoading];
    [self doneLoadingTableViewData];
    
    [statuesArr removeAllObjects];
    self.statuesArr = sender.object;
    [self.tableView reloadData];
    [[SHKActivityIndicator currentIndicator] hide];
//    [[ZJTStatusBarAlertWindow getInstance] hide];
    [self refreshVisibleCellsImages];
}

@end
