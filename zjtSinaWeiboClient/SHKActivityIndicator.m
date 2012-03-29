//
//  SHKActivityIndicator.m
//  ShareKit
//
//  Created by Nathan Weiner on 6/16/10.

//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//

#import "SHKActivityIndicator.h"
#import <QuartzCore/QuartzCore.h>
#import "SHKDefine.h"
#import "UIDevice+Orientation.h"
#import "UILabel+Size.h"

@implementation SHKActivityIndicator

@synthesize centerMessageLabel, subMessageLabel;
@synthesize spinner;
@synthesize modalBackView;


static SHKActivityIndicator *currentIndicator = nil;
//static UIView  *modalBackView = nil;

+ (SHKActivityIndicator *)currentIndicator
{
	if (currentIndicator == nil)
	{
        currentIndicator = [[SHKActivityIndicator alloc] initWithFrame:CGRectMake(160, 100, 120, 120)];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        currentIndicator.center = CGPointMake(CGRectGetMidX(window.bounds), CGRectGetMidY(window.bounds)); 
        
		[[NSNotificationCenter defaultCenter] addObserver:currentIndicator
												 selector:@selector(setProperRotation)
													 name:UIDeviceOrientationDidChangeNotification
												   object:nil];
	}
	
	return currentIndicator;
}

#pragma mark -
- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        
        self.userInteractionEnabled = YES;
        self.alpha = 0;
        
        modalBackView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.bounds) - 60, CGRectGetMidY(self.bounds) - 60, 120, 120)];
        modalBackView.backgroundColor = [UIColor blackColor];
        modalBackView.layer.borderWidth = 2.0f;
        modalBackView.layer.borderColor = [UIColor whiteColor].CGColor;
        modalBackView.layer.cornerRadius = 10;
		modalBackView.alpha = 0.65;
        modalBackView.userInteractionEnabled = NO;
		[self addSubview:modalBackView];
        
        //    self.frame = CGRectMake(0, 0, 480, 320);
//		[self setProperRotation:NO];
        
    }
    
    return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	
    [modalBackView release];
	[centerMessageLabel release];
	[subMessageLabel release];
	[spinner release];
	
	[super dealloc];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
//    modalBackView.frame = CGRectMake(CGRectGetMidX(self.bounds) - 60, 
//                                     CGRectGetMidY(self.bounds) - 60, 
//                                     120, 
//                                     120);
    
    if (spinner) {
        //if ([subMessageLabel.text isEqualToString:@""]) {
            spinner.frame = CGRectMake(round(self.bounds.size.width/2 - spinner.frame.size.width/2),
                                       round(self.frame.size.height / 2 - spinner.frame.size.height/2),
                                       spinner.frame.size.width,
                                       spinner.frame.size.height);

//        }else
//        {
//            spinner.frame = CGRectMake(round(self.bounds.size.width/2 - spinner.frame.size.width/2),
//                                       round(modalBackView.frame.origin.y + spinner.frame.size.height/2),
//                                       spinner.frame.size.width,
//                                       spinner.frame.size.height);
//        }
       
    }
    
    
}

#pragma mark Creating Message

- (void)show
{	
	if ([self superview] != [[UIApplication sharedApplication] keyWindow]) 
    {
		[[[UIApplication sharedApplication] keyWindow] addSubview:self];
	}
    
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	self.alpha = 1;
	
	[UIView commitAnimations];
}

- (void)showInView:(UIView*)view
{	
	if ([self superview] != [[UIApplication sharedApplication] keyWindow]) 
    {
		[view addSubview:self];
	}
    
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	self.alpha = 1;
	
	[UIView commitAnimations];
}

- (void)hideAfterDelay:(NSTimeInterval)delay
{
	[self performSelector:@selector(hide) withObject:nil afterDelay:delay];
}

- (void)hide
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hidden)];
	
	self.alpha = 0;
	
	[UIView commitAnimations];
}

- (void)persist
{	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.1];
	
	self.alpha = 1;
	
	[UIView commitAnimations];
}

- (void)hidden
{
    if (currentIndicator == nil) {
        return;
    }
	if (currentIndicator.alpha > 0)
		return;
	
	[currentIndicator removeFromSuperview];
    [currentIndicator release]; currentIndicator = nil;
}

- (void)displayActivity:(NSString *)m
{		
	[self setSubMessage:m];
	[self showSpinner];	
	
	[centerMessageLabel removeFromSuperview];
	self.centerMessageLabel = nil;
	
	if ([self superview] == nil)
		[self show];
	else
		[self persist];
}

