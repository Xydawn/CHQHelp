//
//  UdpSocket.h
//  QinDianSheQu
//
//  Created by 金斗云 on 16/4/5.
//  Copyright © 2016年 Xydawn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncUdpSocket.h"
#import "GCDAsyncSocket.h"

@protocol UdpSocketDelegate <NSObject>

-(void)getUdpReslut:(NSString *)data andHost:(NSString *)host;

@end


@interface UdpSocket : NSObject<AsyncUdpSocketDelegate,GCDAsyncSocketDelegate>

@property id<UdpSocketDelegate> delegate;

-(void)creatUdpSocketWith:(id<UdpSocketDelegate>)delegate;

-(void)creatSendUdpSocketWithHost:(NSString *)host withMsg:(NSString *)msg;

-(void)creatTCPSendWithMsg:(NSString *)msg andToken:(NSString *)token andHost:(NSString *)host;

@end
