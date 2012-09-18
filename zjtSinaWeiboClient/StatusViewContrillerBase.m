//
//  StatusViewContrillerBase.m
//  zjtSinaWeiboClient
//
//  Created by jtone z on 11-11-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "StatusViewContrillerBase.h"
#import "ProfileVC.h"
#import "SVWebViewController.h"
#import "HotTrendsDetailTableVC.h"
#import "ZJTProfileViewController.h"

#define kTextViewPadding            16.0
#define kLineBreakMode              UILineBreakModeWordWrap

@interface StatusViewContrillerBase() 
-(void)setup;
-(void)refreshVisibleCellsImages;
@end

@implementation StatusViewContrillerBase
@synthesize table;
@synthesize statusCellNib;
@synthesize statuesArr;
@synthesize headDictionary;
@synthesize imageDictionary;
@synthesize browserView;



-(void)dealloc
{
    self.headDictionary = nil;
    self.imageDictionary = nil;
    self.statusCellNib = nil;
    self.statuesArr = nil;
    self.browserView = nil;
    _refreshHeaderView=nil;
    [table release];table = nil;
    [super dealloc];
}

-(void)setup
{
    self.title = @"主页";// NSLocalizedString(@"First", @"First");
    self.tabBarItem.image = [UIImage imageNamed:@"first"]; 
    
    CGRect frame = table.frame;
    frame.size.height = frame.size.height + REFRESH_FOOTER_HEIGHT;
    table.frame = frame;
    
    //init data
    isFirstCell = YES;
    shouldLoad = NO;
    shouldShowIndicator = YES;
    manager = [WeiBoMessageManager getInstance];
    defaultNotifCenter = [NSNotificationCenter defaultCenter];
    headDictionary = [[NSMutableDictionary alloc] init];
    imageDictionary = [[NSMutableDictionary alloc] init];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self != nil) {
        [self setup];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

-(UINib*)statusCellNib
{
    if (statusCellNib == nil) 
    {
        [statusCellNib release];
        statusCellNib = [[StatusCell nib] retain];
    }
    return statusCellNib;
}

-(void)setUpRefreshView
{
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = [view retain];
		[view release];
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}
							
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpRefreshView];
    self.tableView.contentInset = UIEdgeInsetsOriginal;
    refreshFooterView.hidden = YES;
    
    [defaultNotifCenter addObserver:self selector:@selector(getAvatar:)         name:HHNetDataCacheNotification object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(mmRequestFailed:)   name:MMSinaRequestFailed object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(loginSucceed)       name:DID_GET_TOKEN_IN_WEB_VIEW object:nil];
}

-(void)viewDidUnload
{
    [defaultNotifCenter removeObserver:self name:HHNetDataCacheNotification object:nil];
    [defaultNotifCenter removeObserver:self name:MMSinaRequestFailed        object:nil];
    [defaultNotifCenter removeObserver:self name:DID_GET_TOKEN_IN_WEB_VIEW  object:nil];
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Methods
-(void)loginSucceed
{
    shouldLoad = YES;
}

-(void)refreshVisibleCellsImages
{
    NSArray *cellArr = [self.table visibleCells];
    for (StatusCell *cell in cellArr) {
        NSIndexPath *inPath = [self.table indexPathForCell:cell];
        Status *status = [statuesArr objectAtIndex:inPath.row];
        User *user = status.user;
        
        if (user.avatarImage == nil) 
        {
            [[HHNetDataCacheManager getInstance] getDataWithURL:user.profileImageUrl withIndex:inPath.row];
        }
        else {
            cell.avatarImage.image = user.avatarImage;
        }
        
        if (status.statusImage == nil) 
        {
            [[HHNetDataCacheManager getInstance] getDataWithURL:status.thumbnailPic withIndex:inPath.row];
            [[HHNetDataCacheManager getInstance] getDataWithURL:status.retweetedStatus.thumbnailPic withIndex:inPath.row];
        }
        else {
            cell.contentImage.image = status.statusImage;
            cell.retwitterContentImage.image = status.statusImage;
        }
    }
}

//得到图片
-(void)getAvatar:(NSNotification*)sender
{
    NSDictionary * dic = sender.object;
    NSString * url          = [dic objectForKey:HHNetDataCacheURLKey];
    NSNumber *indexNumber   = [dic objectForKey:HHNetDataCacheIndex];
    NSInteger index         = [indexNumber intValue];
    NSData *data            = [dic objectForKey:HHNetDataCacheData];
    UIImage * image     = [UIImage imageWithData:data];
    
    if (data == nil) {
        NSLog(@"data == nil");
    }
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
    User *user = sts.user;
    
    StatusCell *cell = (StatusCell *)[self.table cellForRowAtIndexPath:sts.cellIndexPath];
    
    //得到的是头像图片
    if ([url isEqualToString:user.profileImageUrl]) 
    {
        user.avatarImage = image;
        cell.avatarImage.image = user.avatarImage;
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

-(void)mmRequestFailed:(id)sender
{
    [self stopLoading];
    [self doneLoadingTableViewData];
    [[SHKActivityIndicator currentIndicator] hide];
//    [[ZJTStatusBarAlertWindow getInstance] hide];
}

//上拉刷新
-(void)refresh
{
//    [manager getHomeLine:-1 maxID:-1 count:-1 page:-1 baseApp:-1 feature:-1];
//    [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view];
}

//计算text field 的高度。
-(CGFloat)cellHeight:(NSString*)contentText with:(CGFloat)with
{
//    UIFont * font=[UIFont  systemFontOfSize:15];
//    CGSize size=[contentText sizeWithFont:font constrainedToSize:CGSizeMake(with - kTextViewPadding, 300000.0f) lineBreakMode:kLineBreakMode];
//    CGFloat height = size.height + 44;
    CGFloat height = [StatusCell getJSHeight:contentText jsViewWith:with];
    return height;
}

- (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib {
    static NSString *cellID = @"StatusCell";
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
    
    detailVC.avatarImage = status.user.avatarImage;
    detailVC.contentImage = status.statusImage;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
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

#pragma mark -
#pragma mark  - Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	_reloading = YES;
}

//调用此方法来停止。
- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	refreshFooterView.hidden = NO;
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
    
    if (scrollView.contentOffset.y < 200) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    else
        [super scrollViewDidScroll:scrollView];
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
    
    if (scrollView.contentOffset.y < 200)
    {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    else
        [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    _reloading = YES;
	[manager getHomeLine:-1 maxID:-1 count:-1 page:-1 baseApp:-1 feature:-1];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


@end
