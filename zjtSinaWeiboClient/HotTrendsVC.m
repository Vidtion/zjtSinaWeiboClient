//
//  HotTrendsVC.m
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-6-26.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import "HotTrendsVC.h"
#import "WeiBoMessageManager.h"
#import "HotTrendsDetailTableVC.h"

@interface HotTrendsVC ()

@end

@implementation HotTrendsVC
@synthesize dataSourceArr = _dataSourceArr;
@synthesize delegate = _delegate;
@synthesize isUserTopics = _isUserTopics;

-(void)dealloc
{
    self.dataSourceArr = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"今日热门话题";
    }
    return self;
}

-(id)initWithDataSourceArr:(NSArray*)arr stylee:(UITableViewStyle)style
{
    self = [self initWithStyle:style];
    if (self) {
        self.dataSourceArr = arr;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_dataSourceArr == nil || _dataSourceArr.count == 0) {
        [[WeiBoMessageManager getInstance]getHOtTrendsDaily];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetHotTrend:) name:MMSinaGotHotCommentDaily object:nil];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MMSinaGotHotCommentDaily object:nil];
    [super viewDidUnload];  
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)didGetHotTrend:(NSNotification*)sender
{
    self.dataSourceArr = sender.object;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSString *name;
    if (_isUserTopics) {
        name = [[_dataSourceArr objectAtIndex:indexPath.row] objectForKey:@"hotword"];
    }
    else {
        name = [[_dataSourceArr objectAtIndex:indexPath.row] objectForKey:@"name"];
    }
    if (name && name.length != 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"#%@#",name];
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isForPost) {
        if ([_delegate respondsToSelector:@selector(hotTrendTableCellDidClicked:title:)]) {
            NSString *title = [[_dataSourceArr objectAtIndex:indexPath.row] objectForKey:@"name"];
            [_delegate hotTrendTableCellDidClicked:indexPath title:title];
        }
        return;
    }
    
    HotTrendsDetailTableVC *hotVC = [[HotTrendsDetailTableVC alloc] initWithNibName:@"FirstViewController" bundle:nil];
    if (_isUserTopics) {
        hotVC.qureyString = [[_dataSourceArr objectAtIndex:indexPath.row] objectForKey:@"hotword"];
    }
    else {
        hotVC.qureyString = [[_dataSourceArr objectAtIndex:indexPath.row] objectForKey:@"name"];
    }
    [self.navigationController pushViewController:hotVC animated:YES];
    [hotVC release];
}

@end