- (void)displayActivity:(NSString *)m inView:(UIView*)view
{		
	[self setSubMessage:m];
	[self showSpinner];	
	
	[centerMessageLabel removeFromSuperview];
	self.centerMessageLabel = nil;
	
	if ([self superview] == nil)
		[self showInView:view];
	else
		[self persist];
    [self setRotationWithOritation:UIDeviceOrientationPortrait animted:NO];
}

- (void)displayCompleted:(NSString *)m
{	
	[self setCenterMessage:@"✓"];
	[self setSubMessage:m];
	
	[spinner removeFromSuperview];
	self.spinner = nil;
	
	if ([self superview] == nil)
		[self show];
	else
		[self persist];
    
	[self hideAfterDelay:1];
}

- (void)setCenterMessage:(NSString *)message
{	
	if (message == nil && centerMessageLabel != nil)
		self.centerMessageLabel = nil;
    
	else if (message != nil)
	{
		if (centerMessageLabel == nil)
		{
            self.centerMessageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(12,modalBackView.bounds.size.height,modalBackView.bounds.size.width-24,50)] autorelease];
			centerMessageLabel.backgroundColor = [UIColor clearColor];
			centerMessageLabel.opaque = NO;
			centerMessageLabel.textColor = [UIColor whiteColor];
			centerMessageLabel.font = [UIFont boldSystemFontOfSize:40];
			centerMessageLabel.textAlignment = UITextAlignmentCenter;
			centerMessageLabel.shadowColor = [UIColor darkGrayColor];
			centerMessageLabel.shadowOffset = CGSizeMake(1,1);
			centerMessageLabel.adjustsFontSizeToFitWidth = YES;
			
			[modalBackView addSubview:centerMessageLabel];
		}
		
		centerMessageLabel.text = message;
	}
}

- (void)setSubMessage:(NSString *)message
{	

	if (message == nil && subMessageLabel != nil)
		self.subMessageLabel = nil;
	
	else if (message != nil)
	{
//        if ([message isEqualToString:@""]) {
            spinner.frame = CGRectMake(round(self.bounds.size.width/2 - spinner.frame.size.width/2),
                                       round(self.frame.size.height / 2 - spinner.frame.size.height/2),
                                       spinner.frame.size.width,
                                       spinner.frame.size.height);
//        }
    
        CGSize messageSize = [message sizeWithFont: [UIFont boldSystemFontOfSize:15]];
        NSUInteger labelWidth = messageSize.width +  20 + 24;
        
        if (labelWidth > 120 && labelWidth < 250) {
            modalBackView.bounds = CGRectMake(0, 0, labelWidth, modalBackView.bounds.size.height);
        }else if(labelWidth > 250)
        {
            modalBackView.bounds = CGRectMake(0, 0, 250, modalBackView.bounds.size.height);
        }
        
        CGSize labelSize = [UILabel calcLabelSizeWithString:message andFont:[UIFont boldSystemFontOfSize:15] maxLines:5 lineWidth:modalBackView.bounds.size.width - 20 - 24];
        
        if (labelWidth <= 120) {
            modalBackView.bounds = CGRectMake(0, 0, modalBackView.bounds.size.width,  modalBackView.bounds.size.width);
        }else
        {
            modalBackView.bounds = CGRectMake(0, 0, modalBackView.bounds.size.width,  labelSize.height + 90);
        }
        
       // self.subMessageLabel.frame = CGRectMake(12,spinner.bounds.size.height + 70,modalBackView.bounds.size.width - 24,labelSize.height + 24);
		if (subMessageLabel == nil)
		{
			self.subMessageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(12,modalBackView.bounds.size.height -  labelSize.height - 10,modalBackView.bounds.size.width - 24,labelSize.height)] autorelease];
			subMessageLabel.backgroundColor = [UIColor clearColor];
			subMessageLabel.opaque = NO;
            subMessageLabel.numberOfLines = 0;
            subMessageLabel.textAlignment = UITextAlignmentCenter;
			subMessageLabel.textColor = [UIColor whiteColor];
			subMessageLabel.font = [UIFont boldSystemFontOfSize:15];
			subMessageLabel.textAlignment = UITextAlignmentCenter;
			subMessageLabel.shadowColor = [UIColor darkGrayColor];
			subMessageLabel.shadowOffset = CGSizeMake(1,1);
			subMessageLabel.adjustsFontSizeToFitWidth = YES;
			
			[modalBackView addSubview:subMessageLabel];
		}
        
		subMessageLabel.text = message;
	}
}

