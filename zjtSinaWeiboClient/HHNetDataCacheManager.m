//
//  HHNetDataCacheManager.m
//  HHuan
//
//  Created by jianting zhu on on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HHNetDataCacheManager.h"

static HHNetDataCacheManager * instance;

@implementation HHNetDataCacheManager

-(id) init{
    self = [super init];
    if (self) {
        cacheDic=[[NSMutableDictionary alloc] init];
        cacheArray=[[NSMutableArray alloc] init]; 
    }
    return self;
}

+(HHNetDataCacheManager *) getInstance{
    @synchronized(self) {
        if (instance==nil) {
            instance=[[HHNetDataCacheManager alloc] init];
        }
    }
    return instance;
}

-(void) sendNotificationWithKey:(NSString *) url Data:(NSData *) data index:(NSNumber*)index{
    NSDictionary * post=[[NSDictionary alloc] initWithObjectsAndKeys:
                         url,   HHNetDataCacheURLKey,
                         data,  HHNetDataCacheData, 
                         index, HHNetDataCacheIndex,nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:HHNetDataCacheNotification object:post];
    [post release];
}

-(void)dealloc
{
    [cacheDic release];
    [cacheArray release];
    [super dealloc];
}

-(void) getDataWithURL:(NSString *) url withIndex:(NSInteger)index
{
    if (url==nil||[url length]==0) {
        return ;
    }
    @synchronized(self) 
    {
        int i=0;
        for (i=0; i<[cacheArray count]; i++) {
            NSString * str=[cacheArray objectAtIndex:i];
            if (str!=nil) {
                if ([[cacheArray objectAtIndex:i] isEqualToString:url]) {
                    break;
                }
            }
        }
        if (i<[cacheArray count]) 
        {//match
//            NSLog(@"match url = %@",url);
            NSData * result=[cacheDic objectForKey:[cacheArray objectAtIndex:i]];
            NSNumber *indexNumber = [NSNumber numberWithInt:index];
            [self sendNotificationWithKey:url Data:result index:indexNumber];
            //调整位置
            //            NSString * key=[cacheArray objectAtIndex:i];
            //            [cacheArray removeObjectAtIndex:i];
            //            [cacheArray insertObject:key atIndex:0];
        }
        else
        {//unmatch
//            NSLog(@"unmatch url = %@",url);
            ASIHTTPRequest * request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
            [request setDelegate:self];
            request.downloadProgressDelegate = self;
            request.uploadProgressDelegate = self;
            
            if (index >= 0) {
                NSNumber *indexNumber = [NSNumber numberWithInt:index];
                [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:url,@"url",indexNumber,@"index", nil]];
            }
            else
            {
                [request setUserInfo:[NSDictionary dictionaryWithObject:url forKey:@"url"]];
            }
            [request startAsynchronous];
        }
    }
}

//无index参数时，返回 -1
-(void) getDataWithURL:(NSString *) url{
    [self getDataWithURL:url withIndex:-1];
}

-(void) freeMemory{
    @synchronized(self) {
        [cacheArray removeAllObjects];
        [cacheDic removeAllObjects];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSString * url=[request.userInfo objectForKey:@"url"];
    NSNumber *indexNumber = [request.userInfo objectForKey:@"index"];
    
    NSData * data=[request responseData];
    [self sendNotificationWithKey:url Data:data index:indexNumber];
    //add to cache
    @synchronized(self) {
        [cacheArray insertObject:url atIndex:0];
        [cacheDic setValue:data forKey:url];
        if ([cacheArray count]>MaxCacheBufferSize) {
            //remove
            NSString * str=[cacheArray lastObject];
            [cacheDic removeObjectForKey:str];
            [cacheArray removeLastObject];
        }
    }
}

//下载进度
- (void)setProgress:(ASIHTTPRequest *)request newProgress:(float)newProgress
{
//    NSLog(@"progress = %f",newProgress);
}


@end
