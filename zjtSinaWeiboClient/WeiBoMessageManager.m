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

-(void)getUserInfoWithScreenName:(NSString*)sn
{
    [httpManager getUserInfoWithScreenName:sn];
}

//根据微博消息ID返回某条微博消息的评论列表
-(void)getCommentListWithID:(long long)weiboID maxID:(NSString*)max_id page:(int)page
{
    [httpManager getCommentListWithID:weiboID maxID:max_id page:page];
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

//获取用户的关注列表
-(void)getFollowingUserList:(long long)uid count:(int)count cursor:(int)cursor
{
    [httpManager getFollowingUserList:uid count:count cursor:cursor];
}

//获取用户粉丝列表
-(void)getFollowedUserList:(long long)uid count:(int)count cursor:(int)cursor
{
    [httpManager getFollowedUserList:uid count:count cursor:cursor];
}

//关注一个用户 by User ID
-(void)followByUserID:(long long)uid inTableView:(NSString*)tableName
{
    [httpManager followByUserID:uid inTableView:tableName];
}

//关注一个用户 by User Name
-(void)followByUserName:(NSString*)userName
{
    [httpManager followByUserName:userName];
}

//取消关注一个用户 by User ID
-(void)unfollowByUserID:(long long)uid inTableView:(NSString*)tableName
{
    [httpManager unfollowByUserID:uid inTableView:tableName];
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
-(void)postWithText:(NSString *)text image:(UIImage*)image
{
    [httpManager postWithText:text image:image];
}

//获取当前登录用户及其所关注用户的最新微博
-(void)getHomeLine:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count page:(int)page baseApp:(int)baseApp feature:(int)feature
{
    [httpManager getHomeLine:sinceID maxID:maxID count:count page:page baseApp:baseApp feature:feature];
}

//获取某个用户最新发表的微博列表
-(void)getUserStatusUserID:(NSString *) uid sinceID:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count page:(int)page baseApp:(int)baseApp feature:(int)feature
{
    [httpManager getUserStatusUserID:uid sinceID:sinceID maxID:maxID count:count page:page baseApp:baseApp feature:feature];
}

//转发一条微博
-(void)repost:(NSString*)weiboID content:(NSString*)content withComment:(int)isComment
{
    [httpManager repost:weiboID content:content withComment:isComment];
}

//按天返回热门微博转发榜的微博列表
-(void)getHotRepostDaily:(int)count
{
    [httpManager getHotRepostDaily:count];
}

//按天返回热门微博评论榜的微博列表
-(void)getHotCommnetDaily:(int)count
{
    [httpManager getHotCommnetDaily:count];
}

//返回最近一天内的热门话题
-(void)getHOtTrendsDaily
{
    [httpManager getHOtTrendsDaily];
}

//获取某个用户的各种消息未读数
-(void)getUnreadCount:(NSString*)uid
{
    [httpManager getUnreadCount:uid];
}

//获取最新的提到登录用户的微博列表，即@我的微博
-(void)getMetionsStatuses
{
    [httpManager getMetionsStatuses];
}

//获取附近地点
-(void)getPoisWithCoodinate:(CLLocationCoordinate2D)coodinate queryStr:(NSString*)queryStr
{
    [httpManager getPoisWithCoodinate:coodinate queryStr:queryStr];
}

//搜索某一话题下的微博
-(void)searchTopic:(NSString *)queryStr count:(int)count page:(int)page
{
    [httpManager searchTopic:queryStr count:count page:page];
}

//获取某人的话题列表
-(void)getTopicsOfUser:(User*)user
{
    [httpManager getTopicsOfUser:user];
}

//回复一条评论
-(void)replyACommentWeiboId:(NSString *)weiboID commentID:(NSString*)commentID content:(NSString*)content
{
    [httpManager replyACommentWeiboId:weiboID commentID:commentID content:content];
}

//对一条微博进行评论
-(void)commentAStatus:(NSString*)weiboID content:(NSString*)content
{
    [httpManager commentAStatus:weiboID content:content];
}

#pragma mark - WeiBoHttpDelegate
//获取最新的公共微博
-(void)didGetPublicTimelineWithStatues:(NSArray *)statusArr
{
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

//根据微博消息ID返回某条微博消息的评论列表
-(void)didGetCommentList:(NSDictionary *)commentInfo
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotCommentList object:commentInfo];
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
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotBilateralUserList object:userArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//获取用户的关注列表
-(void)didGetFollowingUsersList:(NSDictionary *)dic
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotFollowingUserList object:dic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//获取用户的粉丝列表
-(void)didGetFollowedUsersList:(NSDictionary *)dic
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotFollowedUserList object:dic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//获取某话题下的微博消息
-(void)didGetTrendStatues:(NSArray *)statusArr
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotTrendStatues object:statusArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//关注一个用户 by User ID
-(void)didFollowByUserIDWithResult:(NSDictionary *)resultDic
{
    NSLog(@"result = %@",resultDic);
    NSNotification *notification = [NSNotification notificationWithName:MMSinaFollowedByUserIDWithResult object:resultDic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//取消关注一个用户 by User ID
-(void)didUnfollowByUserIDWithResult:(NSDictionary *)resultDic
{
    NSLog(@"result = %@",resultDic);
    NSNotification *notification = [NSNotification notificationWithName:MMSinaUnfollowedByUserIDWithResult object:resultDic];
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
    if (statusArr == nil || [statusArr count] == 0) {
        return;
    }
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotHomeLine object:statusArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//获取某个用户最新发表的微博列表
-(void)didGetUserStatus:(NSArray*)statusArr
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotUserStatus object:statusArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//转发一条微博
-(void)didRepost:(Status *)sts
{
    NSLog(@"sts.text = %@",sts.text);
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotRepost object:sts];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//按天返回热门微博转发榜的微博列表
-(void)didGetHotRepostDaily:(NSArray *)statusArr
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotHotRepostDaily object:statusArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//按天返回热门微博评论榜的微博列表
-(void)didGetHotCommentDaily:(NSArray *)statusArr
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotHotCommentDaily object:statusArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//返回最近一天内的热门话题
-(void)didGetHotTrendDaily:(NSArray*)trendsArr
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotHotCommentDaily object:trendsArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//获取某个用户的各种消息未读数
-(void)didGetUnreadCount:(NSDictionary *)dic
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotUnreadCount object:dic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

-(void)didGetMetionsStatused:(NSArray *)statusArr
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotMetionsStatuses object:statusArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

-(void)didgetPois:(NSArray *)poisArr
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotPois object:poisArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//搜索某一话题下的微博
-(void)didGetTopicSearchResult:(NSArray *)statusArr
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotTopicStatuses object:statusArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//获取某人的话题列表
-(void)didGetuserTopics:(NSArray *)trendsArr   
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaGotUserTopics object:trendsArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//回复一条评论
-(void)didReplyAComment:(BOOL)isOK
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaReplyAComment object:[NSNumber numberWithBool:isOK]];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//对一条微博进行评论
-(void)didCommentAStatus:(BOOL)isOK
{
    NSNotification *notification = [NSNotification notificationWithName:MMSinaCommentAStatus object:[NSNumber numberWithBool:isOK]];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
