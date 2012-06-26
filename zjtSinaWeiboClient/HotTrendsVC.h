//
//  HotTrendsVC.h
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-6-26.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotTrendsVC : UITableViewController
{
    NSArray *_dataSourceArr;
}

@property (nonatomic,retain)NSArray *dataSourceArr;

-(id)initWithDataSourceArr:(NSArray*)arr stylee:(UITableViewStyle)style;

@end
