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
#import "AHMarkedHyperlink.h"
#import "NSStringAdditions.h"
#import "SVModalWebViewController.h"
#import "HotTrendsDetailTableVC.h"
#import "ZJTProfileViewController.h"
#import "TwitterVC.h"

enum{
    kCommentClickActionSheet = 0,
    kStatusReplyActionSheet,
};

enum{
    kReplyComment = 0,
    kViewUserProfile,
    kFollowTheUser,
};

enum  {
    kRetweet = 0,
    kComment,
};

@interface ZJTDetailStatusVC ()
-(void)setViewsHeight;
-(CGRect)getFrameOfImageView:(UIImageView*)imgView;
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
@synthesize JSContentTF = _JSContentTF;
@synthesize JSRetitterContentTF = _JSRetitterContentTF;
@synthesize contentImageBackgroundView;
@synthesize retwitterImageBackground;
@synthesize retwitterCountImageView;
@synthesize commentCountImageView;
@synthesize vipImageView;
@synthesize clickedComment;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        _hasRetwitter = NO;
        isFromProfileVC = NO;
        shouldShowIndicator = YES;
        _page = 1;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(JSTwitterCoreTextView*)JSContentTF
{
    
    if (_JSContentTF == nil) {
        _JSContentTF = [[JSTwitterCoreTextView alloc] initWithFrame:CGRectMake(0, 87, 320, 80)];
        [_JSContentTF setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_JSContentTF setDelegate:self];
        [_JSContentTF setFontName:FONT];
        [_JSContentTF setFontSize:FONT_SIZE];
        [_JSContentTF setHighlightColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
        [_JSContentTF setBackgroundColor:[UIColor clearColor]];
        [_JSContentTF setPaddingTop:PADDING_TOP];
        [_JSContentTF setPaddingLeft:PADDING_LEFT];
        //        _JSContentTF.userInteractionEnabled = NO;
        _JSContentTF.backgroundColor = [UIColor clearColor];
        _JSContentTF.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];
        _JSContentTF.linkColor = [UIColor colorWithRed:96/255.0 green:138/255.0 blue:176/255.0 alpha:1];
        [self.headerView addSubview:_JSContentTF];
    }
    
    return _JSContentTF;
}

-(JSTwitterCoreTextView*)JSRetitterContentTF
{    
    if (_JSRetitterContentTF == nil) {
        _JSRetitterContentTF = [[JSTwitterCoreTextView alloc] initWithFrame:CGRectMake(10, 0, 300, 80)];
        [_JSRetitterContentTF setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_JSRetitterContentTF setDelegate:self];
        [_JSRetitterContentTF setFontName:FONT];
        [_JSRetitterContentTF setFontSize:FONT_SIZE];
        [_JSRetitterContentTF setHighlightColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
        [_JSRetitterContentTF setBackgroundColor:[UIColor clearColor]];
        [_JSRetitterContentTF setPaddingTop:PADDING_TOP];
        [_JSRetitterContentTF setPaddingLeft:PADDING_LEFT];
        //        _JSRetitterContentTF.userInteractionEnabled = NO;
        _JSRetitterContentTF.backgroundColor = [UIColor clearColor];
        _JSRetitterContentTF.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];
        _JSRetitterContentTF.linkColor = [UIColor colorWithRed:96/255.0 green:138/255.0 blue:176/255.0 alpha:1];
        [self.retwitterMainV addSubview:_JSRetitterContentTF];
    }
    
    return _JSRetitterContentTF;
}

+(CGFloat)getJSHeight:(NSString*)text jsViewWith:(CGFloat)with
{
    CGFloat height = [JSCoreTextView measureFrameHeightForText:text
                                                      fontName:FONT 
                                                      fontSize:FONT_SIZE 
                                            constrainedToWidth:with - (PADDING_LEFT * 2)
                                                    paddingTop:PADDING_TOP 
                                                   paddingLeft:PADDING_LEFT];
    return height;
}

