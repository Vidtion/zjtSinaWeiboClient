//
//  ImageBrowser.m
//  HHuan
//
//  Created by jtone on 11-8-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ImageBrowser.h"
#import "HHNetDataCacheManager.h"

@implementation ImageBrowser
@synthesize image;
@synthesize imageView;
@synthesize aScrollView;
@synthesize bigImageURL;
@synthesize viewTitle;
@synthesize delegate;

- (void)dealloc
{
    self.imageView = nil;
    self.image = nil;
    self.aScrollView = nil;
    self.viewTitle = nil;
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        aScrollView = [[CustomScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        aScrollView.userInteractionEnabled = YES;
        
        [self           addSubview:aScrollView];
        [aScrollView    addSubview:imageView];
    }
    return self;
}

-(void)dismiss
{
    [UIView beginAnimations:nil context:nil];		
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self removeFromSuperview];
    [UIView commitAnimations]; 
}

-(void)saveImage
{
    if (!imageView.image) 
    {
        return;
    }
    UIImageWriteToSavedPhotosAlbum(imageView.image, nil, nil, nil);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"ImageSaveSucced" delegate:self cancelButtonTitle:@"Sure" otherButtonTitles:nil];
    [alert show];
    [alert release];
}


#pragma mark - View lifecycle
-(void)setUp
{
    aScrollView.minimumZoomScale = 1.0; //最小到1.0倍
    aScrollView.maximumZoomScale = 50.0; //最大到50倍
    aScrollView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doubelClicked) name:@"doubelClicked"  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss)       name:@"tapClicked"     object:nil];
    UIBarButtonItem *rightButton=[[UIBarButtonItem alloc] initWithTitle:@"保存到相册" style:UIBarButtonItemStylePlain target:self action:@selector(saveImage)];
    [rightButton release];
    
    [imageView setImage:image];
    [[NSNotificationCenter defaultCenter] addObserver:delegate selector:@selector(getOriginImage:) name:HHNetDataCacheNotification object:nil];
    if (bigImageURL!=nil) {
        [[HHNetDataCacheManager getInstance] getDataWithURL:bigImageURL];
    }
}

-(void)doubelClicked{
    if (aScrollView.zoomScale == 1.0) {
        [UIView beginAnimations:nil context:nil];		
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [aScrollView zoomToRect:CGRectMake(aScrollView.touchedPoint.x-50, aScrollView.touchedPoint.y-50, 100, 100) animated:YES];
        [UIView commitAnimations]; 
    }
    else{
        [UIView beginAnimations:nil context:nil];		
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationBeginsFromCurrentState:YES];
        aScrollView.zoomScale = 1.0;
        [UIView commitAnimations]; 
    }    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;
}

- (void) getImageAck:(NSNotification*) hhack
{
    NSDictionary * dic=hhack.object;
    NSString * url=[dic objectForKey:HHNetDataCacheURLKey];
    if ([url isEqualToString:bigImageURL]) {
        UIImage * img=[UIImage imageWithData:[dic objectForKey:HHNetDataCacheData]];
        [imageView setImage:img];
    }
}

@end
