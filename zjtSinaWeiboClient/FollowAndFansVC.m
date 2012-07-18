//
//  FollowAndFansVC.m
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-7-2.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import "FollowAndFansVC.h"
#import "User.h"
#import "ProfileVC.h"
#import "WeiBoMessageManager.h"
#import "LPFriendCell.h"
#import "HHNetDataCacheManager.h"
#import "SHKActivityIndicator.h"
#import "ZJTProfileViewController.h"

enum{
    kFollowIndex = 0,
    kFansIndex,
};

@interface FollowAndFansVC ()

@end

@implementation FollowAndFansVC
@synthesize followTable = _followTable;
@synthesize fansTable = _fansTable;
@synthesize followerCellNib = _followerCellNib;
@synthesize user = _user;
@synthesize followUserArr = _followUserArr;
@synthesize fansUserArr = _fansUserArr;
@synthesize segmentCtrol = _segmentCtrol;

-(void)dealloc
{
    self.fansUserArr = nil;
    self.segmentCtrol = nil;
    self.followUserArr = nil;
    self.followerCellNib = nil;
    self.user = nil;
    self.followTable = nil;
    self.fansTable = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"粉丝列表";
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        _manager = [WeiBoMessageManager getInstance];
        _followCursor = 0;
        _fansCursor = 0;
    }
    return self;
}

- (void) segmentAction 
{
    if (_segmentCtrol.selectedSegmentIndex == kFollowIndex) {
        _followTable.hidden = NO;
        [self loadDataWithCursor:_followCursor];
    }
    else if (_segmentCtrol.selectedSegmentIndex == kFansIndex) {
        _followTable.hidden = YES;
        [self loadDataWithCursor:_fansCursor];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_segmentCtrol == nil) {
        _segmentCtrol = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"关注", @"粉丝", nil]];
        _segmentCtrol.frame = CGRectMake(0.0, 0.0, 200.0, 30.0);
        [_segmentCtrol addTarget:self action:@selector(segmentAction) forControlEvents:UIControlEventValueChanged];
        _segmentCtrol.segmentedControlStyle = UISegmentedControlStyleBar; 
        
        self.navigationItem.titleView = _segmentCtrol;
        _segmentCtrol.selectedSegmentIndex = kFollowIndex;
        self.navigationItem.title = @"关注";
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter];
    [notifCenter addObserver:self selector:@selector(gotFollowUserList:) name:MMSinaGotFollowingUserList object:nil];
    [notifCenter addObserver:self selector:@selector(gotFansUserList:) name:MMSinaGotFollowedUserList object:nil];
    [notifCenter addObserver:self selector:@selector(gotAvatar:) name:HHNetDataCacheNotification object:nil];
    [notifCenter addObserver:self selector:@selector(gotFollowResult:) name:MMSinaFollowedByUserIDWithResult object:nil];
    [notifCenter addObserver:self selector:@selector(gotUnfollowResult:) name:MMSinaUnfollowedByUserIDWithResult object:nil];
    [notifCenter addObserver:self selector:@selector(mmRequestFailed:) name:MMSinaRequestFailed object:nil];
    _fansCursor = 0;
    _followCursor = 0;
    [self loadDataWithCursor:0];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
        cell = [nibObjects objectAtIndex:0];
    }
    else {
        [(LPBaseCell *)cell reset];
    }
    
    return cell;
}