-(CGRect)getFrameOfImageView:(UIImageView*)imgView
{
    UIImageView *iv = imgView; // your image view
    CGSize imageSize = iv.image.size;
    CGFloat imageScale = fminf(CGRectGetWidth(iv.bounds)/imageSize.width, CGRectGetHeight(iv.bounds)/imageSize.height);
    CGSize scaledImageSize = CGSizeMake(imageSize.width*imageScale, imageSize.height*imageScale);
    CGRect imageFrame = CGRectMake(floorf(0.5f*(CGRectGetWidth(iv.bounds)-scaledImageSize.width)), floorf(0.5f*(CGRectGetHeight(iv.bounds)-scaledImageSize.height)), scaledImageSize.width, scaledImageSize.height);
    return imageFrame;
}

-(void)refreshVisibleCellsImages
{
    NSArray *cellArr = [self.table visibleCells];
    for (ZJTCommentCell *cell in cellArr) {
        NSIndexPath *inPath = [self.table indexPathForCell:cell];
        Comment *comment = [commentArr objectAtIndex:inPath.row];
        User *theUser = comment.user;
        
        if (theUser.avatarImage == nil) 
        {
            [[HHNetDataCacheManager getInstance] getDataWithURL:theUser.profileImageUrl withIndex:inPath.row];
        }
        else {
            cell.avatarImage.image = theUser.avatarImage;
        }
    }
}

-(void)adjustTheHeightOf:(JSTwitterCoreTextView *)jsView withText:(NSString*)text
{
    CGFloat height = [StatusCell getJSHeight:text jsViewWith:jsView.frame.size.width];
    CGRect textFrame = [jsView frame];
    textFrame.size.height = height;
    [jsView setFrame:textFrame];
}

- (void)textView:(JSCoreTextView *)textView linkTapped:(AHMarkedHyperlink *)link
{
    if ([link.URL.absoluteString hasPrefix:@"@"]) 
    {
        NSString *sn = [[link.URL.absoluteString substringFromIndex:1] decodeFromURL];
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
    
    else if ([link.URL.absoluteString hasPrefix:@"http"]) {
        SVModalWebViewController *web = [[SVModalWebViewController alloc] initWithURL:link.URL];
        web.modalPresentationStyle = UIModalPresentationPageSheet;
        web.availableActions = SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsCopyLink | SVWebViewControllerAvailableActionsMailLink;
        [self presentModalViewController:web animated:YES];
        [web release];
    }
    else if ([link.URL.absoluteString hasPrefix:@"#"]) {
        HotTrendsDetailTableVC *hotVC = [[HotTrendsDetailTableVC alloc] initWithNibName:@"FirstViewController" bundle:nil];
        hotVC.qureyString = [[link.URL.absoluteString substringFromIndex:1] decodeFromURL];;
        [self.navigationController pushViewController:hotVC animated:YES];
        [hotVC release];
    }
}

- (void)textViewTextTapped:(JSCoreTextView *)textView
{
    
}

#pragma mark - View lifecycle

-(void)resetCountLBFrame
{
    countLB.text = [NSString stringWithFormat:@"  :%d     :%d",status.commentsCount,status.retweetsCount];
    CGRect frame;
    frame = countLB.frame;
    CGFloat padding = 320 - frame.origin.x - frame.size.width;
    
    frame = retwitterCountImageView.frame;
    CGSize size = [[NSString stringWithFormat:@"%d",status.retweetsCount] sizeWithFont:[UIFont systemFontOfSize:12.0]];
    frame.origin.x = 320 - padding - size.width - retwitterCountImageView.frame.size.width - 5;
    retwitterCountImageView.frame = frame;
    
    frame = commentCountImageView.frame;
    size = [[NSString stringWithFormat:@"%d     :%d",status.commentsCount,status.retweetsCount] sizeWithFont:[UIFont systemFontOfSize:12.0]];
    frame.origin.x = 320 - padding - size.width - commentCountImageView.frame.size.width - 5;
    commentCountImageView.frame = frame;
}

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
    self.JSContentTF.text = status.text;
    
    timeLB.text = status.timestamp;
    [self resetCountLBFrame];
    
    vipImageView.hidden = !status.user.verified;
    
    avatarImageV.image = avatarImage;
    
    if (_hasImage) {
        contentImageV.image = contentImage;
    }
    if (_haveRetwitterImage) {
        retwitterImageV.image = contentImage;
    }
    if (_hasRetwitter) {
        self.JSRetitterContentTF.text = [NSString stringWithFormat:@"@%@:%@",status.retweetedStatus.user.screenName,status.retweetedStatus.text];
    }
    
    UIBarButtonItem *retwitterBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(replyActionSheet)];
    self.navigationItem.rightBarButtonItem = retwitterBtn;
    [retwitterBtn release];
    
    contentImageV.hidden = !_hasImage;
    contentImageBackgroundView.hidden = !_hasImage;
    retwitterImageV.hidden = !_haveRetwitterImage;
    retwitterImageBackground.hidden = !_haveRetwitterImage;
    retwitterMainV.hidden = !_hasRetwitter;
    
    [self setViewsHeight];
    [self.table setTableHeaderView:headerView];
    
    CGRect frame = table.frame;
    frame.size.height = frame.size.height + REFRESH_FOOTER_HEIGHT;
    table.frame = frame;
}

