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
@synthesize JSContentTF = _JSContentTF;
@synthesize JSRetitterContentTF = _JSRetitterContentTF;

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

-(JSTwitterCoreTextView*)JSContentTF
{
    
    if (_JSContentTF == nil) {
        _JSContentTF = [[JSTwitterCoreTextView alloc] initWithFrame:CGRectMake(0, 58, 320, 80)];
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
        ProfileVC *profile = [[ProfileVC alloc]initWithNibName:@"ProfileVC" bundle:nil];
        profile.screenName = sn;
        profile.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:profile animated:YES];
        [profile release];
    }
    
    if ([link.URL.absoluteString hasPrefix:@"http"]) {
        SVModalWebViewController *web = [[SVModalWebViewController alloc] initWithURL:link.URL];
        web.modalPresentationStyle = UIModalPresentationPageSheet;
        web.availableActions = SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsCopyLink | SVWebViewControllerAvailableActionsMailLink;
        [self presentModalViewController:web animated:YES];
        [web release];
    }
}

- (void)textViewTextTapped:(JSCoreTextView *)textView
{
    
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
    self.JSContentTF.text = status.text;
    
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
        self.JSRetitterContentTF.text = [NSString stringWithFormat:@"@%@:%@",status.retweetedStatus.user.screenName,status.retweetedStatus.text];
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
    [super dealloc];
}

#pragma mark - Methods
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
    
    //转发的主View
    frame = retwitterMainV.frame;
    //size
    if (_haveRetwitterImage)    frame.size.height = self.JSRetitterContentTF.frame.size.height + IMAGES_VIEW_HEIGHT + 10;
    else                        frame.size.height = self.JSRetitterContentTF.frame.size.height + 10;
    //origin
    if(_hasImage)               frame.origin.y = self.JSContentTF.frame.size.height + self.JSContentTF.frame.origin.y + IMAGES_VIEW_HEIGHT;
    else                        frame.origin.y = self.JSContentTF.frame.size.height + self.JSContentTF.frame.origin.y ;
    retwitterMainV.frame = frame;
    
    //转发的图片
    //origin
    frame = retwitterImageV.frame;
    frame.origin.y = self.JSRetitterContentTF.frame.size.height;
    frame.size.height = IMAGES_VIEW_HEIGHT;
    retwitterImageV.frame = frame;
    
    //正文的图片
    //origin
    frame = contentImageV.frame;
    frame.origin.y = self.JSContentTF.frame.size.height + self.JSContentTF.frame.origin.y - 5.0f;
    frame.size.height = IMAGES_VIEW_HEIGHT;
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
    mainViewBackView.image = [[UIImage imageNamed:@"timeline_rt_border.png"] stretchableImageWithLeftCapWidth:130 topCapHeight:14];
}

- (void)refresh {
    [manager getCommentListWithID:status.statusId];
    [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view]; 
//    [[ZJTStatusBarAlertWindow getInstance] showWithString:@"正在载入，请稍后..."];
}

-(void)follow
{
    if (user.following == YES) {
        [manager unfollowByUserID:user.userId inTableView:nil];
    }
    else {
        [manager followByUserID:user.userId inTableView:nil];
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
        [[SHKActivityIndicator currentIndicator]hide];
//        [[ZJTStatusBarAlertWindow getInstance] hide];
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
