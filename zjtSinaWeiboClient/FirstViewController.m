//
//  FirstViewController.m
//  zjtSinaWeiboClient
//
//  Created by jtone z on 11-11-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "WeiBoMessageManager.h"
#import "StatusCell.h"
#import "Status.h"
#import "User.h"
#import "OAuthWebView.h"
#import "ASIHTTPRequest.h"
#import "HHNetDataCacheManager.h"

#define kTextViewPadding            16.0
#define kLineBreakMode              UILineBreakModeWordWrap

@implementation FirstViewController
@synthesize table;
@synthesize userID;
@synthesize statusCellNib;
@synthesize statuesArr;
@synthesize headDictionary;
@synthesize httpRequestList;

-(void)dealloc
{
    if (httpRequestList != nil) {
        for (id item in httpRequestList) {
            [item setDelegate:nil];
            [item cancel];
        }
        [httpRequestList release];
        httpRequestList = nil;
    }
    self.headDictionary = nil;
    self.statusCellNib = nil;
    self.statuesArr = nil;
    self.userID = nil;
    [table release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

-(UINib*)statusCellNib
{
    if (statusCellNib == nil) {
        self.statusCellNib = [StatusCell nib];
    }
    return statusCellNib;
}
							
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    shouldLoad = NO;
    shouldLoadAvatar = NO;
    manager = [WeiBoMessageManager getInstance];
    if (headDictionary == nil) {
        headDictionary = [[NSMutableDictionary alloc] initWithCapacity:100];
    }
    if (httpRequestList == nil) {
        httpRequestList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    //如果未授权，则调入授权页面。
    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    if (authToken == nil) {
        shouldLoad = YES;
        OAuthWebView *webV = [[OAuthWebView alloc]initWithNibName:@"OAuthWebView" bundle:nil];
        [self presentModalViewController:webV animated:NO];
        [webV release];
    }
    else
    {
        [manager getUserID];
        [manager getHomeLine:-1 maxID:-1 count:-1 page:-1 baseApp:-1 feature:-1];
    }
}

- (void)viewWillAppear:(BOOL)animated 
{
    if (shouldLoad) {
        shouldLoad = NO;
        [manager getUserID];
        [manager getHomeLine:-1 maxID:-1 count:-1 page:-1 baseApp:-1 feature:-1];
    }
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetUserID:) name:MMSinaGotUserID object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetHomeLine:) name:MMSinaGotHomeLine object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAvatar:) name:HHNetDataCacheNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MMSinaGotUserID object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MMSinaGotHomeLine object:nil];
}

- (void)viewDidUnload {
    [self setTable:nil];
    [super viewDidUnload];
}

#pragma mark - Methods
-(void)getAvatar:(NSNotification*)sender
{
    NSDictionary * dic = sender.object;
    NSString * url=[dic objectForKey:HHNetDataCacheURLKey];
    NSNumber *indexNumber = [dic objectForKey:HHNetDataCacheIndex];
    NSInteger index = [indexNumber intValue];
    
    Status *sts = [statuesArr objectAtIndex:index];
    User *user = sts.user;
    if ([url isEqualToString:user.profileImageUrl]) {
        UIImage * image     = [UIImage imageWithData:[dic objectForKey:HHNetDataCacheData]];
        user.avatarImage    = image;
        
        [headDictionary setObject:[dic objectForKey:HHNetDataCacheData] forKey:indexNumber];
        
        NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:index inSection:0];
        NSArray     *arr        = [NSArray arrayWithObject:indexPath];
        [table reloadRowsAtIndexPaths:arr withRowAnimation:NO];
    }
}

-(void)didGetUserID:(NSNotification*)sender
{
    self.userID = sender.object;
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:USER_STORE_USER_ID];
}

-(void)didGetHomeLine:(NSNotification*)sender
{
    shouldLoadAvatar = YES;
    self.statuesArr = sender.object;
    [table reloadData];
    for(int i=0;i<[statuesArr count];i++){
        Status * member=[statuesArr objectAtIndex:i];
        [[HHNetDataCacheManager getInstance] getDataWithURL:member.user.profileImageUrl withIndex:i];
    }
}

-(CGFloat)cellHeight:(NSString*)contentText
{
    UIFont * font=[UIFont  systemFontOfSize:14];
    CGSize size=[contentText sizeWithFont:font constrainedToSize:CGSizeMake(320.0f-kTextViewPadding, 300000.0f) lineBreakMode:kLineBreakMode];
    CGFloat height = size.height + 44;
    return height;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [statuesArr count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger  row = indexPath.row;
    StatusCell *cell = [StatusCell cellForTableView:table fromNib:self.statusCellNib];
    
    Status *status = [statuesArr objectAtIndex:row];
    cell.contentTF.text = status.text;
    [cell getTFHeight];
    cell.userNameLB.text = status.user.screenName;
    
    NSData *data = [headDictionary objectForKey:[NSNumber numberWithInt:[indexPath row]]];
    cell.avatarImage.image = [UIImage imageWithData:data];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
{
    NSInteger  row = indexPath.row;
    Status *status = [statuesArr objectAtIndex:row];
    
    return [self cellHeight:status.text];
}

@end
