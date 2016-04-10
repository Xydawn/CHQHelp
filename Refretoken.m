//
//  Refretoken.m
//  QinDianSheQu
//
//  Created by 金斗云 on 16/4/6.
//  Copyright © 2016年 Xydawn. All rights reserved.
//

#import "Refretoken.h"

#import "UserInfo.h"

#import "OpenUDID.h"

#import "WXUtil.h"
@interface Refretoken ()

@property (nonatomic,copy) NSString *nonce_str;
@property (nonatomic,copy) NSString *sign;
@property (nonatomic,strong) UserInfo *userinfo;

@end

@implementation Refretoken

+(void)refreTokenWithView:(UIView *)view andUserinfo:(UserInfo *)userinfo{
    
    Refretoken *ref = [[Refretoken alloc]init];
    
    NSInteger chaTime = time(0) - [[Refretoken getK_TIME] integerValue];
    CHQLog(@"%ld",chaTime);
    if (chaTime > 7200) {
        NSString *timeStr = [NSString stringWithFormat:@"%ld",time(0)];
        
        NSString *stringA = [NSString stringWithFormat:@"appid=%@&methoed=app_token&nonce_str=%@&sign_type=MD5&time_stamp=%@&key=%@",K_APPID,ref.nonce_str,timeStr,K_KEY];
        
        stringA = [WXUtil md5:stringA];
        
        [XyAFHTTPManager postDownloadWith:@"/general/user/refretoken" DataWith:^(id dict) {
            
        } andDefeated:^(id dict) {
            
        } andError:^(NSError *error) {
            
        } withHead:@{
                     @"user_id":userinfo.id,
                     @"mobile":userinfo.mobile,
                     @"time_stamp":timeStr,
                     @"uuid":[OpenUDID value],
                     @"nonce_str":ref.nonce_str,
                     @"methoed":@"app_token",
                     @"sign":stringA
                     }
         
         andGetresponseObject:^(id responseObject) {
             
             [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"resources"] forKey:@"sid"];
             [[NSUserDefaults standardUserDefaults]setObject:timeStr forKey:K_TIME];

         } andShowToView:view];

    }
}

+(void)refreTokenWithOurTimeWithView:(UIView *)view{
    
    Refretoken *ref = [[Refretoken alloc]init];
    
    NSString *timeStr = [NSString stringWithFormat:@"%ld",time(0)];
    
    NSString *stringA = [NSString stringWithFormat:@"appid=%@&methoed=app_token&nonce_str=%@&sign_type=MD5&time_stamp=%@&key=%@",K_APPID,ref.nonce_str,timeStr,K_KEY];
    
    stringA = [WXUtil md5:stringA];
    
    [XyAFHTTPManager postDownloadWith:@"/general/user/refretoken" DataWith:^(id dict) {
        
    } andDefeated:^(id dict) {
        
    } andError:^(NSError *error) {
        
    } withHead:@{
                 @"user_id":ref.userinfo.id,
                 @"mobile":ref.userinfo.mobile,
                 @"time_stamp":timeStr,
                 @"uuid":[OpenUDID value],
                 @"nonce_str":ref.nonce_str,
                 @"methoed":@"app_token",
                 @"sign":stringA
                 }
     
                 andGetresponseObject:^(id responseObject) {
                     
                     [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"resources"] forKey:@"sid"];
                     [[NSUserDefaults standardUserDefaults]setObject:timeStr forKey:K_TIME];
                     
                 } andShowToView:view];

}


-(UserInfo *)userinfo{
    
    if (_userinfo == nil) {
        
        _userinfo = [UserInfo shareUserInfo];
    }
    return _userinfo;
}

-(NSString *)nonce_str{
    
    if (_nonce_str == nil) {
        
        _nonce_str = [NSString stringWithFormat:@"%8ld",(long)arc4random()%10000000];
        
    }
    return _nonce_str;
}

+(NSString *)getK_TIME{
    return  [[NSUserDefaults standardUserDefaults]objectForKey:K_TIME];
}


@end
