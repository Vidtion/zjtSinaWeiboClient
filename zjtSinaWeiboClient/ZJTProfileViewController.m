//
//  ZJTProfileViewController.m
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-7-14.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import "ZJTProfileViewController.h"
#import "HHNetDataCacheManager.h"
#import "FollowerVC.h"
#import "ProfileVC.h"
#import "WeiBoMessageManager.h"
#import "ZJTHelpler.h"
#import "HotTrendsVC.h"

#define kLineBreakMode              UILineBreakModeWordWrap

enum {
    kSinaVerifiedRow = 0,
    kLocationRow,
    kSelfDescriptionRow,
    kDescriptionRowsCount,
};

@interface ZJTProfileViewController ()
-(void)updateWithUser:(User*)theUser;
@end

@implementation ZJTProfileViewController
@synthesize table;
@synthesize avatarImageView;
@synthesize genderImageView;
@synthesize nameLabel;
@synthesize followButton;
@synthesize vipImageView;
@synthesize fansButton;
@synthesize idolButton;
@synthesize weiboButton;
@synthesize topicButton;
@synthesize tableHeaderView;
@synthesize user;
@synthesize verifiedProfileCell;
@synthesize locationProfileCell;
@synthesize descriptionProfileCell;
@synthesize screenName;
@synthesize topicsArr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(screenName){
        [[WeiBoMessageManager getInstance] getUserInfoWithScreenName:self.screenName];
    }
    if ([self.title isEqualToString:@"我的微博"]) {
        self.user = [ZJTHelpler getInstance].user;
        followButton.hidden = YES;
    }
    if (self.user) {
        [[WeiBoMessageManager getInstance]getTopicsOfUser:self.user];
    }
    
    UIImage *normalImage = [UIImage imageNamed:@"details_edit_normal_btn.png"];
    UIImage *pressdImage = [UIImage imageNamed:@"details_edit_normal_pressed.png"];
    [fansButton setBackgroundImage:[normalImage stretchableImageWithLeftCapWidth:71 topCapHeight:16] forState:UIControlStateNormal];
    [fansButton setBackgroundImage:[pressdImage stretchableImageWithLeftCapWidth:71 topCapHeight:16]  forState:UIControlStateHighlighted];
    
    [idolButton setBackgroundImage:[normalImage stretchableImageWithLeftCapWidth:71 topCapHeight:16] forState:UIControlStateNormal];
    [idolButton setBackgroundImage:[pressdImage stretchableImageWithLeftCapWidth:71 topCapHeight:16]  forState:UIControlStateHighlighted];
    
    [weiboButton setBackgroundImage:[normalImage stretchableImageWithLeftCapWidth:71 topCapHeight:16] forState:UIControlStateNormal];
    [weiboButton setBackgroundImage:[pressdImage stretchableImageWithLeftCapWidth:71 topCapHeight:16]  forState:UIControlStateHighlighted];
    
    [topicButton setBackgroundImage:[normalImage stretchableImageWithLeftCapWidth:71 topCapHeight:16] forState:UIControlStateNormal];
    [topicButton setBackgroundImage:[pressdImage stretchableImageWithLeftCapWidth:71 topCapHeight:16]  forState:UIControlStateHighlighted];
    
    fansButton.titleLabel.numberOfLines = 2;
    idolButton.titleLabel.numberOfLines = 2;
    weiboButton.titleLabel.numberOfLines = 2;
    topicButton.titleLabel.numberOfLines = 2;
        
    [fansButton.titleLabel setTextAlignment:UITextAlignmentCenter];
    [idolButton.titleLabel setTextAlignment:UITextAlignmentCenter];
    [weiboButton.titleLabel setTextAlignment:UITextAlignmentCenter];
    [topicButton.titleLabel setTextAlignment:UITextAlignmentCenter];
    
    [self updateWithUser:user];
    [table setTableHeaderView:tableHeaderView];
}

