//
//  ZJTDetailStatusVC.m
//  zjtSinaWeiboClient
//
//  Created by jianting zhu on 12-2-28.
//  Copyright (c) 2012年 Dunbar Science & Technology. All rights reserved.
//

#import "ZJTDetailStatusVC.h"
#import "ZJTCommentCell.h"
#import "ZJTHelpler.h"
#import "WeiBoMessageManager.h"
#import "Comment.h"
#import "ProfileVC.h"
#import "AddCommentVC.h"
#import "SHKActivityIndicator.h"
#import "GifView.h"
#import "HHNetDataCacheManager.h"

@interface ZJTDetailStatusVC ()
-(void)setViewsHeight;
@end


@implementation ZJTDetailStatusVC
@synthesize headerBackgroundView;
@synthesize mainViewBackView;
@synthesize headerView;
@synthesize table;
@synthesize avatarImageV;
@synthesize twitterNameLB;
@synthesize contentTF;
@synthesize contentImageV;
@synthesize retwitterMainV;
@synthesize retwitterTF;
@synthesize retwitterImageV;
@synthesize timeLB;
@synthesize countLB;
@synthesize commentCellNib;
@synthesize status;
@synthesize user;
@synthesize avatarImage;
@synthesize contentImage;
@synthesize commentArr;
@synthesize isFromProfileVC;
@synthesize browserView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        _hasRetwitter = NO;
        isFromProfileVC = NO;
        shouldShowIndicator = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    manager = [WeiBoMessageManager getInstance];
    
    self.user = status.user;
    self.title = user.screenName;
    _hasRetwitter   = status.hasRetwitter;
    _hasImage       = status.hasImage;
    _haveRetwitterImage = status.haveRetwitterImage;
        
    twitterNameLB.text = user.screenName;
    twitterNameLB.hidden = NO;
    contentTF.text = status.text;
    timeLB.text = status.timestamp;
    countLB.text = [NSString stringWithFormat:@"评论:%d转发:%d",status.commentsCount,status.retweetsCount];
    
    avatarImageV.image = avatarImage;
    
    if (_hasImage) {
        contentImageV.image = contentImage;
    }
    if (_haveRetwitterImage) {
        retwitterImageV.image = contentImage;
    }
    if (_hasRetwitter) {
        retwitterTF.text = [NSString stringWithFormat:@"%@:%@",status.retweetedStatus.user.screenName,status.retweetedStatus.text];
    }
    
    UIBarButtonItem *retwitterBtn = [[UIBarButtonItem alloc]initWithTitle:user.following == YES ? @"取消关注":@"关注"style:UIBarButtonItemStylePlain target:self action:@selector(follow)];
    self.navigationItem.rightBarButtonItem = retwitterBtn;
    [retwitterBtn release];
    
    contentImageV.hidden = !_hasImage;
    retwitterImageV.hidden = !_haveRetwitterImage;
    retwitterMainV.hidden = !_hasRetwitter;
    
    [self setViewsHeight];
    [self.table setTableHeaderView:headerView];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didGetComments:) name:MMSinaGotCommentList object:nil];
    [center addObserver:self selector:@selector(didFollowByUserID:) name:MMSinaFollowedByUserIDWithResult object:nil];
    [center addObserver:self selector:@selector(didUnfollowByUserID:) name:MMSinaUnfollowedByUserIDWithResult object:nil];
    [center addObserver:self selector:@selector(mmRequestFailed:) name:MMSinaRequestFailed object:nil];
}

-(void)viewDidUnload
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:MMSinaGotCommentList object:nil];
    [center removeObserver:self name:MMSinaFollowedByUserIDWithResult object:nil];
    [center removeObserver:self name:MMSinaUnfollowedByUserIDWithResult object:nil];
    [center removeObserver:self name:MMSinaRequestFailed object:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.commentArr == nil) {
        [manager getCommentListWithID:status.statusId];
        [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view]; 
//        [[ZJTStatusBarAlertWindow getInstance] showWithString:@"正在载入，请稍后..."];
    }

}

-(void)viewWillDisappear:(BOOL)animated 
{
    [super viewWillDisappear:animated];
}

-(UINib*)commentCellNib
{
    if (commentCellNib == nil) {
        self.commentCellNib = [ZJTCommentCell nib];
    }
    return commentCellNib;
}

- (void)dealloc {
    self.headerBackgroundView = nil;
    self.mainViewBackView = nil;
    self.table = nil;
    self.avatarImageV = nil;
    self.twitterNameLB = nil;
    self.contentTF = nil;
    self.contentImageV = nil;
    self.retwitterTF = nil;
    self.retwitterImageV = nil;
    self.timeLB = nil;
    self.countLB = nil;
    self.commentCellNib = nil;
    self.status = nil;
    self.user = nil;
    self.avatarImage = nil;
    self.contentImage = nil;
    self.commentArr = nil;
//    self.browserView = nil;
    self.retwitterMainV = nil;
    self.headerView = nil;
    [super dealloc];
}

