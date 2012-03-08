//
//  ZJTHelpler.h
//  zjtSinaWeiboClient
//
//  Created by Zhu Jianting on 12-3-8.
//  Copyright (c) 2012年 WS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface ZJTHelpler : NSObject
{
    
}

//大小变化动画
+ (CAAnimation *)animationWithScaleFrom:(CGFloat) from To:(CGFloat) to Duration:(CGFloat) duration BeginTime:(CGFloat)beginTime;

//位置变化动画
+ (CAAnimation *)animationMoveFrom:(CGPoint) from To:(CGPoint) to Duration:(CGFloat) duration BeginTime:(CGFloat)beginTime; 

//透明度变化动画
+ (CAAnimation *)animationWithOpacityFrom:(CGFloat) from To:(CGFloat) to Duration:(CGFloat) duration BeginTime:(CGFloat)beginTime;

@end
