//
//  Refretoken.h
//  QinDianSheQu
//
//  Created by 金斗云 on 16/4/6.
//  Copyright © 2016年 Xydawn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
@interface Refretoken : NSObject

+(void)refreTokenWithOurTimeWithView:(UIView *)view;

+(void)refreTokenWithView:(UIView *)view andUserinfo:(UserInfo *)userinfo;

+(NSString *)getK_TIME;
@end

