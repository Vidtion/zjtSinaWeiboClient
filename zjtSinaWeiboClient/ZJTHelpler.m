//
//  ZJTHelpler.m
//  zjtSinaWeiboClient
//
//  Created by Zhu Jianting on 12-3-8.
//  Copyright (c) 2012年 WS. All rights reserved.
//

#import "ZJTHelpler.h"

static ZJTHelpler *instance = nil;
@implementation ZJTHelpler
@synthesize user;

-(void)dealloc
{
    self.user = nil;
    [super dealloc];
}


+(ZJTHelpler*)getInstance
{
    if (instance == nil) {
        instance = [[self alloc] init];
    }
    return instance;
}

+ (NSString *) regularStringFromSearchString:(NSString *)string
{
	NSMutableString * stringRet = [[NSMutableString alloc] initWithCapacity:0];
	for( int i = 0; i < [string length]; i++ )
	{
		[stringRet appendFormat:@".*(%@)", [string substringWithRange:NSMakeRange(i, 1)]];
	}
	
	[stringRet appendString:@".*"];
	
	return [stringRet autorelease];
}

+ (CAAnimation *)animationMoveFrom:(CGPoint) from To:(CGPoint) to Duration:(CGFloat) duration BeginTime:(CGFloat)beginTime //位置变化动画
{
	CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];	
	CGFloat animationDuration = duration;
	CGMutablePathRef thePath = CGPathCreateMutable();
	CGPathMoveToPoint(thePath, NULL, from.x, from.y);
	CGPathAddLineToPoint(thePath, NULL, to.x, to.y);
	bounceAnimation.path = thePath;
	bounceAnimation.duration = animationDuration;
    bounceAnimation.beginTime = beginTime;
	bounceAnimation.repeatCount=0;
	bounceAnimation.removedOnCompletion=NO;
	bounceAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	CGPathRelease(thePath);
	
	return bounceAnimation;
}

+ (CAAnimation *)animationWithScaleFrom:(CGFloat) from To:(CGFloat) to Duration:(CGFloat) duration BeginTime:(CGFloat)beginTime //大小变化动画
{    
    CABasicAnimation *theAnimation;    
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];    
    theAnimation.duration=duration; 
    theAnimation.beginTime = beginTime;    
    theAnimation.repeatCount=0;    
    theAnimation.autoreverses=NO;    
    theAnimation.fromValue=[NSNumber numberWithFloat:from];    
    theAnimation.toValue=[NSNumber numberWithFloat:to];
    
    return theAnimation;
}



+ (CAAnimation *)animationWithOpacityFrom:(CGFloat) from To:(CGFloat) to Duration:(CGFloat) duration BeginTime:(CGFloat)beginTime //透明度变化动画
{    
    CABasicAnimation *theAnimation;    
    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];    
    theAnimation.duration=duration; 
    theAnimation.beginTime = beginTime;    
    theAnimation.repeatCount=0;    
    theAnimation.autoreverses=NO;    
    theAnimation.fromValue=[NSNumber numberWithFloat:from];    
    theAnimation.toValue=[NSNumber numberWithFloat:to];
    
    return theAnimation;
}



+ (CGFloat)getTextViewHeight:(NSString*)contentText with:(CGFloat)with sizeOfFont:(CGFloat)fontSize addtion:(CGFloat)add
{
    UIFont * font=[UIFont  systemFontOfSize:fontSize];
    CGSize size=[contentText sizeWithFont:font constrainedToSize:CGSizeMake(with - kTextViewPadding, 300000.0f) lineBreakMode:kLineBreakMode];
    CGFloat height = size.height + add;
    return height;
}

@end
