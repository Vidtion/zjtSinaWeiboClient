//
//  StatusCell.m
//  zjtSinaWeiboClient
//
//  Created by jianting zhu on 12-1-5.
//  Copyright (c) 2012年 Dunbar Science & Technology. All rights reserved.
//

#import "StatusCell.h"
#import "AHMarkedHyperlink.h"

@implementation StatusCell
@synthesize retwitterBgImage;
@synthesize retwitterContentTF;
@synthesize retwitterContentImage;
@synthesize countLB;
@synthesize avatarImage;
@synthesize contentTF;
@synthesize userNameLB;
@synthesize bgImage;
@synthesize contentImage;
@synthesize retwitterMainV;
@synthesize delegate;
@synthesize cellIndexPath;
@synthesize fromLB;
@synthesize timeLB;
@synthesize vipImageView;
@synthesize commentCountImageView;
@synthesize retweetCountImageView;
@synthesize haveImageFlagImageView;
@synthesize JSContentTF = _JSContentTF;
@synthesize JSRetitterContentTF = _JSRetitterContentTF;

-(JSTwitterCoreTextView*)JSContentTF
{
    
    if (_JSContentTF == nil) {
        _JSContentTF = [[JSTwitterCoreTextView alloc] initWithFrame:CGRectMake(40, 20, 280, 80)];
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
        [self.contentView addSubview:_JSContentTF];
    }
    
    return _JSContentTF;
}