-(void)updateWithUser:(User*)theUser
{
    if (!user) {
        return;
    }
    if (![self.title isEqualToString:@"我的微博"]) {
        self.title = user.screenName;
    }
    NSString *title = nil;
    title = [NSString stringWithFormat:@"%d\n粉丝",theUser.followersCount];
    [fansButton setTitle:title forState:UIControlStateNormal];
    
    title = [NSString stringWithFormat:@"%d\n关注",theUser.friendsCount];
    [idolButton setTitle:title forState:UIControlStateNormal];
    
    title = [NSString stringWithFormat:@"%d\n微博",theUser.statusesCount];
    [weiboButton setTitle:title forState:UIControlStateNormal];
    
    title = [NSString stringWithFormat:@"%d\n话题",theUser.topicCount];
    [topicButton setTitle:title forState:UIControlStateNormal];
    
    if (user.following) {
        [followButton setTitle:@"取消关注" forState:UIControlStateNormal];
    }
    else {
        [followButton setTitle:@"+加关注" forState:UIControlStateNormal];
    }
    vipImageView.hidden = !user.verified;
    
    if (user.gender == GenderMale) {
        genderImageView.image = [UIImage imageNamed:@"male.png"];
    }
    else if (user.gender == GenderFemale) {
        genderImageView.image = [UIImage imageNamed:@"female.png"];
    }
    else {
        genderImageView.image = nil;
    }
    
    nameLabel.text = user.screenName;
    CGSize size = [user.screenName sizeWithFont:nameLabel.font];
    
    CGRect frame =  nameLabel.frame;
    if (size.width>125) {
        size.width = 125;
    }
    frame.size = size;
    nameLabel.frame = frame;
    
    frame = genderImageView.frame;
    frame.origin.x = nameLabel.frame.origin.x + nameLabel.frame.size.width + 5;
    genderImageView.frame = frame;
    
    [[HHNetDataCacheManager getInstance] getDataWithURL:user.profileLargeImageUrl];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAvatar:) name:HHNetDataCacheNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetUserInfo:)    name:MMSinaGotUserInfo          object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetuserTopics:)    name:MMSinaGotUserTopics          object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFollowByUserIDWithResult:) name:MMSinaFollowedByUserIDWithResult object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUnfollowByUserIDWithResult:) name:MMSinaUnfollowedByUserIDWithResult object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setTable:nil];
    [self setAvatarImageView:nil];
    [self setGenderImageView:nil];
    [self setNameLabel:nil];
    [self setFollowButton:nil];
    [self setVipImageView:nil];
    [self setFansButton:nil];
    [self setIdolButton:nil];
    [self setWeiboButton:nil];
    [self setTopicButton:nil];
    [self setTableHeaderView:nil];
    [self setLocationProfileCell:nil];
    [self setDescriptionProfileCell:nil];
    [self setVerifiedProfileCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void)getAvatar:(NSNotification*)sender
{
    NSDictionary * dic  = sender.object;
    NSString * url      = [dic objectForKey:HHNetDataCacheURLKey];
    NSData *data        = [dic objectForKey:HHNetDataCacheData];
    UIImage * image     = [UIImage imageWithData:data];
    
    if (data == nil) {
        NSLog(@"data == nil");
    }
    
    //得到的是头像图片
    if ([url isEqualToString:user.profileLargeImageUrl]) 
    {
        user.avatarImage = image;
        self.avatarImageView.image = image;
    }
}

-(void)didGetUserInfo:(NSNotification*)sender
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    
    if (uid.longLongValue == user.userId) {
        User *theUser = sender.object;
        self.user = theUser;
        [self updateWithUser:user];
        [table reloadData];
    }
    
    if ([self.title isEqualToString:@"我的微博"]) {
        return;
    }
    User *theUser = sender.object;
    self.user = theUser;
    [self updateWithUser:user];
    [table reloadData];
    
    [[WeiBoMessageManager getInstance] getTopicsOfUser:self.user];
}

-(void)didGetuserTopics:(NSNotification*)sender
{
    NSArray *arr = sender.object;
    if ([arr isKindOfClass:[NSArray class]]) {
        self.topicsArr = arr;
        user.topicCount = arr.count;
        [self updateWithUser:user];
    }
}

-(void)didUnfollowByUserIDWithResult:(NSNotification*)sender
{
    NSLog(@"sender.objet = %@",sender.object);
    NSDictionary *dic = sender.object;
    NSString *uid = [dic objectForKey:@"uid"];
    if (uid == nil) {
        return;
    }
    [followButton setTitle:@"+加关注" forState:UIControlStateNormal];
}

-(void)didFollowByUserIDWithResult:(NSNotification*)sender
{
    NSLog(@"sender.objet = %@",sender.object);
    NSDictionary *dic = sender.object;
    NSString *uid = [dic objectForKey:@"uid"];
    NSLog(@"dic = %@",dic);
    if (uid == nil) {
        return;
    }
    [followButton setTitle:@"取消关注" forState:UIControlStateNormal];
}

