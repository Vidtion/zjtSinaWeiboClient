//
//  FirstViewController.m
//  zjtSinaWeiboClient
//
//  Created by jtone z on 11-11-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "WeiBoMessageManager.h"
#import "Status.h"
#import "User.h"
#import "OAuthWebView.h"
#import "ASIHTTPRequest.h"
#import "HHNetDataCacheManager.h"
#import "ImageBrowser.h"
#import "GifView.h"

#define kTextViewPadding            16.0
#define kLineBreakMode              UILineBreakModeWordWrap

@interface FirstViewController() 
-(void)getImages;
@end

@implementation FirstViewController
@synthesize table;
@synthesize userID;
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
    self.userID = nil;
    self.browserView = nil;
    
    [table release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        
        //init data
        shouldLoad = NO;
        shouldLoadAvatar = NO;
        manager = [WeiBoMessageManager getInstance];
        defaultNotifCenter = [NSNotificationCenter defaultCenter];
        headDictionary = [[NSMutableDictionary alloc] initWithCapacity:100];
        imageDictionary = [[NSMutableDictionary alloc] initWithCapacity:100];
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
							
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //如果未授权，则调入授权页面。
    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    NSLog([manager isNeedToRefreshTheToken] == YES ? @"need to login":@"will login");
    if (authToken == nil || [manager isNeedToRefreshTheToken]) 
    {
        shouldLoad = YES;
        OAuthWebView *webV = [[OAuthWebView alloc]initWithNibName:@"OAuthWebView" bundle:nil];
        [self presentModalViewController:webV animated:NO];
        [webV release];
    }
    else
    {
        [manager getUserID];
        [manager getHomeLine:-1 maxID:-1 count:100 page:-1 baseApp:-1 feature:-1];
    }
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    if (shouldLoad) 
    {
        shouldLoad = NO;
        [manager getUserID];
        [manager getHomeLine:-1 maxID:-1 count:-1 page:-1 baseApp:-1 feature:-1];
    }
    [defaultNotifCenter addObserver:self selector:@selector(didGetUserID:) name:MMSinaGotUserID object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(didGetHomeLine:) name:MMSinaGotHomeLine object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(getAvatar:) name:HHNetDataCacheNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [defaultNotifCenter removeObserver:self name:MMSinaGotUserID object:nil];
    [defaultNotifCenter removeObserver:self name:MMSinaGotHomeLine object:nil];
    [defaultNotifCenter removeObserver:self name:HHNetDataCacheNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getImages];
}

- (void)viewDidUnload 
{
    [self setTable:nil];
    [super viewDidUnload];
}

#pragma mark - Methods

//异步加载图片
-(void)getImages
{
    //得到文字数据后，开始加载图片
    for(int i=0;i<[statuesArr count];i++)
    {
        Status * member=[statuesArr objectAtIndex:i];
        NSNumber *indexNumber = [NSNumber numberWithInt:i];
        
        //下载头像图片
        [[HHNetDataCacheManager getInstance] getDataWithURL:member.user.profileImageUrl withIndex:i];
        
        //下载博文图片
        if (member.thumbnailPic && [member.thumbnailPic length] != 0)
        {
            [[HHNetDataCacheManager getInstance] getDataWithURL:member.thumbnailPic withIndex:i];
        }
        else
        {
            [imageDictionary setObject:[NSNull null] forKey:indexNumber];
        }
        
        //下载转发的图片
        if (member.retweetedStatus.thumbnailPic && [member.retweetedStatus.thumbnailPic length] != 0) 
        {
            [[HHNetDataCacheManager getInstance] getDataWithURL:member.retweetedStatus.thumbnailPic withIndex:i];
        }
        else
        {
            [imageDictionary setObject:[NSNull null] forKey:indexNumber];
        }
    }
}

//得到图片
-(void)getAvatar:(NSNotification*)sender
{
    NSDictionary * dic = sender.object;
    NSString * url=[dic objectForKey:HHNetDataCacheURLKey];
    NSNumber *indexNumber = [dic objectForKey:HHNetDataCacheIndex];
    NSInteger index = [indexNumber intValue];
    
    if (index > [statuesArr count]) {
        NSLog(@"statues arr error ,index = %d,count = %d",index,[statuesArr count]);
        return;
    }
    
    Status *sts = [statuesArr objectAtIndex:index];
    User *user = sts.user;
    
    //得到的是头像图片
    if ([url isEqualToString:user.profileImageUrl]) 
    {
        UIImage * image     = [UIImage imageWithData:[dic objectForKey:HHNetDataCacheData]];
        user.avatarImage    = image;
        
        [headDictionary setObject:[dic objectForKey:HHNetDataCacheData] forKey:indexNumber];
    }
    
    //得到的是博文图片
    if([url isEqualToString:sts.thumbnailPic])
    {
        [imageDictionary setObject:[dic objectForKey:HHNetDataCacheData] forKey:indexNumber];
    }
    
    //得到的是转发的图片
    if (sts.retweetedStatus && ![sts.retweetedStatus isEqual:[NSNull null]])
    {
        if ([url isEqualToString:sts.retweetedStatus.thumbnailPic])
        {
            [imageDictionary setObject:[dic objectForKey:HHNetDataCacheData] forKey:indexNumber];
        }
    }
    
    //reload table
    NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:index inSection:0];
    NSArray     *arr        = [NSArray arrayWithObject:indexPath];
    [table reloadRowsAtIndexPaths:arr withRowAnimation:NO];
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
    
    [self getImages];
}

