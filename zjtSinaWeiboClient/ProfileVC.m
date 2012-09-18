//
//  ProfileVC.m
//  zjtSinaWeiboClient
//
//  Created by jianting zhu on 12-2-25.
//  Copyright (c) 2012年 Dunbar Science & Technology. All rights reserved.
//

#import "ProfileVC.h"
#import "WeiBoMessageManager.h"
#import "Status.h"
#import "User.h"
#import "ASIHTTPRequest.h"
#import "HHNetDataCacheManager.h"
#import "ImageBrowser.h"
#import "GifView.h"
#import "SHKActivityIndicator.h"
#import "ZJTDetailStatusVC.h"
#import "FollowerVC.h"
#import "ZJTHelpler.h"
#import "SVModalWebViewController.h"
#import "HotTrendsDetailTableVC.h"
#import "ZJTProfileViewController.h"

@interface ProfileVC ()

-(void)loadDataFromUser:(User*)theUser;

@end

@implementation ProfileVC
@synthesize table;
@synthesize userID;
@synthesize statusCellNib;
@synthesize statuesArr;
@synthesize imageDictionary;
@synthesize browserView;
@synthesize headerView;
@synthesize headerVImageV;
@synthesize headerVNameLB;
@synthesize weiboCount;
@synthesize followerCount;
@synthesize followingCount;
@synthesize user;
@synthesize avatarImage;
@synthesize screenName;

