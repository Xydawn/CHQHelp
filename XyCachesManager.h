//
//  XyCachesManager.h
//  QinDianSheQu
//
//  Created by 金斗云 on 16/3/30.
//  Copyright © 2016年 Xydawn. All rights reserved.
//

#import <Foundation/Foundation.h>

#define K_USERINFO @"/userlogin"//用户信息缓存
#define K_USERMONEY @"/userremain"//用户余额
#define k_userId @"sid"
static NSString *USERIMG = @"/USERIMG";//头像缓存路径
static NSString *generaltags = @"/generaltags";//用户标签
static NSString *usercost = @"/usercost";//用户消费记录
static NSString *generalsystemmsg = @"/generalsystemmsg";//消息缓存
static NSString *neighborquery = @"/neighborquery";//好友缓存信息
static NSString *neighborfollow = @"/neighborfollow";//好友缓存信息
static NSString *K_TIME = @"TIME(0)";//token 时效时间
static NSString *generalcardquery = @"/generalcardquery";//ID卡列表
static NSString *K_OfflineOrder = @"/OfflineOrder";//离线订单缓存

@interface XyCachesManager : NSObject
+ (double)getCachesSize ;
+(void)deletCachesSize;
+(NSString *)setNSDocumentDirectoryWith:(id)dict withPahtName:(NSString *)pathName;
+(id)getNSDocumentDirectoryWithPahtName:(NSString *)pathName;
@end
