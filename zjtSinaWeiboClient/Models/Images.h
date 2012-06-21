//
//  Images.h
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-6-22.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Images : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSDate * createDate;

@end
