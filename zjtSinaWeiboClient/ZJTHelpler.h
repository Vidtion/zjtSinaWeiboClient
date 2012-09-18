//
//  ZJTHelpler.h
//  zjtSinaWeiboClient
//
//  Created by Zhu Jianting on 12-3-8.
//  Copyright (c) 2012年 WS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "User.h"
@class ZJTHelpler;
#define kTextViewPadding            16.0
#define kLineBreakMode              UILineBreakModeWordWrap

@interface ZJTHelpler : NSObject
{
    
}
@property (nonatomic,retain)User *user;

+(ZJTHelpler*)getInstance;

+ (NSString *) regularStringFromSearchString:(NSString *)string;

//大小变化动画
+ (CAAnimation *)animationWithScaleFrom:(CGFloat) from To:(CGFloat) to Duration:(CGFloat) duration BeginTime:(CGFloat)beginTime;

//位置变化动画
+ (CAAnimation *)animationMoveFrom:(CGPoint) from To:(CGPoint) to Duration:(CGFloat) duration BeginTime:(CGFloat)beginTime; 

//透明度变化动画
+ (CAAnimation *)animationWithOpacityFrom:(CGFloat) from To:(CGFloat) to Duration:(CGFloat) duration BeginTime:(CGFloat)beginTime;


+(CGFloat)getTextViewHeight:(NSString*)contentText with:(CGFloat)with sizeOfFont:(CGFloat)fontSize addtion:(CGFloat)add;


@end