-(void)viewDidUnload
{
    [self setContentImageBackgroundView:nil];
    [self setRetwitterImageBackground:nil];
    [self setRetwitterCountImageView:nil];
    [self setCommentCountImageView:nil];
    [self setVipImageView:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.contentInset = UIEdgeInsetsOriginal;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didGetComments:) name:MMSinaGotCommentList object:nil];
    [center addObserver:self selector:@selector(didFollowByUserID:) name:MMSinaFollowedByUserIDWithResult object:nil];
    [center addObserver:self selector:@selector(didUnfollowByUserID:) name:MMSinaUnfollowedByUserIDWithResult object:nil];
    [center addObserver:self selector:@selector(mmRequestFailed:) name:MMSinaRequestFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAvatar:)         name:HHNetDataCacheNotification object:nil];
        [center addObserver:self selector:@selector(didCommentAStatus:) name:MMSinaCommentAStatus object:nil];
    if (self.commentArr == nil) {
        [manager getCommentListWithID:status.statusId maxID:nil page:1];
//        [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view]; 
    }
}

-(void)viewWillDisappear:(BOOL)animated 
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(UINib*)commentCellNib
{
    if (commentCellNib == nil) {
        self.commentCellNib = [ZJTCommentCell nib];
    }
    return commentCellNib;
}

- (void)dealloc {
    [_maxID release];
    _maxID = nil;
    self.clickedComment = nil;
    self.JSContentTF = nil;
    self.JSRetitterContentTF = nil;
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
    [contentImageBackgroundView release];
    [retwitterImageBackground release];
    [retwitterCountImageView release];
    [commentCountImageView release];
    [vipImageView release];
    [super dealloc];
}

#pragma mark - Methods
-(void)replyActionSheet
{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"转发",@"评论", nil];
    as.tag = kStatusReplyActionSheet;
    [as showInView:self.view];
    [as release];
}

