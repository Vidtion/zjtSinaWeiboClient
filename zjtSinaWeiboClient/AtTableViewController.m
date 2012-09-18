//
//  AtTableViewController.m
//  zjtSinaWeiboClient
//
//  Created by Zhu Jianting on 12-8-7.
//  Copyright (c) 2012年 WS. All rights reserved.
//

#import "AtTableViewController.h"
#import "User.h"
#import "WeiBoMessageManager.h"
#import "HHNetDataCacheManager.h"
#import "SHKActivityIndicator.h"
#import "ZJTHelpler.h"

@interface AtTableViewController ()

@end

@implementation AtTableViewController
@synthesize userArr = _userArr;
@synthesize followerCellNib = _followerCellNib;
@synthesize user = _user;
@synthesize delegate = _delegate;
@synthesize searchBar = _searchBar;
@synthesize searchDisplayCtrl = _searchDisplayCtrl;
@synthesize filteredUserArr = _filteredUserArr;

-(void)dealloc
{
    self.filteredUserArr = nil;
    self.user = nil;
    self.userArr = nil;
    self.followerCellNib = nil;
    self.searchBar = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"@列表";
        _manager = [WeiBoMessageManager getInstance];
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
        _searchBar.showsCancelButton = YES;
//        _searchBar.show
        
        _searchDisplayCtrl = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
        _searchDisplayCtrl.delegate = self;
        _searchDisplayCtrl.searchResultsDelegate = self;
        _searchDisplayCtrl.searchResultsDataSource = self;
        _searchDisplayCtrl.searchBar.showsScopeBar = NO;
    }
    return self;
}

-(UINib*)followerCellNib
{
    if (_followerCellNib == nil) 
    {
        self.followerCellNib = [LPFriendCell nib];
    }
    return _followerCellNib;
}

- (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib {
    NSString *cellID = NSStringFromClass([LPFriendCell class]);
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
        cell = [nibObjects objectAtIndex:0];
        LPFriendCell *lpCell = (LPFriendCell*)cell;
        lpCell.invitationBtn.hidden = YES;
    }
    else {
        [(LPBaseCell *)cell reset];
    }
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableHeaderView = _searchBar;
    [self loadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter];
    [notifCenter addObserver:self selector:@selector(gotFollowUserList:) name:MMSinaGotFollowingUserList object:nil];
    [notifCenter addObserver:self selector:@selector(gotAvatar:) name:HHNetDataCacheNotification object:nil];
    [notifCenter addObserver:self selector:@selector(mmRequestFailed:) name:MMSinaRequestFailed object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)loadData
{
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    
    [_manager getFollowingUserList:[userID longLongValue] count:50 cursor:0];
    if (self.userArr == nil) {
        [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..."];
    }
}

-(void)refreshVisibleCellsImages
{
    NSArray *cellArr = [self.tableView visibleCells];
    for (LPFriendCell *cell in cellArr) {
        NSIndexPath *inPath = [self.tableView indexPathForCell:cell];
        if (!cell.headerView.image) {
            User *user = [_userArr objectAtIndex:inPath.row];
            if (!user.avatarImage || [user.avatarImage isEqual:[NSNull null]])
            {
                [[HHNetDataCacheManager getInstance] getDataWithURL:user.profileImageUrl withIndex:inPath.row];
            }
            else {
                cell.headerView.image = user.avatarImage;
            }
        }
    }
}

-(void)gotFollowUserList:(NSNotification*)sender
{
    NSDictionary *dic = sender.object;
    NSArray *arr = [dic objectForKey:@"userArr"];
    User *tempUser = [arr lastObject];
    User *lastUser = [_userArr lastObject];
    if (![tempUser.screenName isEqualToString:lastUser.screenName]) {
        self.userArr = arr;
        [self.tableView reloadData];
    }
    else {
        
    }
//    [self stopLoading];
    [[SHKActivityIndicator currentIndicator] hide];
    
    [self refreshVisibleCellsImages];
}

-(void)gotAvatar:(NSNotification*)sender
{    
    NSDictionary * dic = sender.object;
    NSString * url          = [dic objectForKey:HHNetDataCacheURLKey];
    NSNumber *indexNumber   = [dic objectForKey:HHNetDataCacheIndex];
    NSInteger index         = [indexNumber intValue];
    NSData *data            = [dic objectForKey:HHNetDataCacheData];
    
    if (indexNumber == nil || index == -1) {
        return;
    }
    
    if (index >= [_userArr count]) {
        return;
    }
    
    User *user = [_userArr objectAtIndex:index];
    
    //得到的是头像图片
    if ([url isEqualToString:user.profileImageUrl]) 
    {
        UIImage * image     = [UIImage imageWithData:data];
        user.avatarImage    = image;
        
        LPFriendCell *cell = (LPFriendCell*)[self.tableView cellForRowAtIndexPath:user.cellIndexPath];
        if (!cell.headerView.image) {
            cell.headerView.image = user.avatarImage;
        }
    }
}

-(void)mmRequestFailed:(id)sender
{
//    [self stopLoading];
    [[SHKActivityIndicator currentIndicator] hide];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return _filteredUserArr.count;
    }
    else {
        return [_userArr count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    User *user = nil;
    LPFriendCell *cell = [self cellForTableView:self.tableView fromNib:self.followerCellNib];
    cell.lpCellIndexPath = indexPath;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        if (row >= [_filteredUserArr count]) {
            return cell;
        }
    }
    else {
        if (row >= [_userArr count]) {
            return cell;
        }
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        user = [_filteredUserArr objectAtIndex:row];
    }
    else {
        user = [_userArr objectAtIndex:row];
    }
    
    cell.nameLabel.text = user.screenName;
    user.cellIndexPath = indexPath;
    
    if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
    {
        if (!user.avatarImage || [user.avatarImage isEqual:[NSNull null]]) {
            [[HHNetDataCacheManager getInstance] getDataWithURL:user.profileImageUrl withIndex:row];
        }
    }
    
    cell.headerView.image = user.avatarImage;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *user = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        user = [_filteredUserArr objectAtIndex:indexPath.row];
    }
    else {
        user = [_userArr objectAtIndex:indexPath.row];
    }
    
    if ([_delegate respondsToSelector:@selector(atTableViewControllerCellDidClickedWithScreenName:)]) {
        [_delegate atTableViewControllerCellDidClickedWithScreenName:user.screenName];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self refreshVisibleCellsImages];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self refreshVisibleCellsImages];
    }
}


- (void)filterContentForSearchText:(NSString *)keyWords
{
	NSString * regString = [ZJTHelpler regularStringFromSearchString:[keyWords uppercaseString]];
    NSArray *resultArr = nil;
    resultArr = [[_userArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"screenName contains[cd] %@ OR pinyin MATCHES %@", keyWords, regString]] retain];
    self.filteredUserArr = [NSMutableArray arrayWithArray:resultArr];
    [resultArr release];
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

@end
