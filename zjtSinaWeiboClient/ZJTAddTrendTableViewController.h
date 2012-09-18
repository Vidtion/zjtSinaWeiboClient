//
//  ZJTAddTrendTableViewController.h
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-7-11.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TRENDS_STORED_RECORDS_ARRAY @"TRENDS_STORED_RECORDS_ARRAY"

@interface ZJTAddTrendTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_recentRecordsArr;
}
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UITableView *table;





@end
