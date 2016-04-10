//
//  UdpSocket.m
//  QinDianSheQu
//
//  Created by 金斗云 on 16/4/5.
//  Copyright © 2016年 Xydawn. All rights reserved.
//

#import "UdpSocket.h"
#import "MBProgressHUD+MJ.h"
#pragma pack (1)
typedef struct _appChargeRequest{
    char           sign[2];        //'QD'
    unsigned char  type;
    char           orderId[32];
    char           payToken[32];
    
}appChargeRequest;

#pragma pack ()

@interface UdpSocket ()
@property (nonatomic)       AsyncUdpSocket *asy;
@property (nonatomic)       AsyncUdpSocket *send;
// 服务器socket
@property (nonatomic) GCDAsyncSocket *sendMessage;
@end

@implementation UdpSocket

-(instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeALLUDP) name:@"closeUDP" object:nil];
    }

    
    return self;
}

-(void)closeALLUDP{
    [self.asy close];
    self.asy = nil;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)creatUdpSocketWith:(id<UdpSocketDelegate>)delegate{
    
    NSError *err = nil;
    
    self.delegate = delegate;
    
    self.asy = [[AsyncUdpSocket alloc]initWithDelegate:self];
    
    BOOL reuslt = [self.asy bindToPort:9999 error:&err];
    
    CHQLog(@"%hhd %@ " ,reuslt,err);
    //启动接收线程
    [self.asy receiveWithTimeout:-1 tag:200];
   
}

-(void)creatSendUdpSocketWithHost:(NSString *)host withMsg:(NSString *)msg{
   
    self.send = [[AsyncUdpSocket alloc]initWithDelegate:self];
    // 我想给ip的机器发送消息msg
    NSData *msgData = [msg dataUsingEncoding:NSUTF8StringEncoding];
    // ip = 192.168.1.22
    // ip = localhost
    [self.send sendData:msgData toHost:host port:9999 withTimeout:-1 tag:200];
    CHQLog(@"数据还没有发完");
    // 给ip的机器端口0x1234发送数据msgData;
    // sendData只是告诉系统发送，但是这个内容还没有发完
    // 我们怎么知道什么时候发送完成

}


-(void)creatTCPSendWithMsg:(NSString *)msg andToken:(NSString *)token andHost:(NSString *)host{
    
    self.sendMessage =[[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    
    BOOL result = [self.sendMessage connectToHost:host onPort:9999 error:&error];
    
    CHQLog(@"%@",error);
    
    // 3. 判断链接是否成功
    if (result) {
        
        CHQLog(@"客户端链接服务器成功");
        
        appChargeRequest *data = malloc(sizeof(appChargeRequest));
        data->sign[0] = 'Q';
        data->sign[1] = 'D';
        data->type = 0xF1;
        memcpy(data->orderId, [msg UTF8String], 32);
        memcpy(data->payToken, [token UTF8String], 32);
        NSData *objData = [NSData dataWithBytes:data length:sizeof(appChargeRequest)];
        [self.sendMessage writeData:objData withTimeout:-1 tag:200];
        free(data);
        
    } else {
        CHQLog(@"客户端链接服务器失败");
    }
}

#pragma mark - UDP
//已接收到消息
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{

    if (tag == 200) {
        NSString *sData = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
        
        if (self.delegate) {
            [self.delegate getUdpReslut:sData andHost:host];
        }
        
    }
    [sock receiveWithTimeout:-1 tag:tag];
    
    return YES;
}
//没有接受到消息
-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error{
    CHQLog(@"未收到连接");
}
//没有发送出消息
-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    
}
//已发送出消息
-(void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    
}
//断开连接
-(void)onUdpSocketDidClose:(AsyncUdpSocket *)sock{
    CHQLog(@"已断开连接");
}

#pragma mark - GCDAsyncSocketDelegate

// 客户端链接服务器端成功, 客户端获取地址和端口号
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    CHQLog(@"%@",[NSString stringWithFormat:@"链接服务器%@", host]);
    
}
- (void)socketDidDisconnect:(GCDAsyncSocket*)sock withError:(NSError*)err {
    
    
    CHQLog(@"连接失败 %@", err);
    
//    [self.sendMessage connectToHost:@"192.168.0.17" onPort:9999 error:&err];
    
    // 断线重连
}

// 客户端已经获取到内容
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    CHQLog(@"%@",content);

}




@end
