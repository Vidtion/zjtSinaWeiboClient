//
//  WeiBoMessageManager.h
//  test
//
//  Created by jianting zhu on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiBoHttpManager.h"
#import "ZJTStatusBarAlertWindow.h"

//获取最新的公共微博
//返回成员为Status的NSArray
#define MMSinaGotPublicTimeLine @"MMSinaGotPublicTimeLine"

//获取登陆用户的UID
//返回userID(NSString)
#define MMSinaGotUserID @"MMSinaGotUserID"

//获取任意一个用户的信息
//返回一个User对象
#define MMSinaGotUserInfo @"MMSinaGotUserInfo"

//根据微博消息ID返回某条微博消息的评论列表
//返回成员为comment的NSArray.
#define MMSinaGotCommentList @"MMSinaGotCommentList"

//获取用户双向关注的用户ID列表，即互粉UID列表
//返回成员为UID(NSNumber)的NSArray。
#define MMSinaGotBilateralIdList @"MMSinaGotBilateralIdList"

//获取用户的双向关注user列表，即互粉列表
//返回成员为User的NSArray。
#define MMSinaGotBilateralUserList @"MMSinaGotBilateralUserList"

//获取用户的关注列表
//返回成员为User的NSArray。
#define MMSinaGotFollowingUserList @"MMSinaGotFollowingUserList"

//获取用户的粉丝列表
//返回成员为User的NSArray。
#define MMSinaGotFollowedUserList @"MMSinaGotFollowedUserList"

//获取某话题下的微博消息
//返回成员为Status的NSArray
#define MMSinaGotTrendStatues @"MMSinaGotTrendStatues"

//关注一个用户 by User ID
//返回一个Dic
//result:(NSNumber)值，int == 0 成功，int == 1，失败
//uid (NSString)
#define MMSinaFollowedByUserIDWithResult @"MMSinaFollowedByUserIDWithResult"

//取消关注一个用户 by User ID
//返回一个Dic
//result:(NSNumber)值，int == 0 成功，int == 1，失败
//uid (NSString)
#define MMSinaUnfollowedByUserIDWithResult @"UnfollowedByUserIDWithResult"

//关注某话题
//返回long long(NSNumber)类型的 topic ID
#define MMSinaGotTrendIDAfterFollowed @"MMSinaGotTrendIDAfterFollowed"

//取消对某话题的关注
//返回一个BOOL(NSNumber)值
#define MMSinaGotTrendResultAfterUnfollowed @"MMSinaGotTrendResultAfterUnfollowed"

//发布微博
//返回一个Status对象
#define MMSinaGotPostResult @"MMSinaGotPostResult"

//获取当前登录用户及其所关注用户的最新微博
//返回成员为Status的NSArray
#define MMSinaGotHomeLine @"MMSinaGotHomeLine"

//获取某个用户最新发表的微博列表
//返回成员为Status的NSArray
#define MMSinaGotUserStatus @"MMSinaGotUserStatus"

//转发一条微博
//返回一个Status对象
#define MMSinaGotRepost @"MMSinaGotRepost"

//按天返回热门微博转发榜的微博列表
//返回成员为Status的NSArray
#define MMSinaGotHotRepostDaily @"MMSinaGotHotRepostDaily"

//按天返回热门微博评论榜的微博列表
//返回成员为Status的NSArray
#define MMSinaGotHotCommentDaily @"MMSinaGotHotCommentDaily"

//返回最近一天内的热门话题
//返回成员为NSDictionary： 
//{
//    "name": "曼联",
//    "query": "曼联"
//}
#define MMSinaGotHotCommentDaily @"MMSinaGotHotCommentDaily"

//获取某个用户的各种消息未读数
#define MMSinaGotUnreadCount @"MMSinaGotUnreadCount"

//获取最新的提到登录用户的微博列表，即@我的微博
#define MMSinaGotMetionsStatuses @"MMSinaGotMetionsStatuses"

//获取附近地点
//返回成员为POI的NSArray
#define MMSinaGotPois @"MMSinaGotPois"

//搜索某一话题下的微博
//返回成员为Status的NSArray
#define MMSinaGotTopicStatuses  @"MMSinaGotTopicStatuses"

//获取某人的话题列表
//{
//    "num": 225673,
//    "hotword": "苹果",
//    "trend_id": 1567898
//},
#define MMSinaGotUserTopics  @"MMSinaGotUserTopics"