- (void)showSpinner
{	
	if (spinner == nil)
	{
		self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

        spinner.frame = CGRectMake(round(self.bounds.size.width/2 - spinner.frame.size.width/2),
                               round(self.frame.size.height / 2 - spinner.frame.size.height/2),
                               spinner.frame.size.width,
                               spinner.frame.size.height);

        [spinner release];	
	}
	
	[self addSubview:spinner];
	[spinner startAnimating];
}

#pragma mark -
#pragma mark Rotation

- (void)setProperRotation
{
    //	[self setProperRotation:YES];
    [self setRotationWithOritation:UIDeviceOrientationPortrait animted:YES];
}

- (void)setRotationWithOritation:(UIDeviceOrientation)orientation animted:(BOOL)animated
{
    BOOL isPortrait = YES;
    BOOL needRotation = YES;
    CGFloat duration = 0.3f;
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect frame = CGRectZero;
    
    if (CGAffineTransformEqualToTransform(self.transform, CGAffineTransformIdentity) ||
        CGAffineTransformEqualToTransform(CGAffineTransformRotate(self.transform, SHKdegreesToRadians(180)), CGAffineTransformIdentity))
    {
        isPortrait = NO;
    } else {
        isPortrait = YES;
    }
    
    switch (orientation) {
        case UIDeviceOrientationPortrait:
        {
            transform = CGAffineTransformRotate(CGAffineTransformIdentity, SHKdegreesToRadians(0)); 
            
            if (!isPortrait) 
                duration *= 2;
            
            frame = CGRectMake(0, 0, 320, 480);
            break;
        }
        case UIDeviceOrientationPortraitUpsideDown:
        {
            transform = CGAffineTransformRotate(CGAffineTransformIdentity, SHKdegreesToRadians(180));	
            
            if (!isPortrait) 
                duration *= 2;
            
            frame = CGRectMake(0, 0, 320, 480);
            break;
        }
        case UIDeviceOrientationLandscapeLeft:
        {
            transform = CGAffineTransformRotate(CGAffineTransformIdentity, SHKdegreesToRadians(90));	
            
            if (isPortrait) 
                duration *= 2;
            
            frame = CGRectMake(0, 0, 480, 320);
            break;
        }
        case UIDeviceOrientationLandscapeRight:
        {
            transform = CGAffineTransformRotate(CGAffineTransformIdentity, SHKdegreesToRadians(-90));
            
            if (isPortrait) 
                duration *= 2;
            
            frame = CGRectMake(0, 0, 480, 320);
            break;
        }
        default:
            needRotation = NO;
            break;
    }
    
    if (needRotation) {
        if (animated)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:duration];
        }
        
        self.transform = transform;
        //    self.frame = frame;
        
        if (animated) {
            [UIView commitAnimations];
        }
    }
}

- (void)setProperRotation:(BOOL)animated
{
	UIDeviceOrientation orientation = [UIDevice validDeviceOrientation];
	BOOL isPortrait = YES;
    BOOL needRotation = YES;
    CGFloat duration = 0.3f;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    if (CGAffineTransformEqualToTransform(self.transform, CGAffineTransformIdentity) ||
        CGAffineTransformEqualToTransform(CGAffineTransformRotate(self.transform, SHKdegreesToRadians(180)), CGAffineTransformIdentity))
    {
        isPortrait = NO;
    } else {
        isPortrait = YES;
    }
    
    if (orientation == UIDeviceOrientationPortraitUpsideDown) {
		transform = CGAffineTransformRotate(CGAffineTransformIdentity, SHKdegreesToRadians(180));	
        
        if (!isPortrait) 
            duration *= 2;
    }
    
	else if (orientation == UIDeviceOrientationPortrait) {
		transform = CGAffineTransformRotate(CGAffineTransformIdentity, SHKdegreesToRadians(0)); 
        
        if (!isPortrait) 
            duration *= 2;
    }
	
	else if (orientation == UIDeviceOrientationLandscapeLeft) {
		transform = CGAffineTransformRotate(CGAffineTransformIdentity, SHKdegreesToRadians(90));	
        
        if (isPortrait) 
            duration *= 2;
    }
	
	else if (orientation == UIDeviceOrientationLandscapeRight) {
		transform = CGAffineTransformRotate(CGAffineTransformIdentity, SHKdegreesToRadians(-90));
        
        if (isPortrait) 
            duration *= 2;
    } 
    else {
        needRotation = NO;
    }
    
    if (needRotation) {
        if (animated)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:duration];
        }
        
        self.transform = transform;
        //   self.frame = [UIScreen mainScreen].bounds;
        
        if (animated) {
            [UIView commitAnimations];
        }
    }
}


@end
