//
//  ZJTHotRepostViewController.m
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-5-9.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import "ZJTHotRepostViewController.h"

@interface ZJTHotRepostViewController ()

@end

@implementation ZJTHotRepostViewController
@synthesize type = _type;

-(id)initWithType:(VCType)type
{
    self = [super initWithNibName:@"FirstViewController" bundle:nil];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _refreshHeaderView.hidden = YES;
    refreshArrow.image = nil;
    refreshArrow.hidden = YES;
    refreshLabel.hidden = YES;
    refreshSpinner.hidden = YES;
    
    if (_type == kHotRepostDaily) {
        self.title = @"今日热门转发";
        [defaultNotifCenter addObserver:self selector:@selector(didGetHotStatus:)    name:MMSinaGotHotRepostDaily   object:nil];
    }
    
    else if (_type == kHotRepostWeekly) {
        
    }
    
    else if (_type == kHotCommentDaily) {
        self.title = @"今日热门评论";
        [defaultNotifCenter addObserver:self selector:@selector(didGetHotStatus:)    name:MMSinaGotHotCommentDaily   object:nil];
    }
    
    else if (_type == kHotCommentWeekly) {
        
    }

}

- (void)viewDidUnload
{
    if (_type == kHotRepostDaily) {
        [defaultNotifCenter removeObserver:self name:MMSinaGotHotRepostDaily object:nil];
    }
    
    else if (_type == kHotRepostWeekly) {
        
    }
    
    else if (_type == kHotCommentDaily) {
        [defaultNotifCenter removeObserver:self name:MMSinaGotHotCommentDaily object:nil];
    }
    
    else if (_type == kHotCommentWeekly) {
        
    }
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated
{
    if (self.statuesArr != nil) {
        return;
    }
    if (_type == kHotRepostDaily) {
        [manager getHotRepostDaily:50];
    }
    
    else if (_type == kHotRepostWeekly) {
        
    }
    
    else if (_type == kHotCommentDaily) {
        [manager getHotCommnetDaily:50];
    }
    
    else if (_type == kHotCommentWeekly) {
        
    }
    
    [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view]; 
//    [[ZJTStatusBarAlertWindow getInstance] showWithString:@"正在载入，请稍后..."];
}

-(void)didGetHotStatus:(NSNotification*)sender
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self refreshVisibleCellsImages];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //    [self refreshVisibleCellsImages];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate)
	{
        [self refreshVisibleCellsImages];
    }
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return NO;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return nil;
}

@end