//回复一条评论
#define MMSinaReplyAComment @"MMSinaReplyAComment"

//对一条微博进行评论
#define MMSinaCommentAStatus @"MMSinaCommentAStatus"

@interface WeiBoMessageManager : NSObject <WeiBoHttpDelegate>
{
    WeiBoHttpManager *httpManager;
}
@property (nonatomic,retain)WeiBoHttpManager *httpManager;

+(WeiBoMessageManager*)getInstance;

//查看Token是否过期
- (BOOL)isNeedToRefreshTheToken;

//留给webview用
-(NSURL*)getOauthCodeUrl;

//temp
//获取最新的公共微博
-(void)getPublicTimelineWithCount:(int)count withPage:(int)page;

//获取登陆用户的UID
-(void)getUserID;

//获取任意一个用户的信息
-(void)getUserInfoWithUserID:(long long)uid;
-(void)getUserInfoWithScreenName:(NSString*)sn;

//根据微博消息ID返回某条微博消息的评论列表
-(void)getCommentListWithID:(long long)weiboID maxID:(NSString*)max_id page:(int)page;

//获取用户双向关注的用户ID列表，即互粉UID列表 
-(void)getBilateralIdListAll:(long long)uid sort:(int)sort;
-(void)getBilateralIdList:(long long)uid count:(int)count page:(int)page sort:(int)sort;

//获取用户的关注列表
-(void)getFollowingUserList:(long long)uid count:(int)count cursor:(int)cursor;

//获取用户粉丝列表
-(void)getFollowedUserList:(long long)uid count:(int)count cursor:(int)cursor;

//获取用户的双向关注user列表，即互粉列表
-(void)getBilateralUserList:(long long)uid count:(int)count page:(int)page sort:(int)sort;
-(void)getBilateralUserListAll:(long long)uid sort:(int)sort;

//关注一个用户 by User ID
-(void)followByUserID:(long long)uid inTableView:(NSString*)tableName;

//关注一个用户 by User Name
-(void)followByUserName:(NSString*)userName;

//取消关注一个用户 by User ID
-(void)unfollowByUserID:(long long)uid inTableView:(NSString*)tableName;

//取消关注一个用户 by User Name
-(void)unfollowByUserName:(NSString*)userName;

//获取某话题下的微博消息
-(void)getTrendStatues:(NSString *)trendName;

//关注某话题
-(void)followTrend:(NSString*)trendName;

//取消对某话题的关注
-(void)unfollowTrend:(long long)trendID;

//发布文字微博
-(void)postWithText:(NSString*)text;

//发布文字图片微博
-(void)postWithText:(NSString *)text image:(UIImage*)image;

//获取当前登录用户及其所关注用户的最新微博
-(void)getHomeLine:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count page:(int)page baseApp:(int)baseApp feature:(int)feature;

//获取某个用户最新发表的微博列表
-(void)getUserStatusUserID:(NSString *) uid sinceID:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count page:(int)page baseApp:(int)baseApp feature:(int)feature;

//转发一条微博
//isComment(int):是否在转发的同时发表评论，0：否、1：评论给当前微博、2：评论给原微博、3：都评论，默认为0 。
-(void)repost:(NSString*)weiboID content:(NSString*)content withComment:(int)isComment;

//按天返回热门微博转发榜的微博列表
-(void)getHotRepostDaily:(int)count;

//按天返回热门微博评论榜的微博列表
-(void)getHotCommnetDaily:(int)count;

//返回最近一天内的热门话题
-(void)getHOtTrendsDaily;

//获取某个用户的各种消息未读数
-(void)getUnreadCount:(NSString*)uid;

//获取最新的提到登录用户的微博列表，即@我的微博
-(void)getMetionsStatuses;

//获取附近地点
-(void)getPoisWithCoodinate:(CLLocationCoordinate2D)coodinate queryStr:(NSString*)queryStr;

//搜索某一话题下的微博
-(void)searchTopic:(NSString *)queryStr count:(int)count page:(int)page;

//获取某人的话题列表
-(void)getTopicsOfUser:(User*)user;

//回复一条评论
-(void)replyACommentWeiboId:(NSString *)weiboID commentID:(NSString*)commentID content:(NSString*)content;

//对一条微博进行评论
-(void)commentAStatus:(NSString*)weiboID content:(NSString*)content;
@end
