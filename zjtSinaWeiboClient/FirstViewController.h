//
//  FirstViewController.h
//  zjtSinaWeiboClient
//
//  Created by jtone z on 11-11-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiBoMessageManager;

@interface FirstViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    BOOL shouldLoad;
    BOOL shouldLoadAvatar;
    WeiBoMessageManager *manager;
}
@property (retain, nonatomic)   IBOutlet UITableView *table;
@property (nonatomic, copy)     NSString *userID;
@property (nonatomic, retain)   UINib *statusCellNib;
@property (nonatomic, retain)   NSMutableArray *statuesArr;
@property (nonatomic, retain)   NSMutableDictionary *headDictionary;
@property (nonatomic, retain)   NSMutableArray *httpRequestList;

@end
