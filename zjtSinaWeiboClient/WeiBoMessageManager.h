//
//  WeiBoMessageManager.h
//  test
//
//  Created by jianting zhu on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiBoHttpManager.h"

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

//获取某话题下的微博消息
//返回成员为Status的NSArray
#define MMSinaGotTrendStatues @"MMSinaGotTrendStatues"

//关注一个用户 by User ID
//返回一个int(NSNumber)值，int == 0 成功，int == 1，失败
#define MMSinaFollowedByUserIDWithResult @"MMSinaFollowedByUserIDWithResult"

//取消关注一个用户 by User ID
//返回一个int(NSNumber)值，int == 0 成功，int == 1，失败
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

//根据微博消息ID返回某条微博消息的评论列表
-(void)getCommentListWithID:(long long)weiboID;

//获取用户双向关注的用户ID列表，即互粉UID列表 
-(void)getBilateralIdListAll:(long long)uid sort:(int)sort;
-(void)getBilateralIdList:(long long)uid count:(int)count page:(int)page sort:(int)sort;

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
-(void)postWithText:(NSString *)text imageName:(NSString*)imageName;

//获取当前登录用户及其所关注用户的最新微博
-(void)getHomeLine:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count page:(int)page baseApp:(int)baseApp feature:(int)feature;

@end