#pragma mark - Methods
-(void)setViewsHeight
{
    [contentTF layoutIfNeeded];
    [retwitterTF layoutIfNeeded];
    
    //博文Text
    //size
    CGRect frame = contentTF.frame;
    frame.size = contentTF.contentSize;
    contentTF.frame = frame;
    
    //转发博文Text
    //size
    frame = retwitterTF.frame;
    frame.size = retwitterTF.contentSize;
    frame.origin = CGPointMake(10, 0);
    retwitterTF.frame = frame;
    
    //转发的主View
    frame = retwitterMainV.frame;
    //size
    if (_haveRetwitterImage)    frame.size.height = retwitterTF.frame.size.height + IMAGE_VIEW_HEIGHT + 10;
    else                        frame.size.height = retwitterTF.frame.size.height + 10;
    //origin
    if(_hasImage)               frame.origin.y = contentTF.frame.size.height + contentTF.frame.origin.y + IMAGE_VIEW_HEIGHT;
    else                        frame.origin.y = contentTF.frame.size.height + contentTF.frame.origin.y ;
    retwitterMainV.frame = frame;
    
    //转发的图片
    //origin
    frame = retwitterImageV.frame;
    frame.origin.y = retwitterTF.frame.size.height;
    frame.size.height = IMAGE_VIEW_HEIGHT;
    retwitterImageV.frame = frame;
    
    //正文的图片
    //origin
    frame = contentImageV.frame;
    frame.origin.y = contentTF.frame.size.height + contentTF.frame.origin.y - 5.0f;
    frame.size.height = IMAGE_VIEW_HEIGHT;
    contentImageV.frame = frame;
    
    //headerView
    frame = headerView.frame;
    if (_hasRetwitter) {
        frame.size.height = retwitterMainV.frame.origin.y + retwitterMainV.frame.size.height + 27;
    }
    else {
        frame.size.height = retwitterMainV.frame.origin.y + 27;
    }
    headerView.frame = frame;
    
    //背景设置
//    headerBackgroundView.image = [[UIImage imageNamed:@"table_header_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:5];
    mainViewBackView.image = [[UIImage imageNamed:@"timeline_rt_border_t.png"] stretchableImageWithLeftCapWidth:130 topCapHeight:5];
}

- (void)refresh {
    [manager getCommentListWithID:status.statusId];
    [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view]; 
//    [[ZJTStatusBarAlertWindow getInstance] showWithString:@"正在载入，请稍后..."];
}

-(void)follow
{
    if (user.following == YES) {
        [manager unfollowByUserID:user.userId];
    }
    else {
        [manager followByUserID:user.userId];
    }
}

- (IBAction)tapDetected:(id)sender {
    shouldShowIndicator = YES;
    
    UITapGestureRecognizer*tap = (UITapGestureRecognizer*)sender;
    
    UIImageView *imageView = (UIImageView*)tap.view;
    
    Status *sts = status;
    BOOL isRetwitter = sts.retweetedStatus && sts.retweetedStatus.originalPic != nil;
    UIApplication *app = [UIApplication sharedApplication];
    
    CGRect frame = CGRectMake(0, 0, 320, 480);
    
    if (browserView == nil) {
        self.browserView = [[[ImageBrowser alloc]initWithFrame:frame] autorelease];
        [browserView setUp];
    }
    
    if ([imageView isEqual:contentImageV]) {
        browserView.image = contentImageV.image;
    }
    else if ([imageView isEqual:retwitterImageV])
    {
        NSLog(@"browserView = %@",browserView);
        browserView.image = retwitterImageV.image;
    }
    
    browserView.theDelegate = self;
    browserView.bigImageURL = isRetwitter ? sts.retweetedStatus.originalPic : sts.originalPic;
    [browserView loadImage];
    
    app.statusBarHidden = YES;
    UIWindow *window = nil;
    for (UIWindow *win in app.windows) {
        if (win.tag == 0) {
            [win addSubview:browserView];
            window = win;
            [window makeKeyAndVisible];
        }
    }
    if (shouldShowIndicator == YES && browserView) {
        [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:browserView];
//        [[ZJTStatusBarAlertWindow getInstance] showWithString:@"正在载入，请稍后..."];
    }
    else shouldShowIndicator = YES;
}

- (IBAction)gotoProfileView:(id)sender 
{
    if (isFromProfileVC) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    ProfileVC *profile = [[ProfileVC alloc]initWithNibName:@"ProfileVC" bundle:nil];
    profile.userID = [NSString stringWithFormat:@"%lld",self.user.userId];
    profile.user = self.user;
    profile.avatarImage = self.avatarImage;
    [self.navigationController pushViewController:profile animated:YES];
    [profile release];
}

