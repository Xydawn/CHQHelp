//
//  CreatPayToken.h
//  QinDianSheQu
//
//  Created by 金斗云 on 16/4/9.
//  Copyright © 2016年 Xydawn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreatPayToken : NSObject

+(NSString *)getPayTokenWithPortNO:(NSString *)potrNo;//生成支付凭证


+(NSString *)getPayOidWith:(NSString *)oid;

@end
