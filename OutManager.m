//
//  OutManager.m
//  QinDianSheQu
//
//  Created by 金斗云 on 16/4/1.
//  Copyright © 2016年 Xydawn. All rights reserved.
//

#import "OutManager.h"
#import "JPUSHService.h"
#import "AppDelegate.h"

@interface OutManager ()

@end


@implementation OutManager
+(void)APPOUT{
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"sid"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"SHEQU"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:K_USERINFO];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:K_TIME];
    [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
    AppDelegate *del = [[UIApplication sharedApplication]delegate];
    [del loginOrOut];
}



+(void)APPOUTWITHALERTWithString:(NSString *)string{
    [OutManager APPOUT];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alert show];
    
}
@end
