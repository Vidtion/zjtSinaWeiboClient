//
//  HHNetDataCacheManager.h
//  HHuan
//
//  Created by jianting zhu on on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

#define MaxCacheBufferSize 20
#define HHNetDataCacheNotification @"HHNetDataCacheNotification"

#define HHNetDataCacheURLKey @"HHNetDataCacheURLKey"
#define HHNetDataCacheData @"HHNetDataCacheData"
#define HHNetDataCacheIndex @"HHNetDataCacheIndex"

@class CoreDataManager;

@interface HHNetDataCacheManager : NSObject<ASIHTTPRequestDelegate,ASIProgressDelegate>{
    NSMutableDictionary * cacheDic;
    NSMutableArray * cacheArray;
    CoreDataManager *_CDManager;
}

@property (nonatomic,retain)CoreDataManager *CDManager;

-(id) init;

//获取此URL下的图片或其他信息，通过 HHNetDataCacheNotification 返回
//返回的内容为一个Dic，key HHNetDataCacheURLKey 为 请求时的url， HHNetDataCacheData 为数据，结构是NSData
//参考HHPopVC的用法
-(void) getDataWithURL:(NSString *) url;
-(void) getDataWithURL:(NSString *) url withIndex:(NSInteger)index;

-(void) freeMemory;

+(HHNetDataCacheManager *) getInstance;

@end
