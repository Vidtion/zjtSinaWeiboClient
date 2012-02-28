//
//  FirstViewController.h
//  zjtSinaWeiboClient
//
//  Created by jtone z on 11-11-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusCell.h"

@class WeiBoMessageManager;

@interface FirstViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,StatusCellDelegate>{
    BOOL shouldLoad;
    BOOL shouldLoadAvatar;
    WeiBoMessageManager *manager;
    NSNotificationCenter *defaultNotifCenter;
    
    UITableView *table;
    NSString *userID;
    UINib *statusCellNib;
    NSMutableArray *statuesArr;
    NSMutableDictionary *headDictionary;
    NSMutableDictionary *imageDictionary;
}
@property (retain, nonatomic)   IBOutlet UITableView *table;
@property (nonatomic, copy)     NSString *userID;
@property (nonatomic, retain)   UINib *statusCellNib;
@property (nonatomic, retain)   NSMutableArray *statuesArr;
@property (nonatomic, retain)   NSMutableDictionary *headDictionary;
@property (nonatomic, retain)   NSMutableDictionary *imageDictionary;

@end
