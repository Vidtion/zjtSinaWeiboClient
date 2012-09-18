//
//  ZJTStatusBarAlertWindow.m
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-5-5.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import "ZJTStatusBarAlertWindow.h"

static ZJTStatusBarAlertWindow *instance = nil;

@interface ZJTStatusBarAlertWindow()
-(void)setupViewsAndDatas;
-(void)removeViewsAndDatas;
@end

@implementation ZJTStatusBarAlertWindow
@synthesize window = _window;
@synthesize label = _label;
@synthesize backgroundImage = _backgroundImage;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize displayString = _displayString;

-(void)dealloc
{
    [self removeViewsAndDatas];
    [super dealloc];
}

#pragma mark - Setter & Getter
-(NSString*)displayString
{
    if (_label == nil) {
        NSLog(@"label == nil");
        return nil;
    }
    return _label.text;
}

-(void)setDisplayString:(NSString *)displayString
{
    if (![displayString isEqualToString:_displayString]) 
    {
        [_displayString release];
        _displayString = [displayString copy];
        
        if (_label != nil) {
            _label.text = displayString;
            _window.windowLevel = UIWindowLevelAlert;
            [_window makeKeyAndVisible];
        }
    }
}

-(void)setBackgroundImage:(UIImage *)backgroundImage
{
    if (![backgroundImage isEqual:_backgroundImageView]) {
        [_backgroundImage release];
        _backgroundImage = [backgroundImage retain];
        
        if (_backgroundImageView != nil) {
            _backgroundImageView.image = backgroundImage;
        }
    }
}

#pragma mark - Initialize
-(id)init
{
    self = [super init];
    if (self) {
//        [self setupViewsAndDatas];
    }
    return self;
}

+(ZJTStatusBarAlertWindow *) getInstance{
    @synchronized(self) {
        if (instance == nil) {
            instance = [[ZJTStatusBarAlertWindow alloc] init];
        }
    }
    return instance;
}

#pragma mark -Instance Methods
-(void)setupViewsAndDatas
{
    CGRect statusBarFrame = CGRectMake(0, 0, 320, 20);
    
    //windows
    [_window release];
    _window = [[UIWindow alloc]initWithFrame:CGRectMake(0, -20, 320, 20)];
    _window.tag = 1;
    _window.windowLevel = UIWindowLevelAlert;
    _window.backgroundColor = [UIColor blackColor];
    
    //backgroundImage
    self.backgroundImage = [[UIImage imageNamed:@"statusbar_background.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:0]; 
    
    //backgroundImageView
    [_backgroundImageView release];
    _backgroundImageView = [[UIImageView alloc] initWithFrame:statusBarFrame];
    _backgroundImageView.image = _backgroundImage;
    
    //label
    [_label release];
    _label = [[UILabel alloc] initWithFrame:statusBarFrame];
    _label.textAlignment        = UITextAlignmentCenter;
    _label.textColor            = [UIColor blackColor];
    _label.backgroundColor      = [UIColor clearColor];
    _label.adjustsFontSizeToFitWidth = YES;
    _label.minimumFontSize      = 5.0;
    
    //views struct
    [_window addSubview:_backgroundImageView];
    [_window addSubview:_label];
    [_window makeKeyAndVisible];
}

-(void)removeViewsAndDatas
{
    _window.windowLevel = UIWindowLevelNormal;
    self.backgroundImage = nil;
    self.displayString = nil;
    self.label = nil;
    self.backgroundImageView = nil;
    self.window = nil;
}

-(void)showWithString:(NSString*)string
{
//    self.displayString = string;
//    if (_window) {
//        _window.windowLevel = UIWindowLevelAlert;
//    }
//    
//    if ((_window && _window.frame.origin.y == 0) ){//|| [string isEqualToString:_displayString]) {
//        return;
//    }
//    
//    if (!_window) {
//        [self setupViewsAndDatas];
//        self.displayString = string;
//    }
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
//    
//    //animation
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:.6];
//    _window.frame = CGRectMake(0, 0, 320, 20);
//    [UIView commitAnimations];
}

-(void)hide
{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:.6];
//    _window.frame = CGRectMake(0, -20, 320, 20);
//    [UIView commitAnimations];
//    
//    UIApplication *app = [UIApplication sharedApplication];
//    UIWindow *window = nil;
//    for (UIWindow *win in app.windows) {
//        if (win.tag == 0) {
//            window = win;
//            [window makeKeyAndVisible];
//        }
//    }
    
}

@end