-(void)mmRequestFailed:(id)sender
{
    [self stopLoading];
    [[SHKActivityIndicator currentIndicator] hide];
//    [[ZJTStatusBarAlertWindow getInstance] hide];
}

- (IBAction)addComment:(id)sender {
    AddCommentVC *add = [[AddCommentVC alloc]initWithNibName:@"AddCommentVC" bundle:nil];
    add.status = self.status;
    add.weiboID = [NSString stringWithFormat:@"%lld",status.statusId];
    [self.navigationController pushViewController:add animated:YES];
    [add release];
}

//计算text field 的高度。
-(CGFloat)cellHeight:(NSString*)contentText with:(CGFloat)with
{
    UIFont * font=[UIFont  systemFontOfSize:14];
    CGSize size=[contentText sizeWithFont:font constrainedToSize:CGSizeMake(with, 300000.0f) lineBreakMode:kLineBreakMode];
    CGFloat height = size.height + 0.;
    return height;
}

#pragma mark HTTP Response
-(void)didGetComments:(NSNotification*)sender
{
    if ([sender.object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dic = sender.object;
        
        self.commentArr = [dic objectForKey:@"commentArrary"];
        if (commentArr != nil && ![commentArr isEqual:[NSNull null]]) 
        {
            NSNumber *count = [dic objectForKey:@"count"];
            countLB.text = [NSString stringWithFormat:@"评论:%d转发:%d",[count intValue],status.retweetsCount];
        }
//        [[SHKActivityIndicator currentIndicator]hide];
        [[ZJTStatusBarAlertWindow getInstance] hide];
        [table reloadData];
        [self stopLoading];
    }
}

-(void)didFollowByUserID:(NSNotification*)sender
{
    NSDictionary *dic = sender.object;
    NSNumber *result = [dic objectForKey:@"result"];
    
    if (result.intValue == 0) {//成功
        user.following = YES;
        [self.navigationItem.rightBarButtonItem setTitle:@"取消关注"];
    }
}

-(void)didUnfollowByUserID:(NSNotification *)sender
{
    NSDictionary *dic = sender.object;
    NSNumber *result = [dic objectForKey:@"result"];
    
    if (result.intValue == 0) {//成功
        user.following = NO;
        [self.navigationItem.rightBarButtonItem setTitle:@"关注"];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (commentArr == nil || [commentArr isEqual:[NSNull null]]) {
        return 0;
    }
    return [commentArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger  row = indexPath.row;
    ZJTCommentCell *cell = [ZJTCommentCell cellForTableView:table fromNib:self.commentCellNib];
    
    if (commentArr == nil || [commentArr isEqual:[NSNull null]]) {
        return cell;
    }
    else if (row >= [commentArr count] || [commentArr count] == 0)
    {
//        NSLog(@"cellForRowAtIndexPath error ,index = %d,count = %d",row,[commentArr count]);
        return cell;
    }
    
    Comment *comment = [commentArr objectAtIndex:row];
    
    cell.nameLB.text = comment.user.screenName;
    cell.contentLB.text = comment.text;
    
    CGRect frame = cell.contentLB.frame;
    frame.size.height = [self cellHeight:comment.text with:233.];
    cell.contentLB.frame = frame;
    
    cell.timeLB.text = comment.timestamp;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger  row = indexPath.row;
    Comment *comment = [commentArr objectAtIndex:row];
    CGFloat height = 0.0f;
    height = [self cellHeight:comment.text with:233.0f] + 42.;
    if (height < 66.) {
        height = 66.;
    }
    return height;
}

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
        contentImageV.image = img;
        
        NSLog(@"big url = %@",browserView.bigImageURL);
        if ([browserView.bigImageURL hasSuffix:@".gif"]) 
        {
            UIImageView *iv = browserView.imageView; // your image view
            CGSize imageSize = iv.image.size;
            CGFloat imageScale = fminf(CGRectGetWidth(iv.bounds)/imageSize.width, CGRectGetHeight(iv.bounds)/imageSize.height);
            CGSize scaledImageSize = CGSizeMake(imageSize.width*imageScale, imageSize.height*imageScale);
            CGRect imageFrame = CGRectMake(floorf(0.5f*(CGRectGetWidth(iv.bounds)-scaledImageSize.width)), floorf(0.5f*(CGRectGetHeight(iv.bounds)-scaledImageSize.height)), scaledImageSize.width, scaledImageSize.height);
            
            GifView *gifView = [[GifView alloc]initWithFrame:imageFrame data:[dic objectForKey:HHNetDataCacheData]];
            
            gifView.userInteractionEnabled = NO;
            gifView.tag = GIF_VIEW_TAG;
            [browserView addSubview:gifView];
            [gifView release];
        }
    }
}

#pragma mark - Swipe Gesture delegate

- (IBAction)popViewC:(id)sender 
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