//计算text field 的高度。
-(CGFloat)cellHeight:(NSString*)contentText with:(CGFloat)with
{
    UIFont * font=[UIFont  systemFontOfSize:14];
    CGSize size=[contentText sizeWithFont:font constrainedToSize:CGSizeMake(with - kTextViewPadding, 300000.0f) lineBreakMode:kLineBreakMode];
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
    cell.userNameLB.text = status.user.screenName;
    cell.delegate = self;
    cell.cellIndexPath = indexPath;
    
    NSData *data = [headDictionary objectForKey:[NSNumber numberWithInt:[indexPath row]]];
    cell.avatarImage.image = [UIImage imageWithData:data];
    
    Status  *retwitterStatus    = status.retweetedStatus;
//    User    *retwitterUser      = status.user;
    
    //有转发
    if (retwitterStatus && ![retwitterStatus isEqual:[NSNull null]]) 
    {
        cell.retwitterMainV.hidden = NO;
        cell.retwitterContentTF.text = [NSString stringWithFormat:@"%@:%@",status.retweetedStatus.user.screenName,retwitterStatus.text];
        cell.contentImage.hidden = YES;
        
        NSData *data = [imageDictionary objectForKey:[NSNumber numberWithInt:[indexPath row]]];
        if (![data isEqual:[NSNull null]]) 
        {
            cell.retwitterContentImage.image = [UIImage imageWithData:data];
        }
        
        NSString *url = status.retweetedStatus.thumbnailPic;
        cell.retwitterContentImage.hidden = url != nil && [url length] != 0 ? NO : YES;
        [cell setTFHeightWithImage:NO 
                haveRetwitterImage:url != nil && [url length] != 0 ? YES : NO];//计算cell的高度，以及背景图的处理
    }
    
    //无转发
    else
    {
        cell.retwitterMainV.hidden = YES;
        NSData *data = [imageDictionary objectForKey:[NSNumber numberWithInt:[indexPath row]]];
        if (![data isEqual:[NSNull null]]) {
            cell.contentImage.image = [UIImage imageWithData:data];
        }
        
        NSString *url = status.thumbnailPic;
        cell.contentImage.hidden = url != nil && [url length] != 0 ? NO : YES;
        [cell setTFHeightWithImage:url != nil && [url length] != 0 ? YES : NO 
                haveRetwitterImage:NO];//计算cell的高度，以及背景图的处理
    }
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
{
    NSInteger  row = indexPath.row;
    Status *status          = [statuesArr objectAtIndex:row];
    Status *retwitterStatus = status.retweetedStatus;
    NSString *url = status.retweetedStatus.thumbnailPic;
    NSString *url2 = status.thumbnailPic;
    
    CGFloat height = 0.0f;
    
    //有转发的博文
    if (retwitterStatus && ![retwitterStatus isEqual:[NSNull null]])
    {
        height = [self cellHeight:status.text with:320.0f] + [self cellHeight:[NSString stringWithFormat:@"%@:%@",status.retweetedStatus.user.screenName,retwitterStatus.text] with:300.0f] - 22.0f;
    }
    
    //无转发的博文
    else
    {
        height = [self cellHeight:status.text with:320.0f];
    }
    
    //
    if ((url && [url length] != 0) || (url2 && [url2 length] != 0))
    {
        height = height + 80;
    }
    return height + 10;
}

#pragma mark - StatusCellDelegate

-(void)getOriginImage:(NSNotification*) hhack
{
    NSDictionary * dic=hhack.object;
    NSString * url=[dic objectForKey:HHNetDataCacheURLKey];
    if ([url isEqualToString:browserView.bigImageURL]) 
    {
        UIImage * img=[UIImage imageWithData:[dic objectForKey:HHNetDataCacheData]];
        [browserView.imageView setImage:img];
        
        NSLog(@"big url = %@",browserView.bigImageURL);
        if ([browserView.bigImageURL hasSuffix:@".gif"]) 
        {
            GifView *gifView = [[GifView alloc]initWithFrame:browserView.frame data:[dic objectForKey:HHNetDataCacheData]];
            gifView.userInteractionEnabled = NO;
            [browserView addSubview:gifView];
            [gifView release];
        }
    }
}

-(void)cellImageDidTaped:(StatusCell *)theCell image:(UIImage *)image
{
    Status *sts = [statuesArr objectAtIndex:[theCell.cellIndexPath row]];
    BOOL isRetwitter = sts.retweetedStatus && sts.retweetedStatus.originalPic != nil;
    UIApplication *app = [UIApplication sharedApplication];
    
    CGRect frame = CGRectMake(0, 0, 320, 480);
    if (browserView == nil) {
        self.browserView = [[ImageBrowser alloc]initWithFrame:frame];
        [browserView release];
    }
    
    browserView.image = image;
    browserView.delegate = self;
    browserView.bigImageURL = isRetwitter ? sts.retweetedStatus.originalPic : sts.originalPic;
    [browserView setUp];
    
    //animation
    browserView.frame = CGRectMake(0, 0, 10, 10);
    app.statusBarHidden = YES;
    [app.keyWindow addSubview:browserView];
    [UIView beginAnimations:nil context:nil];		
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:app.keyWindow cache:YES];
    browserView.frame = frame;
    [UIView commitAnimations]; 
    
}

@end
