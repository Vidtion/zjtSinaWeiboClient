//
//  HHNetDataCacheManager.m
//  HHuan
//
//  Created by jianting zhu on on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HHNetDataCacheManager.h"
#import "CoreDataManager.h"
#import "Images.h"
#import "SHKActivityIndicator.h"

@interface HHNetDataCacheManager()
@end

static HHNetDataCacheManager * instance;

@implementation HHNetDataCacheManager
@synthesize CDManager = _CDManager;

-(id) init{
    self = [super init];
    if (self) {
        cacheDic=[[NSMutableDictionary alloc] init];
        cacheArray=[[NSMutableArray alloc] init]; 
        self.CDManager = [CoreDataManager getInstance];
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
        Images *image= [_CDManager readImageFromCD:url];
        if (image != nil && ![image isEqual:[NSNull null]]) 
        {
            NSNumber *indexNumber = [NSNumber numberWithInt:index];
            [self sendNotificationWithKey:url Data:image.data index:indexNumber];
        }
        else 
        {
            ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
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
    if ([url rangeOfString:@"/180/"].location == NSNotFound) {
        [_CDManager insertImageToCD:data url:url];
    }
    [self sendNotificationWithKey:url Data:data index:indexNumber];
}

//下载进度
- (void)setProgress:(ASIHTTPRequest *)request newProgress:(float)newProgress
{
    NSDictionary *dic = request.userInfo;
    NSObject *obj = [dic objectForKey:@"index"];
    if (obj == nil) 
    {
        NSString *progressStr = [NSString stringWithFormat:@"%.1f%%",newProgress*100];
        NSLog(@"%@",progressStr);
        if (newProgress > 0.0) {
            [[SHKActivityIndicator currentIndicator]setSubMessage:progressStr];
        }
    }
}


@end
