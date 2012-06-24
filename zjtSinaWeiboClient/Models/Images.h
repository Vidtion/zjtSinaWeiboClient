//
//  Images.h
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-6-23.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Images : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSString * url;

@end
