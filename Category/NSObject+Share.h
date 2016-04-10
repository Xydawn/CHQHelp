//
//  NSObject+Share.h
//  ChildrenSearch
//
//  Created by qingyun on 15/7/17.
//  Copyright (c) 2015年 qingyun.con. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

@interface NSObject (Share)

+ (void)shareWithContent:(NSString *)contentStr
       anddefaultContent:(NSString *)defaultContent
                andTitle:(NSString *)title
                  andnUrl:(NSString *)urlStr
          andDescription:(NSString *)description
            andMediaType:(SSPublishContentMediaType)mediatype;


@end
