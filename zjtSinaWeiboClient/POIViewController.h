//
//  POIViewController.h
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-7-9.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POI.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "WeiBoMessageManager.h"

@protocol POIViewControllerDelegate <NSObject>

-(void)poisCellDidSelected:(POI*)poi;

@end

@interface POIViewController : UITableViewController<CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    
    CLLocationCoordinate2D _coordinate;
    WeiBoMessageManager *_manager;
    NSArray *_poisArr;
    id<POIViewControllerDelegate> _delegate;
}

@property (nonatomic,retain)CLLocationManager *locationManager;

@property (nonatomic,assign)CLLocationCoordinate2D coordinate;
@property (nonatomic,assign)id<POIViewControllerDelegate> delegate;

@end