-(void)dealloc
{
    self.screenName = nil;
    self.avatarImage = nil;
    self.user = nil;
    self.imageDictionary = nil;
    self.statusCellNib = nil;
    self.statuesArr = nil;
    self.userID = nil;
    self.browserView = nil;
    self.table = nil;
    self.headerVImageV = nil;
    self.headerVNameLB = nil;
    self.weiboCount = nil;
    self.followerCount = nil;
    self.followingCount = nil;
    
    self.headerView = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //init data
        isFirstCell = YES;
        shouldLoad = NO;
        shouldLoadAvatar = NO;
        shouldShowIndicator = YES;
        _page = 1;
        _maxID = -1;
        
        manager = [WeiBoMessageManager getInstance];
        defaultNotifCenter = [NSNotificationCenter defaultCenter];
        imageDictionary = [[NSMutableDictionary alloc] initWithCapacity:100];
        
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

-(UINib*)statusCellNib
{
    if (statusCellNib == nil) 
    {
        self.statusCellNib = [StatusCell nib];
    }
    return statusCellNib;
}

-(void)refreshData
{
    [self loadDataFromUser:user];
    if (avatarImage) {
        self.headerVImageV.image = avatarImage;
    }
    else {
//        [[HHNetDataCacheManager getInstance] getDataWithURL:user.profileLargeImageUrl];
    }
    if (![self.title isEqualToString:@"我的微博"]) {
        self.title = user.screenName;
    }
    self.headerVNameLB.text = user.screenName;
    self.weiboCount.text = [NSString stringWithFormat:@"%d",user.statusesCount];
    self.followerCount.text = [NSString stringWithFormat:@"%d",user.followersCount];
    self.followingCount.text = [NSString stringWithFormat:@"%d",user.friendsCount];
    
    if (!user) {
        return;
    }
    
    [manager getUserStatusUserID:userID sinceID:-1 maxID:_maxID count:8 page:_page baseApp:-1 feature:-1];
    [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..."];
//    [[ZJTStatusBarAlertWindow getInstance] showWithString:@"正在载入，请稍后..."];
}

-(void)loadDataFromUser:(User*)theUser
{
    if (theUser) {
        self.userID = [NSString stringWithFormat:@"%lld",theUser.userId];
        self.screenName = theUser.screenName;
//        [[HHNetDataCacheManager getInstance] getDataWithURL:user.profileLargeImageUrl];
    }
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
//    [table setTableHeaderView:headerView];
    
//    if (userID == nil) {
//        userID = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
//    }
//    if (!user) {
//        self.user = [ZJTHelpler getInstance].user;
//    }
    
    if ([self.title isEqualToString:@"我的微博"]) {
        self.user = [ZJTHelpler getInstance].user;
    }

    if (self.user) {
        [self refreshData];
    }
    else if(screenName){
        [manager getUserInfoWithScreenName:self.screenName];
    }
    
    self.tableView.contentInset = UIEdgeInsetsOriginal;
    
}

-(void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    
    [defaultNotifCenter addObserver:self selector:@selector(didGetHomeLine:)    name:MMSinaGotUserStatus        object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(getAvatar:)         name:HHNetDataCacheNotification object:nil];
    //    [defaultNotifCenter addObserver:self selector:@selector(didGetUserInfo:)    name:MMSinaGotUserInfo          object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(mmRequestFailed:) name:MMSinaRequestFailed object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(didGetUserInfo:)    name:MMSinaGotUserInfo          object:nil];
    
    if (shouldLoad) 
    {
        shouldLoad = NO;
        [manager getUserStatusUserID:userID sinceID:-1 maxID:-1 count:8 page:-1 baseApp:-1 feature:-1];
        [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..."];
//        [[ZJTStatusBarAlertWindow getInstance] showWithString:@"正在载入，请稍后..."];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [defaultNotifCenter removeObserver:self name:MMSinaGotUserStatus        object:nil];
    [defaultNotifCenter removeObserver:self name:HHNetDataCacheNotification object:nil];
    //    [defaultNotifCenter removeObserver:self name:MMSinaGotUserInfo          object:nil];
    [defaultNotifCenter removeObserver:self name:MMSinaRequestFailed object:nil];
    [defaultNotifCenter removeObserver:self name:MMSinaGotUserInfo          object:nil];
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

-(void)refreshVisibleCellsImages
{
    NSArray *cellArr = [self.table visibleCells];
    for (StatusCell *cell in cellArr) {
        NSIndexPath *inPath = [self.table indexPathForCell:cell];
        Status *status = [statuesArr objectAtIndex:inPath.row];
        
        if (status.user.avatarImage == nil) 
        {
            [[HHNetDataCacheManager getInstance] getDataWithURL:status.user.profileImageUrl withIndex:inPath.row];
        }
        
        if (status.statusImage == nil) 
        {
            [[HHNetDataCacheManager getInstance] getDataWithURL:status.thumbnailPic withIndex:inPath.row];
            [[HHNetDataCacheManager getInstance] getDataWithURL:status.retweetedStatus.thumbnailPic withIndex:inPath.row];
        }
        else {
            cell.avatarImage.image = status.user.avatarImage;
            cell.contentImage.image = status.statusImage;
            cell.retwitterContentImage.image = status.statusImage;
        }
    }
}

#pragma mark - Methods

-(void)getAvatar:(NSNotification*)sender
{
    NSDictionary * dic = sender.object;
    NSString * url          = [dic objectForKey:HHNetDataCacheURLKey];
    NSNumber *indexNumber   = [dic objectForKey:HHNetDataCacheIndex];
    NSInteger index         = [indexNumber intValue];
    NSData *data            = [dic objectForKey:HHNetDataCacheData];
    UIImage * image     = [UIImage imageWithData:data];
    
//    if ([url isEqualToString:self.user.profileLargeImageUrl]) {
//        self.avatarImage = image;
//        self.headerVImageV.image = image;
//    }
    
//    
//    if([url isEqualToString:user.profileLargeImageUrl])
//    {
//        self.avatarImage = image;
//        headerVImageV.image = image;
//    }
//    else {
//        NSLog(@"url = %@",url);
//        NSLog(@"pro = %@",user.profileLargeImageUrl);
//    }
    
    //当下载大图过程中，后退，又返回，如果此时收到大图的返回数据，会引起crash，在此做预防。
    if (indexNumber == nil || index == -1) {
        NSLog(@"indexNumber = nil");
        return;
    }
    
    if (index >= [statuesArr count]) {
        //        NSLog(@"statues arr error ,index = %d,count = %d",index,[statuesArr count]);
        return;
    }
    
    Status *sts = [statuesArr objectAtIndex:index];
    StatusCell *cell = (StatusCell *)[self.table cellForRowAtIndexPath:sts.cellIndexPath];
    
    //得到的是头像图片
    if ([url isEqualToString:sts.user.profileImageUrl]) 
    {
        sts.user.avatarImage = image;
        cell.avatarImage.image = sts.user.avatarImage;
    }
    
    //得到的是博文图片
    if([url isEqualToString:sts.thumbnailPic])
    {
        sts.statusImage = image;
        cell.contentImage.image = sts.statusImage;
        cell.retwitterContentImage.image = sts.statusImage;
    }
    
    //得到的是转发的图片
    if (sts.retweetedStatus && ![sts.retweetedStatus isEqual:[NSNull null]])
    {
        if ([url isEqualToString:sts.retweetedStatus.thumbnailPic])
        {
            sts.statusImage = image;
            cell.retwitterContentImage.image = sts.statusImage;
        }
    }
}

-(void)didGetUserInfo:(NSNotification*)sender
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    
    if (uid.longLongValue == user.userId) {
        User *theUser = sender.object;
        self.user = theUser;
        [self loadDataFromUser:user];
        [self refreshData];
    }
    
    if ([self.title isEqualToString:@"我的微博"]) {
        return;
    }

    User *theUser = sender.object;
    self.user = theUser;
    [self loadDataFromUser:user];
    [self refreshData];
}

-(void)didGetUserID:(NSNotification*)sender
{
//    self.userID = sender.object;
//    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:USER_STORE_USER_ID];
//    [manager getUserInfoWithUserID:[userID longLongValue]];
}

//-(void)didGetUserInfo:(NSNotification*)sender
//{
//    User *aUser = sender.object;
//    if (self.title != @"我的微博") {
//        self.title = aUser.screenName;
//    }
//}

-(void)didGetHomeLine:(NSNotification*)sender
{
    [self stopLoading];
    
    shouldLoadAvatar = YES;
    if (statuesArr == nil || statuesArr.count == 0) {
        self.statuesArr = sender.object;
        Status *sts = [statuesArr objectAtIndex:0];
        _maxID = sts.statusId;
        _page = 1;
    }
    else {
        [statuesArr addObjectsFromArray:sender.object];
    }
    _page ++;
    [table reloadData];
    [[SHKActivityIndicator currentIndicator] hide];
//    [[ZJTStatusBarAlertWindow getInstance] hide];
    
    [imageDictionary removeAllObjects];
}

-(void)mmRequestFailed:(id)sender
{
    [self stopLoading];
    [[SHKActivityIndicator currentIndicator] hide];
//    [[ZJTStatusBarAlertWindow getInstance] hide];
}

-(void)refresh
{
    [manager getUserStatusUserID:userID sinceID:-1 maxID:_maxID count:8 page:_page baseApp:-1 feature:-1];
}

//计算text field 的高度。
-(CGFloat)cellHeight:(NSString*)contentText with:(CGFloat)with
{
    UIFont * font=[UIFont  systemFontOfSize:14];
    CGSize size=[contentText sizeWithFont:font constrainedToSize:CGSizeMake(with - kTextViewPadding, 300000.0f) lineBreakMode:kLineBreakMode];
    CGFloat height = size.height + 44;
    return height;
}

- (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib {
    NSString *cellID = NSStringFromClass([StatusCell class]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        if (isFirstCell) {
            [[SHKActivityIndicator currentIndicator] hide];
//            [[ZJTStatusBarAlertWindow getInstance] hide];
            isFirstCell = NO;
        }
        NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
        cell = [nibObjects objectAtIndex:0];
    }
    else {
        [(LPBaseCell *)cell reset];
    }
    
    return cell;
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
    StatusCell *cell = [self cellForTableView:tableView fromNib:self.statusCellNib];
    
    if (row >= [statuesArr count]) {
        return cell;
    }
    
    Status *status = [statuesArr objectAtIndex:row];
    status.cellIndexPath = indexPath;
    cell.delegate = self;
    cell.cellIndexPath = indexPath;
    [cell updateCellTextWith:status];
    if (self.table.dragging == NO && self.table.decelerating == NO)
    {
        if (status.user.avatarImage == nil) 
        {
            [[HHNetDataCacheManager getInstance] getDataWithURL:status.user.profileImageUrl withIndex:row];
        }
        
        if (status.statusImage == nil) 
        {
            [[HHNetDataCacheManager getInstance] getDataWithURL:status.thumbnailPic withIndex:row];
            [[HHNetDataCacheManager getInstance] getDataWithURL:status.retweetedStatus.thumbnailPic withIndex:row];
        }
    }
    cell.avatarImage.image = status.user.avatarImage;
    cell.contentImage.image = status.statusImage;
    cell.retwitterContentImage.image = status.statusImage;
    
    if (user && user.avatarImage) {
        cell.avatarImage.image = user.avatarImage;
    }
    
    //开始绘制第一个cell时，隐藏indecator.
    if (isFirstCell) {
        [[SHKActivityIndicator currentIndicator] hide];
        //        [[ZJTStatusBarAlertWindow getInstance] hide];
        isFirstCell = NO;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
{
    NSInteger  row = indexPath.row;
    
    if (row >= [statuesArr count]) {
        return 1;
    }
    
    Status *status          = [statuesArr objectAtIndex:row];
    Status *retwitterStatus = status.retweetedStatus;
    NSString *url = status.retweetedStatus.thumbnailPic;
    NSString *url2 = status.thumbnailPic;
    
    StatusCell *cell = [self cellForTableView:tableView fromNib:self.statusCellNib];
    [cell updateCellTextWith:status];
    
    CGFloat height = 0.0f;
    
    //有转发的博文
    if (retwitterStatus && ![retwitterStatus isEqual:[NSNull null]])
    {
        height = [cell setTFHeightWithImage:NO 
                         haveRetwitterImage:url != nil && [url length] != 0 ? YES : NO];//计算cell的高度
    }
    
    //无转发的博文
    else
    {
        height = [cell setTFHeightWithImage:url2 != nil && [url2 length] != 0 ? YES : NO 
                         haveRetwitterImage:NO];//计算cell的高度
    }
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger  row = indexPath.row;
    if (row >= [statuesArr count]) {
//        NSLog(@"didSelectRowAtIndexPath error ,index = %d,count = %d",row,[statuesArr count]);
        return ;
    }
    
    ZJTDetailStatusVC *detailVC = [[ZJTDetailStatusVC alloc] initWithNibName:@"ZJTDetailStatusVC" bundle:nil];
    Status *status  = [statuesArr objectAtIndex:row];
    detailVC.status = status;
    detailVC.isFromProfileVC = YES;
    detailVC.avatarImage = avatarImage;
    
    detailVC.avatarImage = status.user.avatarImage;
    detailVC.contentImage = status.statusImage;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
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
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

#pragma mark - StatusCellDelegate

-(void)browserDidGetOriginImage:(NSDictionary*)dic
{
    NSString * url=[dic objectForKey:HHNetDataCacheURLKey];
    if ([url isEqualToString:browserView.bigImageURL]) 
    {
        [[SHKActivityIndicator currentIndicator] hide];
//        [[ZJTStatusBarAlertWindow getInstance] hide];
        shouldShowIndicator = NO;
        
        UIImage * img=[UIImage imageWithData:[dic objectForKey:HHNetDataCacheData]];
        [browserView.imageView setImage:img];
        [browserView zoomToFit];
        
        NSLog(@"big url = %@",browserView.bigImageURL);
        if ([browserView.bigImageURL hasSuffix:@".gif"]) 
        {
            CGFloat zoom = 320.0/browserView.imageView.image.size.width;
            CGSize size = CGSizeMake(320.0, browserView.imageView.image.size.height * zoom);
            
            CGRect frame = browserView.imageView.frame;
            frame.size = size;
            frame.origin.x = 0;
            CGFloat y = (480.0 - size.height)/2.0;
            frame.origin.y = y >= 0 ? y:0;
            browserView.imageView.frame = frame;
            if (browserView.imageView.frame.size.height > 480) {
                browserView.aScrollView.contentSize = CGSizeMake(320, browserView.imageView.frame.size.height);
            }
            
            GifView *gifView = [[GifView alloc]initWithFrame:frame data:[dic objectForKey:HHNetDataCacheData]];
            
            gifView.userInteractionEnabled = NO;
            gifView.tag = GIF_VIEW_TAG;
            [browserView addSubview:gifView];
            [gifView release];
        }
    }
}

-(void)cellImageDidTaped:(StatusCell *)theCell image:(UIImage *)image
{
    shouldShowIndicator = YES;
    
    if ([theCell.cellIndexPath row] > [statuesArr count]) {
//        NSLog(@"cellImageDidTaped error ,index = %d,count = %d",[theCell.cellIndexPath row],[statuesArr count]);
        return ;
    }
    
    Status *sts = [statuesArr objectAtIndex:[theCell.cellIndexPath row]];
    BOOL isRetwitter = sts.retweetedStatus && sts.retweetedStatus.originalPic != nil;
    UIApplication *app = [UIApplication sharedApplication];
    
    CGRect frame = CGRectMake(0, 0, 320, 480);
    if (browserView == nil) {
        self.browserView = [[[ImageBrowser alloc]initWithFrame:frame] autorelease];
        [browserView setUp];
    }
    
    browserView.image = image;
    browserView.theDelegate = self;
    browserView.bigImageURL = isRetwitter ? sts.retweetedStatus.originalPic : sts.originalPic;
    [browserView loadImage];
    [app.keyWindow addSubview:browserView];
    app.statusBarHidden = YES;
//    app.statusBarHidden = YES;
//    UIWindow *window = nil;
//    for (UIWindow *win in app.windows) {
//        if (win.tag == 0) {
//            [win addSubview:browserView];
//            window = win;
//            [window makeKeyAndVisible];
//        }
//    }
    
    //animation
    //    CAAnimation *anim = [ZJTHelpler animationWithOpacityFrom:0.0f To:1.0f Duration:0.3f BeginTime:0.0f];
    //    [browserView.layer addAnimation:anim forKey:@"jtone"];
    
    if (shouldShowIndicator == YES && browserView) {
        [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:browserView];
//        [[ZJTStatusBarAlertWindow getInstance] showWithString:@"正在载入，请稍后..."];
    }
    else shouldShowIndicator = YES;
}

-(void)cellLinkDidTaped:(StatusCell *)theCell link:(NSString*)link
{
    if ([link hasPrefix:@"@"]) 
    {
        NSString *sn = [[link substringFromIndex:1] decodeFromURL];
        NSLog(@"sn = %@",sn);
//        ProfileVC *profile = [[ProfileVC alloc]initWithNibName:@"ProfileVC" bundle:nil];
//        profile.screenName = sn;
//        profile.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:profile animated:YES];
//        [profile release];
        
        ZJTProfileViewController *profile = [[ZJTProfileViewController alloc]initWithNibName:@"ZJTProfileViewController" bundle:nil];
        profile.screenName = sn;
        profile.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:profile animated:YES];
        [profile release];
    }
    else if ([link hasPrefix:@"http"]) {
        SVModalWebViewController *web = [[SVModalWebViewController alloc] initWithURL:[NSURL URLWithString:link]];
        web.modalPresentationStyle = UIModalPresentationPageSheet;
        web.availableActions = SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsCopyLink | SVWebViewControllerAvailableActionsMailLink;
        [self presentModalViewController:web animated:YES];
        [web release];
    }
    else if ([link hasPrefix:@"#"]) {
        HotTrendsDetailTableVC *hotVC = [[HotTrendsDetailTableVC alloc] initWithNibName:@"FirstViewController" bundle:nil];
        hotVC.qureyString = [[link substringFromIndex:1] decodeFromURL];;
        [self.navigationController pushViewController:hotVC animated:YES];
        [hotVC release];
    }
}

-(void)cellTextDidTaped:(StatusCell *)theCell
{
    NSIndexPath *index = [self.table indexPathForCell:theCell];
    [self tableView:self.table didSelectRowAtIndexPath:index];
}

@end
