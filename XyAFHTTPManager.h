//
//  XyAFHTTPManager.h
//  QinDianSheQu
//
//  Created by 金斗云 on 16/3/11.
//  Copyright © 2016年 Xydawn. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "OutManager.h"



typedef void(^GetResponseObject)(id responseObject);

@interface XyAFHTTPManager : AFHTTPRequestOperationManager


+(AFHTTPRequestOperationManager *)shareManger;

+(AFHTTPRequestOperationManager *)shareJsonManger;

+(void)getDownloadWith:(NSString *)url DataWith:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated andError:(void(^)(NSError *error))errorBlock withHead:(NSDictionary *)head andGetresponseObject:(GetResponseObject)getObjc  andShowToView:(UIView *)view;


+(void)postWithTokenDownloadWith:(NSString *)url DataWith:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated andError:(void(^)(NSError *error))errorBlock withHead:(NSDictionary *)head andGetresponseObject:(GetResponseObject)getObjc andShowToView:(UIView *)view;


+(void)getWithTokenDownloadWith:(NSString *)url DataWith:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated andError:(void(^)(NSError *error))errorBlock withHead:(NSDictionary *)head andGetresponseObject:(GetResponseObject)getObjc andShowToView:(UIView *)view;

+(void)putWithTokenDownloadWith:(NSString *)url DataWith:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated andError:(void(^)(NSError *error))errorBlock withHead:(NSDictionary *)head andGetresponseObject:(GetResponseObject)getObjc andShowToView:(UIView *)view;

+(void)deleteWithTokenDownloadWith:(NSString *)url DataWith:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated andError:(void(^)(NSError *error))errorBlock withHead:(NSDictionary *)head andGetresponseObject:(GetResponseObject)getObjc andShowToView:(UIView *)view;


+(void)getDataWithObject:(id)responseObject DataWith:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated andGetresponseObject:(GetResponseObject)getObjc andShowToView:(UIView *)view;
//登录用接口
+(void)loginWithUrl:(NSString *)url DataWith:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated withHead:(NSDictionary *)head  andShowToView:(UIView *)view;



+(void)postDownloadWith:(NSString *)url DataWith:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated andError:(void(^)(NSError *error))errorBlock withHead:(NSDictionary *)head andGetresponseObject:(GetResponseObject)getObjc andShowToView:(UIView *)view;
@end
