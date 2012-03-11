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

@interface ZJTDetailStatusVC ()
-(void)setViewsHeight;
@end


@implementation ZJTDetailStatusVC
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        _hasRetwitter = NO;
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
    _hasRetwitter   = status.hasRetwitter;
    _hasImage       = status.hasImage;
    _haveRetwitterImage = status.haveRetwitterImage;
    
    [self.table setTableHeaderView:headerView];
    
    twitterNameLB.text = user.screenName;
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
    
    contentImageV.hidden = !_hasImage;
    retwitterImageV.hidden = !_haveRetwitterImage;
    retwitterMainV.hidden = !_hasRetwitter;
    
    [manager getCommentListWithID:status.statusId];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(didGetComments:) name:MMSinaGotCommentList object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center removeObserver:self name:MMSinaGotCommentList object:nil];
}

- (void)viewDidUnload
{
    [self setHeaderView:nil];
    [self setTable:nil];
    [self setAvatarImageV:nil];
    [self setTwitterNameLB:nil];
    [self setContentTF:nil];
    [self setContentImageV:nil];
    [self setRetwitterMainV:nil];
    [self setRetwitterTF:nil];
    [self setRetwitterImageV:nil];
    [self setTimeLB:nil];
    [self setCountLB:nil];
    
    [super viewDidUnload];
}

-(UINib*)commentCellNib
{
    if (commentCellNib == nil) {
        self.commentCellNib = [ZJTCommentCell nib];
    }
    return commentCellNib;
}

- (void)dealloc {
    [headerView release];
    [table release];
    [avatarImageV release];
    [twitterNameLB release];
    [contentTF release];
    [contentImageV release];
    [retwitterMainV release];
    [retwitterTF release];
    [retwitterImageV release];
    [timeLB release];
    [countLB release];
    
    self.commentCellNib = nil;
    self.status = nil;
    self.user = nil;
    self.avatarImage = nil;
    self.contentImage = nil;
    self.commentArr = nil;
    [super dealloc];
}

#pragma mark - Methods
-(void)setViewsHeight
{
    [contentTF layoutIfNeeded];
    
//    CGRect frame = contentTF.frame;
//    frame.size.height = [ZJTHelpler getTextViewHeight:contentTF.text with:320.0f sizeOfFont:14 addtion:0];
    
    //博文Text
    CGRect frame = contentTF.frame;
    frame.size = contentTF.contentSize;
    contentTF.frame = frame;
    
    //转发博文Text
    frame = retwitterTF.frame;
    frame.size = retwitterTF.contentSize;
    retwitterTF.frame = frame;
    
    //转发的主View
    frame = retwitterMainV.frame;
    if (_haveRetwitterImage) frame.size.height = retwitterTF.frame.size.height + IMAGE_VIEW_HEIGHT + 15;
    else frame.size.height = retwitterTF.frame.size.height + 15;
    if(_hasImage) frame.origin.y = contentTF.frame.size.height + contentTF.frame.origin.y + IMAGE_VIEW_HEIGHT;
    else frame.origin.y = contentTF.frame.size.height + contentTF.frame.origin.y;
    retwitterMainV.frame = frame;
    

    
//    //博文Text
//    CGRect frame = contentTF.frame;
//    frame.size = contentTF.contentSize;
//    contentTF.frame = frame;
//    
//    //转发博文Text
//    frame = retwitterContentTF.frame;
//    frame.size = retwitterContentTF.contentSize;
//    retwitterContentTF.frame = frame;
//    
//    
//    //转发的主View
//    frame = retwitterMainV.frame;
//    
//    if (haveRetwitterImage) frame.size.height = retwitterContentTF.frame.size.height + IMAGE_VIEW_HEIGHT + 15;
//    else frame.size.height = retwitterContentTF.frame.size.height + 15;
//    
//    if(hasImage) frame.origin.y = contentTF.frame.size.height + contentTF.frame.origin.y + IMAGE_VIEW_HEIGHT;
//    else frame.origin.y = contentTF.frame.size.height + contentTF.frame.origin.y;
//    
//    retwitterMainV.frame = frame;
//    
//    
//    //转发的图片
//    frame = retwitterContentImage.frame;
//    frame.origin.y = retwitterContentTF.frame.size.height;
//    retwitterContentImage.frame = frame;
//    
//    //正文的图片
//    frame = contentImage.frame;
//    frame.origin.y = contentTF.frame.size.height + contentTF.frame.origin.y - 5.0f;
//    contentImage.frame = frame;
//    
//    //背景设置
//    bgImage.image = [[UIImage imageNamed:@"table_header_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
//    retwitterBgImage.image = [[UIImage imageNamed:@"timeline_rt_border_t.png"] stretchableImageWithLeftCapWidth:130 topCapHeight:7];
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
        [table reloadData];
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
        NSLog(@"cellForRowAtIndexPath error ,index = %d,count = %d",row,[commentArr count]);
        return cell;
    }
    
    Comment *comment = [commentArr objectAtIndex:row];
    
    cell.nameLB.text = comment.user.screenName;
    cell.contentLB.text = comment.text;
    cell.timeLB.text = comment.timestamp;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94;
}


@end
