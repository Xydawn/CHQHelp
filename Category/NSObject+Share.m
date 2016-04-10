//
//  NSObject+Share.m
//  ChildrenSearch
//
//  Created by qingyun on 15/7/17.
//  Copyright (c) 2015年 qingyun.con. All rights reserved.
//

#import "NSObject+Share.h"


@implementation NSObject (Share)


+ (void)shareWithContent:(NSString *)contentStr
       anddefaultContent:(NSString *)defaultContent
                andTitle:(NSString *)title
                  andnUrl:(NSString *)urlStr
          andDescription:(NSString *)description
            andMediaType:(SSPublishContentMediaType)mediatype {
    //    社会化分享
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
    //构造分享内容
    id<ISSContent> content = [ShareSDK content:contentStr
                                defaultContent:nil
                                         image:[ShareSDK imageWithPath:imagePath]
                                         title:title
                                           url:urlStr
                                   description:description
                                     mediaType:mediatype];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];

    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:content
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];

}

@end
