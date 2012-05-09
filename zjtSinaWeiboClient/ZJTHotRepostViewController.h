//
//  ZJTHotRepostViewController.h
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-5-9.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import "StatusViewContrillerBase.h"
#import "ZJTStatusBaseVC.h"

typedef enum {
    kHotRepostDaily = 0,
    kHotRepostWeekly,
    kHotCommentDaily,
    kHotCommentWeekly,
}VCType;

@interface ZJTHotRepostViewController : StatusViewContrillerBase

@property (nonatomic,assign)VCType type;

-(id)initWithType:(VCType)type;

@end