-(void)refreshVisibleCellsImages:(UITableView*)tableView
{
    NSArray *cellArr = [tableView visibleCells];
    for (LPFriendCell *cell in cellArr) {
        NSIndexPath *inPath = [tableView indexPathForCell:cell];
        if ([tableView isEqual:_fansTable]) {
            if (inPath.row == [_fansUserArr count]) {
                continue;
            }
        }
        else {
            if (inPath.row == [_followUserArr count]) {
                continue;
            }
        }
        if (!cell.headerView.image) {
            User *user = nil;
            if ([tableView isEqual:_fansTable]) {
                user = [_fansUserArr objectAtIndex:inPath.row];
            }
            else {
                user = [_followUserArr objectAtIndex:inPath.row];
            }
            
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

-(void)loadDataWithCursor:(int)cursor
{
    NSString *userID = nil;
    if (_user) {
        userID = [NSString stringWithFormat:@"%lld",_user.userId];
    }
    else {
        userID = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    }
    if (_followTable.hidden == NO) {
        [_manager getFollowingUserList:[userID longLongValue] count:50 cursor:cursor];
    }
    else {
        [_manager getFollowedUserList:[userID longLongValue] count:50 cursor:cursor];
    }
}

-(void)gotFollowUserList:(NSNotification*)sender
{
    NSDictionary *dic = sender.object;
    NSArray *arr = [dic objectForKey:@"userArr"];
    NSNumber *cursor = [dic objectForKey:@"cursor"];
    User *tempUser = [arr lastObject];
    User *lastUser = [_followUserArr lastObject];
    
    UITableViewCell *lastCell = [_followTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[_followUserArr count] inSection:0]];
    lastCell.textLabel.text = @"点击载入更多...";
    
    if (![tempUser.screenName isEqualToString:lastUser.screenName]) {
        if (_followUserArr == nil || _followUserArr.count == 0 || _followCursor == 0) {
            self.followUserArr = [NSMutableArray arrayWithArray:arr];
        }
        else {
            [_followUserArr addObjectsFromArray:arr];
        }
        _followCursor = cursor.intValue;
        [self.followTable reloadData];
    }
    else {
        
    }
//    [self stopLoading];
    [[SHKActivityIndicator currentIndicator] hide];
    
    [self refreshVisibleCellsImages:_followTable];
    
    //    [[ZJTStatusBarAlertWindow getInstance] hide];
}

-(void)gotFansUserList:(NSNotification*)sender
{
    NSDictionary *dic = sender.object;
    NSArray *arr = [dic objectForKey:@"userArr"];
    NSNumber *cursor = [dic objectForKey:@"cursor"];
    User *tempUser = [arr lastObject];
    User *lastUser = [_fansUserArr lastObject];
    
    UITableViewCell *lastCell = [_fansTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[_fansUserArr count] inSection:0]];
    lastCell.textLabel.text = @"点击载入更多...";
    
    if (![tempUser.screenName isEqualToString:lastUser.screenName]) {
        if (_fansUserArr == nil || _fansUserArr.count == 0 || _fansCursor == 0) {
            self.fansUserArr = [NSMutableArray arrayWithArray:arr];
        }
        else {
            [_fansUserArr addObjectsFromArray:arr];
        }
        _fansCursor = cursor.intValue;
        [self.fansTable reloadData];
    }
    else {
        
    }
    //    [self stopLoading];
    [[SHKActivityIndicator currentIndicator] hide];
    
    [self refreshVisibleCellsImages:_fansTable];
    
    //    [[ZJTStatusBarAlertWindow getInstance] hide];
}

-(void)setCellStatus:(NSString*)uid tableName:(NSString*)tableName title:(NSString*)title
{
    if ([@"fansTable" isEqualToString:tableName]) {
        for (int i = 0;i<[_fansUserArr count];i++) {
            User *user = [_fansUserArr objectAtIndex:i];
            
            if (user.userId == [uid longLongValue]) 
            {
                user.following = YES;
                LPFriendCell *cell = (LPFriendCell *)[_fansTable cellForRowAtIndexPath:user.cellIndexPath];
                [cell.invitationBtn setTitle:title forState:UIControlStateNormal];
            }
        }
    }
    
    if ([@"followTable" isEqualToString:tableName]) {
        for (int i = 0;i<[_followUserArr count];i++) {
            User *user = [_followUserArr objectAtIndex:i];
            
            if (user.userId == [uid longLongValue]) 
            {
                user.following = YES;
                LPFriendCell *cell = (LPFriendCell *)[_followTable cellForRowAtIndexPath:user.cellIndexPath];
                [cell.invitationBtn setTitle:title forState:UIControlStateNormal];
            }
        }
    }
}

-(void)gotFollowResult:(NSNotification*)sender
{
    NSLog(@"sender.objet = %@",sender.object);
    NSDictionary *dic = sender.object;
    NSString *uid = [dic objectForKey:@"uid"];
    NSString *tableName = [dic  objectForKey:@"tableName"];
    NSLog(@"dic = %@",dic);
    if (uid == nil) {
        return;
    }
    
    [self setCellStatus:uid tableName:tableName title:@"取消关注"];
}

-(void)gotUnfollowResult:(NSNotification*)sender
{
    NSLog(@"sender.objet = %@",sender.object);
    NSDictionary *dic = sender.object;
    NSString *uid = [dic objectForKey:@"uid"];
    NSString *tableName = [dic  objectForKey:@"tableName"];
    if (uid == nil) {
        return;
    }
    
    [self setCellStatus:uid tableName:tableName title:@"关注"];
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
    
    if (_segmentCtrol.selectedSegmentIndex == kFansIndex) {
        if (index < [_fansUserArr count]) {
            User *user = [_fansUserArr objectAtIndex:index];
            
            //得到的是头像图片
            if ([url isEqualToString:user.profileImageUrl]) 
            {
                UIImage * image     = [UIImage imageWithData:data];
                user.avatarImage    = image;
                
                LPFriendCell *cell = (LPFriendCell*)[_fansTable cellForRowAtIndexPath:user.cellIndexPath];
                if (!cell.headerView.image) {
                    cell.headerView.image = user.avatarImage;
                }
            }
        } 
    }
    else {
        if (index < [_followUserArr count]) {
            User *user = [_followUserArr objectAtIndex:index];
            
            //得到的是头像图片
            if ([url isEqualToString:user.profileImageUrl]) 
            {
                UIImage * image     = [UIImage imageWithData:data];
                user.avatarImage    = image;
                
                LPFriendCell *cell = (LPFriendCell*)[_followTable cellForRowAtIndexPath:user.cellIndexPath];
                if (!cell.headerView.image) {
                    cell.headerView.image = user.avatarImage;
                }
            }
        }
    }
}

-(void)mmRequestFailed:(id)sender
{
//    [self stopLoading];
    [[SHKActivityIndicator currentIndicator] hide];
    //    [[ZJTStatusBarAlertWindow getInstance] hide];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_fansTable]) {
        return [_fansUserArr count] + 1;
    }
    else if ([tableView isEqual:_followTable]) {
        return [_followUserArr count] + 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    UITableView *tempTable = nil;
    NSArray *tempArr = nil;
    
    if ([tableView isEqual:_followTable])
    {
        tempTable = _followTable;
        tempArr = _followUserArr;
    }
    else {
        tempTable = _fansTable;
        tempArr = _fansUserArr;
    }
    
    //last cell
    if (row == [tempArr count]) {
        UITableViewCell *lastCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        lastCell.selectionStyle = UITableViewCellSelectionStyleNone;
        lastCell.textLabel.font = [UIFont systemFontOfSize:14];
        lastCell.textLabel.textColor = [UIColor darkGrayColor];
        lastCell.textLabel.textAlignment = UITextAlignmentCenter;
        
        if (row == 0)
            lastCell.textLabel.text = @"正在载入...";
        else
            lastCell.textLabel.text = @"点击载入更多...";
        return lastCell;
    }
    
    LPFriendCell *cell = [self cellForTableView:tempTable fromNib:self.followerCellNib];
    cell.lpCellIndexPath = indexPath;
    cell.delegate = self;
    
    if (row >= [tempArr count] + 1) {
        return cell;
    }
    
    User *user = [tempArr objectAtIndex:row];
    cell.nameLabel.text = user.screenName;
    user.cellIndexPath = indexPath;
    
    if (tempTable.dragging == NO && tempTable.decelerating == NO)
    {
        if (!user.avatarImage || [user.avatarImage isEqual:[NSNull null]]) {
            [[HHNetDataCacheManager getInstance] getDataWithURL:user.profileImageUrl withIndex:row];
        }
    }
    
    cell.headerView.image = user.avatarImage;
    
    if (user.following == NO) {
        [cell.invitationBtn setTitle:@"关注" forState:UIControlStateNormal];
    }
    else {
        [cell.invitationBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    UITableView *tempTable = nil;
    NSArray *tempArr = nil;
    
    if ([tableView isEqual:_followTable])
    {
        tempTable = _followTable;
        tempArr = _followUserArr;
    }
    else {
        tempTable = _fansTable;
        tempArr = _fansUserArr;
    }
    
    //last cell
    if (row == [tempArr count]) {
        //load more
        NSLog(@"load more");
        UITableViewCell *cell = [tempTable cellForRowAtIndexPath:indexPath];
        cell.textLabel.text = @"正在载入...";
        return;
    }
    
    User *user = nil;
    user = [tempArr objectAtIndex:row];
    
    ZJTProfileViewController *profile = [[ZJTProfileViewController alloc]initWithNibName:@"ZJTProfileViewController" bundle:nil];
    profile.user = user;
    profile.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:profile animated:YES];
    [profile release];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_segmentCtrol.selectedSegmentIndex == kFansIndex) {
        [self refreshVisibleCellsImages:_fansTable];
    }
    else {
        [self refreshVisibleCellsImages:_followTable];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        if (_segmentCtrol.selectedSegmentIndex == kFansIndex) {
            [self refreshVisibleCellsImages:_fansTable];
        }
        else {
            [self refreshVisibleCellsImages:_followTable];
        }
    }
}

-(void)lpCellDidClicked:(LPFriendCell*)cell
{
    NSInteger index = cell.lpCellIndexPath.row;
    if ([_fansTable indexPathForCell:cell]) {
        if (index > [_fansUserArr count]) {
            return;
        }
        User *user = [_fansUserArr objectAtIndex:index];
        
        if (user.following) {
            [_manager unfollowByUserID:user.userId inTableView:@"fansTable"];
        }
        else {
            [_manager followByUserID:user.userId inTableView:@"fansTable"];
        }
    }
    else if ([_followTable indexPathForCell:cell]) {
        if (index > [_followUserArr count]) {
            return;
        }
        User *user = [_followUserArr objectAtIndex:index];
        
        if (user.following) {
            [_manager unfollowByUserID:user.userId inTableView:@"followTable"];
        }
        else {
            [_manager followByUserID:user.userId inTableView:@"followTable"];
        }
    }
}

@end
