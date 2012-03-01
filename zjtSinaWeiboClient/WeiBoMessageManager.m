//
//  WeiBoMessageManager.m
//  test
//
//  Created by jianting zhu on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//

#import "WeiBoMessageManager.h"
#import "Status.h"
#import "User.h"

static WeiBoMessageManager * instance=nil;

@implementation WeiBoMessageManager
@synthesize httpManager;

#pragma mark - Init

- (id)init {
    self = [super init];
    if (self) {
        httpManager = [[WeiBoHttpManager alloc] initWithDelegate:self];
        [httpManager start];
    }
    return self;
}

+(WeiBoMessageManager*)getInstance
{
    @synchronized(self) {
        if (instance==nil) {
            instance=[[WeiBoMessageManager alloc] init];
        }
    }
    return instance;
}

- (BOOL)isNeedToRefreshTheToken
{
    NSDate *expirationDate = [[NSUserDefaults standardUserDefaults]objectForKey:USER_STORE_EXPIRATION_DATE];
    if (expirationDate == nil)  return YES;
    
    BOOL boolValue1 = !(NSOrderedDescending == [expirationDate compare:[NSDate date]]);
    BOOL boolValue2 = (expirationDate != nil);
    
    return (boolValue1 && boolValue2);
}

#pragma mark - Http Methods
//留给webview用
-(NSURL*)getOauthCodeUrl
{
    return [httpManager getOauthCodeUrl];
}

//temp
//获取最新的公共微博
-(void)getPublicTimelineWithCount:(int)count withPage:(int)page
{
    [httpManager getPublicTimelineWithCount:count withPage:page];
}

//获取登陆用户的UID
-(void)getUserID
{
    [httpManager getUserID];
}

//获取任意一个用户的信息
-(void)getUserInfoWithUserID:(long long)uid
{
    [httpManager getUserInfoWithUserID:uid];
}

//获取用户双向关注的用户ID列表，即互粉UID列表 
-(void)getBilateralIdListAll:(long long)uid sort:(int)sort
{
    [httpManager getBilateralIdListAll:uid sort:sort];
}

-(void)getBilateralIdList:(long long)uid count:(int)count page:(int)page sort:(int)sort
{
    [httpManager getBilateralIdList:uid count:count page:page sort:sort];
}

//获取用户的双向关注user列表，即互粉列表
-(void)getBilateralUserList:(long long)uid count:(int)count page:(int)page sort:(int)sort
{
    [httpManager getBilateralIdList:uid count:count page:page sort:sort];
}

-(void)getBilateralUserListAll:(long long)uid sort:(int)sort
{
    [httpManager getBilateralUserListAll:uid sort:sort];
}

//关注一个用户 by User ID
-(void)followByUserID:(long long)uid
{
    [httpManager followByUserID:uid];
}

//关注一个用户 by User Name
-(void)followByUserName:(NSString*)userName
{
    [httpManager followByUserName:userName];
}

//取消关注一个用户 by User ID
-(void)unfollowByUserID:(long long)uid
{
    [httpManager unfollowByUserID:uid];
}

//取消关注一个用户 by User Name
-(void)unfollowByUserName:(NSString*)userName
{
    [httpManager unfollowByUserName:userName];
}

//获取某话题下的微博消息
-(void)getTrendStatues:(NSString *)trendName
{
    [httpManager getTrendStatues:trendName];
}

//关注某话题
-(void)followTrend:(NSString*)trendName
{
    [httpManager followTrend:trendName];
}

//取消对某话题的关注
-(void)unfollowTrend:(long long)trendID
{
    [httpManager unfollowTrend:trendID];
}

//发布文字微博
-(void)postWithText:(NSString*)text
{
    [httpManager postWithText:text];
}

//发布文字图片微博
-(void)postWithText:(NSString *)text imageName:(NSString*)imageName
{
    [httpManager postWithText:text imageName:imageName];
}

//获取当前登录用户及其所关注用户的最新微博
-(void)getHomeLine:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count page:(int)page baseApp:(int)baseApp feature:(int)feature
{
    [httpManager getHomeLine:sinceID maxID:maxID count:count page:page baseApp:baseApp feature:feature];
}


#pragma mark - WeiBoHttpDelegate
//获取最新的公共微博
-(void)didGetPublicTimelineWithStatues:(NSArray *)statusArr
{
    Status *st = [statusArr objectAtIndex:0];
    NSLog(@"\n++--%@",st.text);
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotPublicTimeLine object:statusArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//获取登陆用户的UID
-(void)didGetUserID:(NSString *)userID
{
    NSLog(@"userID = %@",userID);
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotUserID object:userID];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//获取任意一个用户的信息
-(void)didGetUserInfo:(User *)user
{
    NSLog(@"userInfo = %@",user.screenName);
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotUserInfo object:user];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//获取用户双向关注的用户ID列表，即互粉UID列表
-(void)didGetBilateralIdList:(NSArray *)arr
{
    NSLog(@"BilateralIdList = %@",arr);
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotBilateralIdList object:arr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//获取用户的双向关注user列表，即互粉列表
-(void)didGetBilateralUserList:(NSArray *)userArr
{
    User *user = [userArr objectAtIndex:0];
    NSLog(@"screenName = %@",user.screenName);
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotBilateralUserList object:userArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//获取某话题下的微博消息
-(void)didGetTrendStatues:(NSArray *)statusArr
{
    Status *st = [statusArr objectAtIndex:0];
    NSLog(@"status = %@",st.text);
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotTrendStatues object:statusArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//关注一个用户 by User ID
-(void)didFollowByUserIDWithResult:(int)result 
{
    NSLog(@"result = %d",result);
    NSNumber *number = [NSNumber numberWithInt:result];
    NSNotification *notification = [NSNotification notificationWithName:MMSinaFollowedByUserIDWithResult object:number];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//取消关注一个用户 by User ID
-(void)didUnfollowByUserIDWithResult:(int)result
{
    NSLog(@"result = %d",result);
    NSNumber *number = [NSNumber numberWithInt:result];
    NSNotification *notification = [NSNotification notificationWithName:MMSinaUnfollowedByUserIDWithResult object:number];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//关注某话题
-(void)didGetTrendIDAfterFollowed:(int64_t)topicID
{
    NSLog(@"topicID = %lld",topicID);
    NSNumber *number = [NSNumber numberWithLongLong:topicID];
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotTrendIDAfterFollowed object:number];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//取消对某话题的关注
-(void)didGetTrendResultAfterUnfollowed:(BOOL)isTrue
{
    NSLog(isTrue == YES?@"true":@"false");
    NSNumber *number = [NSNumber numberWithBool:isTrue];
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotTrendResultAfterUnfollowed object:number];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//发布微博
-(void)didGetPostResult:(Status *)sts
{
    NSLog(@"sts.text = %@",sts.text);
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotPostResult object:sts];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//获取当前登录用户及其所关注用户的最新微博
-(void)didGetHomeLine:(NSArray *)statusArr
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotHomeLine object:statusArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}


@end
