//
//  StatusCell.h
//  zjtSinaWeiboClient
//
//  Created by jianting zhu on 12-1-5.
//  Copyright (c) 2012年 Dunbar Science & Technology. All rights reserved.
//

#import "LPBaseCell.h"
#import "Status.h"
#import "User.h"
#import "JSTwitterCoreTextView.h"

#define IMAGE_VIEW_HEIGHT 80.0f
#define PADDING_TOP 8.0
#define PADDING_LEFT 8.0
#define FONT_SIZE 15.0
#define FONT @"Helvetica"

@class StatusCell;

@protocol StatusCellDelegate <NSObject>

-(void)cellImageDidTaped:(StatusCell *)theCell image:(UIImage*)image;
-(void)cellLinkDidTaped:(StatusCell *)theCell link:(NSString*)link;
-(void)cellTextDidTaped:(StatusCell *)theCell;

@end

@interface StatusCell : LPBaseCell <JSCoreTextViewDelegate>
{
    id<StatusCellDelegate> delegate;
    
    UIImageView *avatarImage;
    JSTwitterCoreTextView *_JSContentTF;
    UITextView *contentTF;
    UILabel *userNameLB;
    UIImageView *bgImage;
    UIImageView *contentImage;
    UIView *retwitterMainV;
    UIImageView *retwitterBgImage;
    UITextView *retwitterContentTF;
    JSTwitterCoreTextView *_JSRetitterContentTF;
    UIImageView *retwitterContentImage;
    NSIndexPath *cellIndexPath;
}
@property (retain, nonatomic) IBOutlet UILabel *countLB;
@property (retain, nonatomic) IBOutlet UIImageView *avatarImage;
@property (retain, nonatomic) IBOutlet UITextView *contentTF;
@property (retain, nonatomic) IBOutlet UILabel *userNameLB;
@property (retain, nonatomic) IBOutlet UIImageView *bgImage;
@property (retain, nonatomic) IBOutlet UIImageView *contentImage;
@property (retain, nonatomic) IBOutlet UIView *retwitterMainV;
@property (retain, nonatomic) IBOutlet UIImageView *retwitterBgImage;
@property (retain, nonatomic) IBOutlet UITextView *retwitterContentTF;
@property (retain, nonatomic) IBOutlet UIImageView *retwitterContentImage;
@property (assign, nonatomic) id<StatusCellDelegate> delegate;
@property (retain, nonatomic) NSIndexPath *cellIndexPath;
@property (retain, nonatomic) IBOutlet UILabel *fromLB;
@property (retain, nonatomic) IBOutlet UILabel *timeLB;
@property (retain, nonatomic) IBOutlet UIImageView *vipImageView;
@property (retain, nonatomic) IBOutlet UIImageView *commentCountImageView;
@property (retain, nonatomic) IBOutlet UIImageView *retweetCountImageView;
@property (retain, nonatomic) IBOutlet UIImageView *haveImageFlagImageView;

@property (nonatomic,retain)JSTwitterCoreTextView *JSContentTF;
@property (nonatomic,retain)JSTwitterCoreTextView *JSRetitterContentTF;

-(CGFloat)setTFHeightWithImage:(BOOL)hasImage haveRetwitterImage:(BOOL)haveRetwitterImage;
-(void)updateCellTextWith:(Status*)status;
+(CGFloat)getJSHeight:(NSString*)text jsViewWith:(CGFloat)with;
@end
