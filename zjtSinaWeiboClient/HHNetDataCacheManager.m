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

@interface HHNetDataCacheManager()
- (Images*)readImageFromCD:(NSString*)url;
- (void)insertImageToCD:(NSData*)data url:(NSString*)url;
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

- (void)insertImageToCD:(NSData*)data url:(NSString*)url
{
    if ([self readImageFromCD:url] != nil) {
        return;
    }
    Images *image = (Images *)[NSEntityDescription insertNewObjectForEntityForName:@"Images" inManagedObjectContext:_CDManager.managedObjContext];
    image.createDate = [NSDate date];
    image.url = url;
    image.data = data;
    
    NSError *error;
	if (![_CDManager.managedObjContext save:&error]) {
		// Handle the error.
	}
}

- (Images*)readImageFromCD:(NSString*)url 
{
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Images" inManagedObjectContext:_CDManager.managedObjContext];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"url==%@",url];
    [fetch setPredicate:pred];
    [fetch setEntity:entity];
    
    NSError *error = nil;
	NSMutableArray *resultsArr = [[[_CDManager.managedObjContext executeFetchRequest:fetch error:&error] mutableCopy] retain];
	if (resultsArr == nil || [resultsArr count] == 0) {
		return nil;
	}
    
    Images *image = [[resultsArr objectAtIndex:0] retain];
    
    [resultsArr release];
    [fetch release];
    
    return [image autorelease];
}


-(void) getDataWithURL:(NSString *) url withIndex:(NSInteger)index
{
    if (url==nil||[url length]==0) {
        return ;
    }
    @synchronized(self) 
    {
        Images *image= [self readImageFromCD:url];
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
    [self insertImageToCD:data url:url];
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
