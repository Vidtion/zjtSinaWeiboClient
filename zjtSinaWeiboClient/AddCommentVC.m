//
//  AddCommentVC.m
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-3-28.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import "AddCommentVC.h"
#import "WeiBoMessageManager.h"

@interface AddCommentVC ()

@end

@implementation AddCommentVC
@synthesize imageV;
@synthesize contentV;
@synthesize contentStr;
@synthesize weiboID;
@synthesize status;
@synthesize vctype = _vctype;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _vctype = kRepost;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imageV.image = [[UIImage imageNamed:@"input_window.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:20];
    self.contentV.text = contentStr;
    
    UIBarButtonItem *sendBtn;
    
    //回复微博
    if (_vctype == kReplyAStatus) {
        sendBtn = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(commentStatus)];
        self.title = @"回复微博";
    }
    
    //转发
    else if(_vctype == kRepost){
        sendBtn = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(repost)];
        self.title = @"转发微博";
    }
    
    //回复评论
    else{
        sendBtn = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(commentComment)];
        self.title = @"回复评论";
    }

    self.navigationItem.rightBarButtonItem = sendBtn;
    [sendBtn release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetRepostResult:) name:MMSinaGotRepost object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [contentV becomeFirstResponder];
}

- (void)viewDidUnload
{
    [self setImageV:nil];
    [self setContentV:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MMSinaGotRepost object:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    [imageV release];
    [contentV release];
    self.contentStr = nil;
    self.weiboID = nil;
    self.status = nil;
    [super dealloc];
}

-(void)didGetRepostResult:(NSNotification*)sender
{
    
}

//转发
-(void)repost
{
    [[WeiBoMessageManager getInstance] repost:weiboID content:contentV.text withComment:0];
}

//回复微博
-(void)commentStatus
{
//    [[WeiBoMessageManager getInstance]
}

//回复评论
-(void)commentComment
{
//    [[WeiBoMessageManager getInstance]
}
@end
