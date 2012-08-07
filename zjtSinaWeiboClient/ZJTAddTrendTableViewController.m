//
//  ZJTAddTrendTableViewController.m
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-7-11.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import "ZJTAddTrendTableViewController.h"

@interface ZJTAddTrendTableViewController ()

@end

@implementation ZJTAddTrendTableViewController
@synthesize searchBar = _searchBar;
@synthesize table = _table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _recentRecordsArr = [[NSUserDefaults standardUserDefaults] objectForKey:TRENDS_STORED_RECORDS_ARRAY];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [self setTable:nil];
    [super viewDidUnload];
}

-(void)storeTheRecords
{
    if (_recentRecordsArr) {
        [[NSUserDefaults standardUserDefaults] setObject:_recentRecordsArr forKey:TRENDS_STORED_RECORDS_ARRAY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self storeTheRecords];
}

- (void)dealloc {
    [_searchBar release];
    [_table release];
    [super dealloc];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
    }
}


@end
