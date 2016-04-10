//
//  CreatPayToken.m
//  QinDianSheQu
//
//  Created by 金斗云 on 16/4/9.
//  Copyright © 2016年 Xydawn. All rights reserved.
//

#import "CreatPayToken.h"

@implementation CreatPayToken

+(NSString *)getPayTokenWithPortNO:(NSString *)potrNo {
    
    NSString *uuid = [[NSUUID UUID] UUIDString];
    
    NSArray *arr = [uuid componentsSeparatedByString:@"-"];
    
    NSMutableString *payToken = [[NSMutableString alloc]init];
    
    for (NSString *str in arr) {
        [payToken appendString:str];
    }
    
    [payToken replaceCharactersInRange:NSMakeRange(0, 5) withString:[NSString stringWithFormat:@"QDTK%@",potrNo]];
    
    CHQLog(@"%@  %ld",payToken,(unsigned long)payToken.length);
    
    return payToken;
}

+(NSString *)getPayOidWith:(NSString *)oid{
    
    NSMutableString * newOid = [[NSMutableString alloc]initWithString:oid];
    
    while (newOid.length<32) {
        
        [newOid insertString:@"0" atIndex:0];
        
    }
    return newOid;
}

@end