-(void)setViewsHeight
{
    //博文Text
    CGRect frame;
    [self adjustTheHeightOf:self.JSContentTF withText:self.JSContentTF.text];
    
    //转发博文Text
    [self adjustTheHeightOf:self.JSRetitterContentTF withText:self.JSRetitterContentTF.text];
    
    //转发博文Text
    //size
//    frame = retwitterTF.frame;
//    frame.size = retwitterTF.contentSize;
//    frame.origin = CGPointMake(10, 0);
//    retwitterTF.frame = frame;
    
    
    //转发的图片
    //origin
    frame = retwitterImageV.frame;
    frame.origin.y = self.JSRetitterContentTF.frame.size.height + 8;
    CGSize size = [self getFrameOfImageView:retwitterImageV].size;
    
    float zoom = 2 * size.width > size.height ? 250.0/size.width : 300.0/size.height;
    size = CGSizeMake(size.width * zoom, size.height * zoom);
    
    frame.size = size;
    retwitterImageV.frame = frame;
    retwitterImageV.center = CGPointMake(160, retwitterImageV.center.y);
    frame = retwitterImageV.frame;
    retwitterImageBackground.frame = CGRectMake(frame.origin.x - 5, frame.origin.y - 5, frame.size.width + 10, frame.size.height + 10);
    
    //正文的图片
    //origin
    frame = contentImageV.frame;
    frame.origin.y = self.JSContentTF.frame.size.height + self.JSContentTF.frame.origin.y + 8.0f;
    size = [self getFrameOfImageView:contentImageV].size;
    
    zoom = size.width > size.height ? 250.0/size.width : 250.0/size.height;
    size = CGSizeMake(size.width * zoom, size.height * zoom);
    
    frame.size = size;
    contentImageV.frame = frame;
    contentImageV.center = CGPointMake(160, contentImageV.center.y);
    frame = contentImageV.frame;
    contentImageBackgroundView.frame = CGRectMake(frame.origin.x - 5, frame.origin.y - 5, frame.size.width + 10, frame.size.height + 10);;
    
    //转发的主View
    frame = retwitterMainV.frame;
    //size
    if (_haveRetwitterImage)    frame.size.height = self.JSRetitterContentTF.frame.size.height + retwitterImageBackground.frame.size.height + 18;
    else                        frame.size.height = self.JSRetitterContentTF.frame.size.height + 10;
    //origin
    if(_hasImage)               frame.origin.y = self.JSContentTF.frame.size.height + self.JSContentTF.frame.origin.y + contentImageBackgroundView.frame.size.height + 18;
    else                        frame.origin.y = self.JSContentTF.frame.size.height + self.JSContentTF.frame.origin.y ;
    retwitterMainV.frame = frame;
    
    //headerView
    frame = headerView.frame;
    if (_hasRetwitter) {
        frame.size.height = retwitterMainV.frame.origin.y + retwitterMainV.frame.size.height + 37;
    }
    else {
        frame.size.height = retwitterMainV.frame.origin.y + 27;
    }
    headerView.frame = frame;
    
    //背景设置
//    headerBackgroundView.image = [[UIImage imageNamed:@"table_header_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:5];
    mainViewBackView.image = [[UIImage imageNamed:@"timeline_rt_border.png"] stretchableImageWithLeftCapWidth:130 topCapHeight:14];
    contentImageBackgroundView.image = [[UIImage imageNamed:@"detail_image_background.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:50];
    retwitterImageBackground.image = [[UIImage imageNamed:@"detail_image_background.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:50];
}

- (void)refresh {
    [manager getCommentListWithID:status.statusId maxID:_maxID page:_page];
//    [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view]; 
}

-(void)follow
{
    if (user.following == YES) {
        [manager unfollowByUserID:user.userId inTableView:@""];
    }
    else {
        [manager followByUserID:user.userId inTableView:@""];
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

- (IBAction)gotoProfileView:(id)sender 
{
    if (isFromProfileVC) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
//    ProfileVC *profile = [[ProfileVC alloc]initWithNibName:@"ProfileVC" bundle:nil];
//    profile.userID = [NSString stringWithFormat:@"%lld",self.user.userId];
//    profile.user = self.user;
//    profile.avatarImage = self.avatarImage;
//    [self.navigationController pushViewController:profile animated:YES];
//    [profile release];
    ZJTProfileViewController *profile = [[ZJTProfileViewController alloc]initWithNibName:@"ZJTProfileViewController" bundle:nil];
    profile.user = user;
    profile.hidesBottomBarWhenPushed = YES;
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
        NSMutableArray *arr = [dic objectForKey:@"commentArrary"];
        
        if (commentArr == nil) {
            self.commentArr = arr;
        }
        else {
            [commentArr addObjectsFromArray:arr];
        }
        _page++;
        if (_maxID == nil && commentArr.count != 0) {
            Comment *com = [commentArr objectAtIndex:0];
            _maxID = [[NSString stringWithFormat:@"%lld",com.commentId] retain];
        }
        if (commentArr != nil && ![commentArr isEqual:[NSNull null]]) 
        {
            NSNumber *count = [dic objectForKey:@"count"];
            status.commentsCount = [count intValue];
            [self resetCountLBFrame];
        }
        [[SHKActivityIndicator currentIndicator]hide];
//        [[ZJTStatusBarAlertWindow getInstance] hide];
        [table reloadData];
        [self stopLoading];
        [self performSelector:@selector(refreshVisibleCellsImages) withObject:nil afterDelay:0.5];
    }
}

-(void)dismissAlert:(id)sender
{
    NSTimer *timer = sender;
    if ([timer.userInfo isKindOfClass:[UIAlertView class]]) {
        UIAlertView *alert = timer.userInfo;
        
        if (alert) {
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            [alert release];
        }
    }
}

-(void)didCommentAStatus:(NSNotification*)sender
{
    NSDictionary *dic = sender.object;
}

-(void)didFollowByUserID:(NSNotification*)sender
{
    NSDictionary *dic = sender.object;
    NSNumber *result = [dic objectForKey:@"result"];
    if (result.intValue == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"关注成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(dismissAlert:) userInfo:alert repeats:NO];
    }
    
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
    
    if (index >= [commentArr count]) {
        //        NSLog(@"statues arr error ,index = %d,count = %d",index,[statuesArr count]);
        return;
    }
    
    Comment  *comment = [commentArr objectAtIndex:index];
    User *theUser = comment.user;
    
    ZJTCommentCell *cell = (ZJTCommentCell *)[self.table cellForRowAtIndexPath:comment.cellIndexPath];
    
    //得到的是头像图片
    if ([url isEqualToString:theUser.profileImageUrl]) 
    {
        theUser.avatarImage = image;
        cell.avatarImage.image = theUser.avatarImage;
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
    cell.vipImageView.hidden = !comment.user.verified;
    comment.cellIndexPath = indexPath;
    
    if (self.table.dragging == NO && self.table.decelerating == NO)
    {
        if (comment.user.avatarImage == nil) 
        {
            [[HHNetDataCacheManager getInstance] getDataWithURL:status.user.profileImageUrl withIndex:row];
        }
    }
    cell.avatarImage.image = comment.user.avatarImage;
    
    CGRect frame = cell.contentLB.frame;
    frame.size.height = [self cellHeight:comment.text with:228.];
    cell.contentLB.frame = frame;
    
    cell.timeLB.text = comment.timestamp;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger  row = indexPath.row;
    Comment *comment = [commentArr objectAtIndex:row];
    CGFloat height = 0.0f;
    height = [self cellHeight:comment.text with:228.0f] + 42.;
    if (height < 66.) {
        height = 66.;
    }
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    self.clickedComment = [commentArr objectAtIndex:row];
    
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"回复",@"查看资料",@"关注", nil];
    as.tag = kCommentClickActionSheet;
    [as showInView:self.view];
    [as release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == kCommentClickActionSheet) {
        User *theUser = clickedComment.user;
        NSLog(@"%dtheUser name = %@",buttonIndex,theUser.screenName);
        if (buttonIndex == kReplyComment) {
            
        }
        else if (buttonIndex == kViewUserProfile) {
            ZJTProfileViewController *profile = [[ZJTProfileViewController alloc]initWithNibName:@"ZJTProfileViewController" bundle:nil];
            profile.user = theUser;
            profile.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:profile animated:YES];
            [profile release];
        }
        else if(buttonIndex == kFollowTheUser){
            [manager followByUserID:theUser.userId inTableView:@""];
        }
    }
    else if (actionSheet.tag == kStatusReplyActionSheet)
    {
        if (buttonIndex == kRetweet) {
            TwitterVC *tv = [[TwitterVC alloc]initWithNibName:@"TwitterVC" bundle:nil];
            [self.navigationController pushViewController:tv animated:YES];
            [tv setupForRepost:[NSString stringWithFormat:@"%lld",self.status.statusId]];
            [tv release];
        }
        else if(buttonIndex == kComment)
        {
            TwitterVC *tv = [[TwitterVC alloc]initWithNibName:@"TwitterVC" bundle:nil];
            [self.navigationController pushViewController:tv animated:YES];
            [tv setupForComment:[NSString stringWithFormat:@"%lld",clickedComment.commentId] 
                        weiboID:[NSString stringWithFormat:@"%lld",self.status.statusId]];
            [tv release];
        }
    }
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
        [browserView zoomToFit];
        contentImageV.image = img;
        
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

#pragma mark - Swipe Gesture delegate

- (IBAction)popViewC:(id)sender 
{
    [self.navigationController popViewControllerAnimated:YES];
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
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    if (!decelerate)
	{
        [self refreshVisibleCellsImages];
    }
}


@end
