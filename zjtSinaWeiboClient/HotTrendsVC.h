//
//  HotTrendsVC.h
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-6-26.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotTrendsVCDelegate <NSObject>

-(void)hotTrendTableCellDidClicked:(NSIndexPath*)indexPath title:(NSString*)title;

@end
@interface HotTrendsVC : UITableViewController
{
    NSArray *_dataSourceArr;
    id<HotTrendsVCDelegate> _delegate;
    BOOL _isForPost;
    BOOL _isUserTopics;
}

@property (nonatomic,retain)NSArray *dataSourceArr;
@property (nonatomic,assign)id<HotTrendsVCDelegate> delegate;
-(id)initWithDataSourceArr:(NSArray*)arr stylee:(UITableViewStyle)style;
@property (nonatomic,assign) BOOL isUserTopics;

@end
