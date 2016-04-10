//
//  GetSSID.m
//  QinDianSheQu
//
//  Created by 金斗云 on 16/4/5.
//  Copyright © 2016年 Xydawn. All rights reserved.
//

#import "GetSSID.h"

#import <SystemConfiguration/CaptiveNetwork.h>

@implementation GetSSID

- (NSString *)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    
    NSString *ssid = [[info objectForKey:@"SSID"] lowercaseString];
    
    return ssid;
}

@end