-(JSTwitterCoreTextView*)JSRetitterContentTF
{    
    if (_JSRetitterContentTF == nil) {
        _JSRetitterContentTF = [[JSTwitterCoreTextView alloc] initWithFrame:CGRectMake(10, 0, 270, 80)];
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

-(void)updateCellTextWith:(Status*)status
{
    self.contentTF.text = status.text;
    self.JSContentTF.text = status.text;
    self.userNameLB.text = status.user.screenName;
    countLB.text = [NSString stringWithFormat:@"  :%d     :%d",status.commentsCount,status.retweetsCount];
    fromLB.text = [NSString stringWithFormat:@"来自:%@",status.source];
    timeLB.text = status.timestamp;
    
    Status  *retwitterStatus    = status.retweetedStatus;
    User *theUser = status.user;
    
    vipImageView.hidden = !theUser.verified;
    BOOL haveImage = NO;
    
    CGRect frame;
    frame = countLB.frame;
    CGFloat padding = 320 - frame.origin.x - frame.size.width;
    
    frame = retweetCountImageView.frame;
    CGSize size = [[NSString stringWithFormat:@"%d",status.retweetsCount] sizeWithFont:[UIFont systemFontOfSize:12.0]];
    frame.origin.x = 320 - padding - size.width - retweetCountImageView.frame.size.width - 5;
    retweetCountImageView.frame = frame;
    
    frame = commentCountImageView.frame;
    size = [[NSString stringWithFormat:@"%d     :%d",status.commentsCount,status.retweetsCount] sizeWithFont:[UIFont systemFontOfSize:12.0]];
    frame.origin.x = 320 - padding - size.width - commentCountImageView.frame.size.width - 5;
    commentCountImageView.frame = frame;
    
    //有转发
    if (retwitterStatus && ![retwitterStatus isEqual:[NSNull null]]) 
    {
        self.retwitterMainV.hidden = NO;
        self.JSRetitterContentTF.text = [NSString stringWithFormat:@"@%@:%@",status.retweetedStatus.user.screenName,retwitterStatus.text];
        self.contentImage.hidden = YES;
        
        NSString *url = status.retweetedStatus.thumbnailPic;
        self.retwitterContentImage.hidden = url != nil && [url length] != 0 ? NO : YES;
        haveImage = !self.retwitterContentImage.hidden;
        [self setTFHeightWithImage:NO 
                haveRetwitterImage:url != nil && [url length] != 0 ? YES : NO];//计算cell的高度，以及背景图的处理
    }
    
    //无转发
    else
    {
        self.retwitterMainV.hidden = YES;
        NSString *url = status.thumbnailPic;
        self.contentImage.hidden = url != nil && [url length] != 0 ? NO : YES;
        haveImage = !self.contentImage.hidden;
        [self setTFHeightWithImage:url != nil && [url length] != 0 ? YES : NO 
                haveRetwitterImage:NO];//计算cell的高度，以及背景图的处理
    }
    haveImageFlagImageView.hidden = !haveImage;
}

//计算cell的高度，以及背景图的处理
-(CGFloat)setTFHeightWithImage:(BOOL)hasImage haveRetwitterImage:(BOOL)haveRetwitterImage
{
    
    //博文Text
    CGRect frame;
    [self adjustTheHeightOf:self.JSContentTF withText:self.JSContentTF.text];
    
    //转发博文Text
    [self adjustTheHeightOf:self.JSRetitterContentTF withText:self.JSRetitterContentTF.text];
    
    frame = timeLB.frame;
    CGSize size = [timeLB.text sizeWithFont:[UIFont systemFontOfSize:13.0]];
    frame.size = size;
    frame.origin.x = 320 - 10 - size.width;
    timeLB.frame = frame;
    
    frame = haveImageFlagImageView.frame;
    frame.origin.x = timeLB.frame.origin.x - haveImageFlagImageView.frame.size.width - 8;
    haveImageFlagImageView.frame = frame;
    
    //转发的主View
    frame = retwitterMainV.frame;
    
    if (haveRetwitterImage) 
        frame.size.height = self.JSRetitterContentTF.frame.size.height + IMAGE_VIEW_HEIGHT + 15;
    else 
        frame.size.height = self.JSRetitterContentTF.frame.size.height + 5;
    
    if(hasImage) 
        frame.origin.y = self.JSContentTF.frame.size.height + self.JSContentTF.frame.origin.y + IMAGE_VIEW_HEIGHT;
    else 
        frame.origin.y = self.JSContentTF.frame.size.height + self.JSContentTF.frame.origin.y;
    
    retwitterMainV.frame = frame;
    
    
    //转发的图片
    frame = retwitterContentImage.frame;
    frame.origin.y = self.JSRetitterContentTF.frame.size.height;
    frame.size.height = IMAGE_VIEW_HEIGHT;
    retwitterContentImage.frame = frame;
    
    //正文的图片
    frame = contentImage.frame;
    frame.origin.y = self.JSContentTF.frame.size.height + self.JSContentTF.frame.origin.y - 5.0f;
    frame.size.height = IMAGE_VIEW_HEIGHT;
    contentImage.frame = frame;
    
    //背景设置
    if (bgImage.image == nil) {
        bgImage.image = [[UIImage imageNamed:@"table_header_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    }
    if (retwitterBgImage.image == nil) {
        retwitterBgImage.image = [[UIImage imageNamed:@"timeline_rt_border.png"] stretchableImageWithLeftCapWidth:130 topCapHeight:14];
    }
    if (retwitterMainV.hidden == NO) {
        return self.retwitterMainV.frame.size.height + self.retwitterMainV.frame.origin.y + 25;
    }
    else if(hasImage)
    {
        return self.contentImage.frame.size.height + self.contentImage.frame.origin.y + 35;
    }
    else {
        return self.JSContentTF.frame.size.height + self.JSContentTF.frame.origin.y + 35;
    }
}

-(IBAction)tapDetected:(id)sender
{
    UITapGestureRecognizer*tap = (UITapGestureRecognizer*)sender;
    
    UIImageView *imageView = (UIImageView*)tap.view;
    if ([imageView isEqual:contentImage]) {
        if ([delegate respondsToSelector:@selector(cellImageDidTaped:image:)]) 
        {
            [delegate cellImageDidTaped:self image:contentImage.image];
        }
    }
    else if ([imageView isEqual:retwitterContentImage])
    {
        if ([delegate respondsToSelector:@selector(cellImageDidTaped:image:)])
        {
            [delegate cellImageDidTaped:self image:retwitterContentImage.image];
        }
    }
}

- (void)textView:(JSCoreTextView *)textView linkTapped:(AHMarkedHyperlink *)link
{
    NSLog(@"%@",link.URL.absoluteString);
    if ([self.delegate respondsToSelector:@selector(cellLinkDidTaped:link:)]) {
        [self.delegate cellLinkDidTaped:self link:link.URL.absoluteString];
    }
}

- (void)textViewTextTapped:(JSCoreTextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(cellTextDidTaped:)]) {
        [self.delegate cellTextDidTaped:self];
    }
}

- (void)dealloc {
    self.JSRetitterContentTF = nil;
    self.JSContentTF = nil;
    [avatarImage release];
    [contentTF release];
    [userNameLB release];
    [bgImage release];
    [contentImage release];
    [retwitterMainV release];
    [retwitterBgImage release];
    [retwitterContentTF release];
    [retwitterContentImage release];
    [cellIndexPath release];
    [countLB release];
    [fromLB release];
    [timeLB release];
    [vipImageView release];
    [commentCountImageView release];
    [retweetCountImageView release];
    [haveImageFlagImageView release];
    [super dealloc];
}
@end
