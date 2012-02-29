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

#define kTextViewPadding            16.0
#define kLineBreakMode              UILineBreakModeWordWrap

@implementation FirstViewController
@synthesize table;
@synthesize userID;
@synthesize statusCellNib;
@synthesize statuesArr;
@synthesize headDictionary;
@synthesize imageDictionary;

-(void)dealloc
{
    self.headDictionary = nil;
    self.imageDictionary = nil;
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
    if (authToken == nil) 
    {
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
    [super viewDidAppear:animated];
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

- (void)viewDidUnload 
{
    [self setTable:nil];
    [super viewDidUnload];
}

#pragma mark - Methods

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
    
    //得到文字数据后，开始加载图片
    for(int i=0;i<[statuesArr count];i++){
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
        cell.retwitterContentTF.text = retwitterStatus.text;
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
        height = [self cellHeight:status.text with:320.0f] + [self cellHeight:retwitterStatus.text with:300.0f] - 22.0f;
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
    return height;
}

#pragma mark - StatusCellDelegate

-(void)cellImageDidTaped:(StatusCell *)theCell image:(UIImage *)image
{
    Status *sts = [statuesArr objectAtIndex:[theCell.cellIndexPath row]];
    BOOL isRetwitter = sts.retweetedStatus && sts.retweetedStatus.originalPic != nil;
    
    ImageBrowser *browser = [[ImageBrowser alloc]initWithNibName:@"ImageBrowser" bundle:nil];
    browser.image = image;
    browser.bigImageURL = isRetwitter ? sts.retweetedStatus.originalPic : sts.originalPic;
    browser.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:browser animated:YES];
    [browser release];
}

@end
