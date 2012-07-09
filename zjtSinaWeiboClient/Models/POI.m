//
//  POI.m
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-7-9.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import "POI.h"
#import "StringUtil.h"

@implementation POI
@synthesize poiid = _poiid;
@synthesize title = _title;
@synthesize address = _address;
@synthesize lon = _lon;
@synthesize lat = _lat;
@synthesize category = _category;
@synthesize city = _city;
@synthesize province = _province;
@synthesize country = _country;
@synthesize url = _url;
@synthesize phone = _phone;
@synthesize postcode = _postcode;
@synthesize category_name = _category_name;
@synthesize icon = _icon;
@synthesize checkin_num = _checkin_num;
@synthesize checkin_user_num = _checkin_user_num;
@synthesize tip_num = _tip_num;
@synthesize photo_num = _photo_num;
@synthesize todo_num = _todo_num;
@synthesize distance = _distance;

-(void)dealloc
{
    self.poiid = nil;
    self.title = nil;
    self.address = nil;
    self.lon     = nil;
    self.lat = nil;
    self.category = nil;
    self.city = nil;
    self.province = nil;
    self.country = nil;
    self.url = nil;
    self.phone = nil;
    self.postcode = nil;
    self.category_name = nil;
    self.icon = nil;
    self.checkin_num = nil;
    self.checkin_user_num = nil;
    self.tip_num = nil;
    self.photo_num = nil;
    self.todo_num = nil;
    self.distance = nil;
    
    [super dealloc];
}

- (POI*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    if (self) {
        [self updateWithJSonDictionary:dic];
    }
	
	return self;
}

- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    [dic retain];
    self.poiid = [dic objectForKey:@"poiid"];
    self.title = [dic objectForKey:@"title"];
    self.address = [dic objectForKey:@"address"];
    self.lon     = [dic objectForKey:@"lon"];
    self.lat = [dic objectForKey:@"lat"];
    self.category = [dic objectForKey:@"category"];
    self.city = [dic objectForKey:@"city"];
    self.province = [dic objectForKey:@"province"];
    self.country = [dic objectForKey:@"country"];
    self.url = [dic objectForKey:@"url"];
    self.phone = [dic objectForKey:@"phone"];
    self.postcode = [dic objectForKey:@"postcode"];
    self.category_name = [dic objectForKey:@"category_name"];
    self.icon = [dic objectForKey:@"icon"];
    self.checkin_num = [dic objectForKey:@"checkin_num"];
    self.checkin_user_num = [dic objectForKey:@"checkin_user_num"];
    self.tip_num = [dic objectForKey:@"tip_num"];
    self.photo_num = [dic objectForKey:@"photo_num"];
    self.todo_num = [dic objectForKey:@"todo_num"];
    self.distance = [dic objectForKey:@"distance"];
    [dic release];
}

+ (POI*)poiWithJsonDictionary:(NSDictionary*)dic
{
    POI *p;
    p = [[POI alloc] initWithJsonDictionary:dic];
    return [p autorelease];
}

@end
