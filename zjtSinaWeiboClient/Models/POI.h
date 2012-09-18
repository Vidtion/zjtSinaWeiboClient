//
//  POI.h
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-7-9.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POI : NSObject
{
    
}

@property (nonatomic,copy) NSString *poiid;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *lon;
@property (nonatomic,copy) NSString *lat;
@property (nonatomic,copy) NSString *category;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *country;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *postcode;
@property (nonatomic,copy) NSString *category_name;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,retain) NSNumber *checkin_num;
@property (nonatomic,retain) NSNumber *checkin_user_num;
@property (nonatomic,retain) NSNumber *tip_num;
@property (nonatomic,retain) NSNumber *photo_num;
@property (nonatomic,retain) NSNumber *todo_num;
@property (nonatomic,retain) NSNumber *distance;


+ (POI*)poiWithJsonDictionary:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;
- (POI*)initWithJsonDictionary:(NSDictionary*)dic;

@end
