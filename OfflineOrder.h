//
//  OfflineOrder.h
//  QinDianSheQu
//
//  Created by 金斗云 on 16/4/7.
//  Copyright © 2016年 Xydawn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfflineOrder : NSObject

+(void)setOrderWith:(NSString *)order;

+(NSMutableArray *)getOfflineOrder;

+(void)removeOrderWithOrder:(NSString *)order;
@end
