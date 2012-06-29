//
//  WeiBoHttpManager.h
//  test
//
//  Created by jianting zhu on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
#import "StringUtil.h"
#import "NSStringAdditions.h"

#define SINA_V2_DOMAIN              @"https://api.weibo.com/2"
#define SINA_API_AUTHORIZE          @"https://api.weibo.com/oauth2/authorize"
#define SINA_API_ACCESS_TOKEN       @"https://api.weibo.com/oauth2/access_token"

#define SINA_APP_KEY                @"3601604349"
#define SINA_APP_SECRET             @"7894dfdd1fc2ce7cc6e9e9ca620082fb"

#define USER_INFO_KEY_TYPE          @"requestType"

#define USER_STORE_ACCESS_TOKEN     @"SinaAccessToken"
#define USER_STORE_EXPIRATION_DATE  @"SinaExpirationDate"
#define USER_STORE_USER_ID          @"SinaUserID"
#define USER_STORE_USER_NAME        @"SinaUserName"
#define USER_OBJECT                 @"USER_OBJECT"
#define NeedToReLogin               @"NeedToReLogin"

#define MMSinaRequestFailed         @"MMSinaRequestFailed"

typedef enum {
    SinaGetOauthCode = 0,           //authorize_code
    SinaGetOauthToken,              //access_token
    SinaGetRefreshToken,            //refresh_token
    SinaGetPublicTimeline,          //获取最新的公共微博
    SinaGetUserID,                  //获取登陆用户的UID
    SinaGetUserInfo,                //获取任意一个用户的信息
    SinaGetBilateralIdList,         //获取用户双向关注的用户ID列表，即互粉UID列表
    SinaGetBilateralIdListAll,      
    SinaGetBilateralUserList,       //获取用户的双向关注user列表，即互粉列表
    SinaGetBilateralUserListAll,
    SinaFollowByUserID,             //关注一个用户 by User ID
    SinaFollowByUserName,           //关注一个用户 by User Name
    SinaUnfollowByUserID,           //取消关注一个用户 by User ID
    SinaUnfollowByUserName,         //取消关注一个用户 by User Name
    SinaGetTrendStatues,            //获取某话题下的微博消息
    SinaFollowTrend,                //关注某话题
    SinaUnfollowTrend,              //取消对某话题的关注
    SinaPostText,                   //发布文字微博
    SinaPostTextAndImage,           //发布文字图片微博
    SinaGetHomeLine,                //获取当前登录用户及其所关注用户的最新微博
    SinaGetComment,                 //根据微博消息ID返回某条微博消息的评论列表
    SinaGetUserStatus,              //获取某个用户最新发表的微博列表
    SinaRepost,                     //转发一条微博
    SinaGetFollowingUserList,       //获取用户的关注列表
    SinaGetFollowedUserList,        //获取用户粉丝列表
    SinaGetHotRepostDaily,          //按天返回热门微博转发榜的微博列表
    SinaGetHotCommentDaily,         //按天返回热门微博评论榜的微博列表
    SinaGetHotTrendDaily,
    SinaGetUnreadCount,             //获取某个用户的各种消息未读数
    SINAGetMetionsStatuses,         //获取最新的提到登录用户的微博列表，即@我的微博
}RequestType;

@class ASINetworkQueue;
@class Status;
@class User;


//Delegate
@protocol WeiBoHttpDelegate <NSObject>

@optional
//获取最新的公共微博
-(void)didGetPublicTimelineWithStatues:(NSArray*)statusArr;

//获取登陆用户的UID
-(void)didGetUserID:(NSString*)userID;

//获取任意一个用户的信息
-(void)didGetUserInfo:(User*)user;

//根据微博消息ID返回某条微博消息的评论列表
-(void)didGetCommentList:(NSDictionary *)commentInfo;

//获取用户双向关注的用户ID列表，即互粉UID列表
-(void)didGetBilateralIdList:(NSArray*)arr;

//获取用户的双向关注user列表，即互粉列表
-(void)didGetBilateralUserList:(NSArray*)userArr;

//获取用户的关注列表
-(void)didGetFollowingUsersList:(NSArray*)userArr;

//获取用户粉丝列表
-(void)didGetFollowedUsersList:(NSArray*)userArr;

//获取某话题下的微博消息
-(void)didGetTrendStatues:(NSArray*)statusArr;

//关注一个用户 by User ID
-(void)didFollowByUserIDWithResult:(NSDictionary*)resultDic;

//取消关注一个用户 by User ID
-(void)didUnfollowByUserIDWithResult:(NSDictionary*)resultDic;

//关注某话题
-(void)didGetTrendIDAfterFollowed:(int64_t)topicID;

//取消对某话题的关注
-(void)didGetTrendResultAfterUnfollowed:(BOOL)isTrue;

//发布微博
-(void)didGetPostResult:(Status*)sts;

//获取当前登录用户及其所关注用户的最新微博
-(void)didGetHomeLine:(NSArray*)statusArr;

//获取某个用户最新发表的微博列表
-(void)didGetUserStatus:(NSArray*)statusArr;

//转发一条微博
-(void)didRepost:(Status*)sts;

//按天返回热门微博转发榜的微博列表
-(void)didGetHotRepostDaily:(NSArray*)statusArr;

//按天返回热门微博评论榜的微博列表
-(void)didGetHotCommentDaily:(NSArray*)statusArr;

//返回最近一天内的热门话题
-(void)didGetHotTrendDaily:(NSArray*)trendsArr;

//获取某个用户的各种消息未读数
-(void)didGetUnreadCount:(NSDictionary*)dic;

//获取最新的提到登录用户的微博列表，即@我的微博
-(void)didGetMetionsStatused:(NSArray*)statusArr;

@end

@interface WeiBoHttpManager : NSObject
{
    ASINetworkQueue *requestQueue;
    id<WeiBoHttpDelegate> delegate;
    
    NSString *authCode;
    NSString *authToken;
    NSString *userId;
}

@property (nonatomic,retain) ASINetworkQueue *requestQueue;
@property (nonatomic,assign) id<WeiBoHttpDelegate> delegate;
@property (nonatomic,copy) NSString *authCode;
@property (nonatomic,copy) NSString *authToken;
@property (nonatomic,copy) NSString *userId;

- (id)initWithDelegate:(id)theDelegate;

- (BOOL)isRunning;
- (void)start;
- (void)pause;
- (void)resume;
- (void)cancel;

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
-(void)getCommentListWithID:(long long)weiboID;

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
-(void)followByUserID:(long long)uid;

//关注一个用户 by User Name
-(void)followByUserName:(NSString*)userName;

//取消关注一个用户 by User ID
-(void)unfollowByUserID:(long long)uid;

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

@end
