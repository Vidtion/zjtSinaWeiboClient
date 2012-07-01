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

@interface FollowAndFansVC ()

@end

@implementation FollowAndFansVC
@synthesize followTable = _followTable;
@synthesize fansTable = _fansTable;
@synthesize followerCellNib = _followerCellNib;
@synthesize user = _user;
@synthesize followUserArr = _followUserArr;
@synthesize fansUserArr = _fansUserArr;

-(void)dealloc
{
    self.fansUserArr = nil;
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

-(void)gotFollowUserList:(NSNotification*)sender
{
    NSArray *arr = sender.object;
    User *tempUser = [arr lastObject];
    User *lastUser = [_followUserArr lastObject];
    if (![tempUser.screenName isEqualToString:lastUser.screenName]) {
        self.followUserArr = arr;
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
    NSArray *arr = sender.object;
    User *tempUser = [arr lastObject];
    User *lastUser = [_fansUserArr lastObject];
    if (![tempUser.screenName isEqualToString:lastUser.screenName]) {
        self.fansUserArr = arr;
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
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
