//
//  OfflineOrder.m
//  QinDianSheQu
//
//  Created by 金斗云 on 16/4/7.
//  Copyright © 2016年 Xydawn. All rights reserved.
//

#import "OfflineOrder.h"

@implementation OfflineOrder

+(void)setOrderWith:(NSString *)order{
    
    NSMutableArray *orderArr = [OfflineOrder getOfflineOrder];
    
    [orderArr addObject:order];
    
    if (orderArr.count >0) {
        [XyCachesManager setNSDocumentDirectoryWith:orderArr withPahtName:K_OfflineOrder];
    }
}

+(NSMutableArray *)getOfflineOrder{
    
    NSMutableArray *orderArr = [NSMutableArray arrayWithArray:[XyCachesManager getNSDocumentDirectoryWithPahtName:K_OfflineOrder]];
    
    return orderArr;
    
}

+(void)removeOrderWithOrder:(NSString *)order{
    
    NSMutableArray *orderArr = [OfflineOrder getOfflineOrder];
    
    [orderArr removeObject:order];
    
    [XyCachesManager setNSDocumentDirectoryWith:orderArr withPahtName:K_OfflineOrder];
    
}

@end