- (IBAction)followButtonClicked:(id)sender {
    UIButton *button = (UIButton*)sender;
    if ([button.titleLabel.text isEqualToString:@"取消关注"]) {
        [[WeiBoMessageManager getInstance] unfollowByUserID:self.user.userId inTableView:@""];
    }
    else if([button.titleLabel.text isEqualToString:@"+加关注"]){
        [[WeiBoMessageManager getInstance] followByUserID:self.user.userId inTableView:@""];
    }
}

-(IBAction)gotoUsersStatusesView:(id)sender
{
    ProfileVC *profile = [[ProfileVC alloc]initWithNibName:@"ProfileVC" bundle:nil];
    profile.userID = [NSString stringWithFormat:@"%lld",user.userId];
    profile.user = user;
    profile.avatarImage = user.avatarImage;
    profile.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:profile animated:YES];
    [profile release];
}

- (IBAction)gotoFollowedVC:(id)sender {
    FollowerVC  *followerVC     = [[FollowerVC alloc]initWithNibName:@"FollowerVC" bundle:nil];
    followerVC.title = [NSString stringWithFormat:@"%@的粉丝",user.screenName];
    followerVC.user = user;
    followerVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:followerVC animated:YES];
    [followerVC release];
}

- (IBAction)gotoFollowingVC:(id)sender 
{
    
    FollowerVC *followingVC    = [[FollowerVC alloc] initWithNibName:@"FollowerVC" bundle:nil];
    
    followingVC.title = [NSString stringWithFormat:@"%@的关注",user.screenName];
    followingVC.isFollowingViewController = YES;
    followingVC.user = user;
    followingVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:followingVC animated:YES];
    [followingVC release];
}

- (IBAction)gotoUserTopicsVC:(id)sender {
    if (self.topicsArr && self.topicsArr.count != 0) {
        HotTrendsVC *h = [[HotTrendsVC alloc] initWithStyle:UITableViewStylePlain];
        h.dataSourceArr = self.topicsArr;
        h.isUserTopics = YES;
        h.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:h animated:YES];
        [h release];
    }
}

- (void)dealloc {
    self.topicsArr = nil;
    self.screenName = nil;
    self.user = nil;
    [table release];
    [avatarImageView release];
    [genderImageView release];
    [nameLabel release];
    [followButton release];
    [vipImageView release];
    [fansButton release];
    [idolButton release];
    [weiboButton release];
    [topicButton release];
    [tableHeaderView release];
    [locationProfileCell release];
    [descriptionProfileCell release];
    [verifiedProfileCell release];
    [super dealloc];
}

//计算text field 的高度。
-(CGFloat)cellHeight:(NSString*)contentText with:(CGFloat)with
{
    UIFont * font=[UIFont  systemFontOfSize:14];
    CGSize size=[contentText sizeWithFont:font constrainedToSize:CGSizeMake(with, 300000.0f) lineBreakMode:kLineBreakMode];
    CGFloat height = size.height + 0.;
    return height;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kDescriptionRowsCount;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    if (indexPath.row == kSelfDescriptionRow) {
        height = [self cellHeight:user.description with:206.0f] + 35;
    }
//    else if (indexPath.row == kSinaVerifiedRow) {
//        height = [self cellHeight:user.verifiedReason with:206.0f] + 35;
//    }
    if (height < 50.) {
        height = 50.;
    }
    return height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZJTProfileCell *cell = nil;
    
    if (indexPath.row == kSinaVerifiedRow) {
        cell = self.verifiedProfileCell;
        cell.titleLabel.text = @"新浪认证:";
        cell.contentLabel.text = user.verifiedReason;
        
//        CGRect frame = cell.contentLabel.frame;
//        frame.size.height = [self cellHeight:user.verifiedReason with:206];
//        cell.contentLabel.frame = frame;
    }
    
    else if (indexPath.row == kLocationRow) {
        cell = self.locationProfileCell;
        cell.titleLabel.text = @"位置:";
        cell.contentLabel.text = user.location;
    }
    
    else if (indexPath.row == kSelfDescriptionRow) {
        cell = self.descriptionProfileCell;
        cell.titleLabel.text = @"自我介绍:";
        cell.contentLabel.text = user.description;
        
        CGRect frame = cell.contentLabel.frame;
        frame.size.height = [self cellHeight:user.description with:206];
        cell.contentLabel.frame = frame;
    }
    return cell;
}

@end


@implementation ZJTProfileCell
@synthesize contentLabel;
@synthesize titleLabel;

-(void)dealloc
{
    self.titleLabel = nil;
    self.contentLabel = nil;
    [super dealloc];
}


@end
