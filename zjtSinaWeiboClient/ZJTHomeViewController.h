//
//  ZJTHomeViewController.h
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-5-9.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import "ZJTStatusBaseVC.h"
#import "TwitterVC.h"
#import "OAuthWebView.h"

@interface ZJTHomeViewController : ZJTStatusBaseVC{

    NSString  *userID;
}

@property (nonatomic, copy)NSString *userID;

@end
