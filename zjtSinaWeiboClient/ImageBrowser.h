//
//  ImageBrowser.h
//  HHuan
//
//  Created by jtone on 11-8-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomScrollView.h"

#define GIF_VIEW_TAG 9999

@protocol ImageBrowserDelegate <NSObject>
-(void)browserDidGetOriginImage:(NSDictionary*)dic;
@end

@interface ImageBrowser : UIView <UIScrollViewDelegate>
{
    IBOutlet UIImageView        *imageView;
    IBOutlet CustomScrollView   *aScrollView;
    UIImage *image;
    NSString * bigImageURL;//如果填了这个地址，登录后会载入此图片
    NSString *viewTitle;
    id<ImageBrowserDelegate> theDelegate;
}
@property (nonatomic,retain) UIImage *image;
@property (nonatomic,retain) IBOutlet UIImageView        *imageView;
@property (nonatomic,retain) IBOutlet CustomScrollView   *aScrollView;
@property (nonatomic,retain) NSString * bigImageURL;
@property (nonatomic,copy) NSString *viewTitle;
@property (nonatomic,assign) id<ImageBrowserDelegate> theDelegate;

-(void)setUp;
-(void)loadImage;
-(void)dismiss;
-(void)zoomToFit;

@end
