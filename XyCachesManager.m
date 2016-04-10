//
//  XyCachesManager.m
//  QinDianSheQu
//
//  Created by 金斗云 on 16/3/30.
//  Copyright © 2016年 Xydawn. All rights reserved.
//

#import "XyCachesManager.h"
#import "SDImageCache.h"
#import "UserInfo.h"
@implementation XyCachesManager


+ (double)getCachesSize {
    //换算为M
    //获取SD 字节大小
    double sdSize = [[SDImageCache sharedImageCache] getSize];
    //获取自定义的缓存
    NSString *myCachePath = [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches"];
    //遍历 文件夹 得到一个枚举器
    NSDirectoryEnumerator * enumerator = [[NSFileManager defaultManager] enumeratorAtPath:myCachePath];
    double mySize = 0;
    for (NSString *fileName in enumerator) {
        //获取文件的路径
        NSString *filePath = [myCachePath stringByAppendingPathComponent:fileName];
        //文件属性
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        //统计大小
        mySize += dict.fileSize;
    }
    
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSAllDomainsMask, YES);
    NSString *path = [arr objectAtIndex:0];
    NSDirectoryEnumerator * enumerator1 = [[NSFileManager defaultManager] enumeratorAtPath:path];
    for (NSString *fileName in enumerator1) {
        //获取文件的路径
        NSString *filePath = [myCachePath stringByAppendingPathComponent:fileName];
        //文件属性
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        //统计大小
        mySize += dict.fileSize;
    }

    //1M = 1024k = 1024*1024Byte
    double totalSize = (mySize+sdSize)/1024/1024;//转化为M
    return totalSize;
}

+(void)deletCachesSize {
    [[SDImageCache sharedImageCache] clearMemory];
    //清除磁盘上的图片缓存
    [[SDImageCache sharedImageCache] clearDisk];
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches"];
    [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSAllDomainsMask, YES);
    NSString *path1 = [arr objectAtIndex:0];
    [[NSFileManager defaultManager]removeItemAtPath:path1 error:nil];

}


//存储数据到 NSDocumentDirectory
+(NSString *)setNSDocumentDirectoryWith:(id)dict withPahtName:(NSString *)pathName{
    //先获取 沙盒中的Library/Caches/路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    
    NSString *myCacheDirectory = [docPath stringByAppendingPathComponent:@"MyCaches"];
    //检测MyCaches 文件夹是否存在
    if (![[NSFileManager defaultManager] fileExistsAtPath:myCacheDirectory]) {
        //不存在 那么创建
        [[NSFileManager defaultManager] createDirectoryAtPath:myCacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    UserInfo *user = [UserInfo shareUserInfo];
    if (user.id) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:[myCacheDirectory stringByAppendingPathComponent:user.id]]) {
            //不存在 那么创建
            [[NSFileManager defaultManager] createDirectoryAtPath:[myCacheDirectory stringByAppendingPathComponent:user.id] withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    
    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Library/Caches/MyCaches/%@",user.id]];
    NSString *pStr = [path stringByAppendingString:pathName];
    NSData *data=[[NSData alloc]init];
    data=[NSKeyedArchiver archivedDataWithRootObject:dict];
    [data writeToFile:pStr atomically:YES];
    return pStr;
}
//读取数据到 NSDocumentDirectory
+(id)getNSDocumentDirectoryWithPahtName:(NSString *)pathName{
    UserInfo *user = [UserInfo shareUserInfo];
    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Library/Caches/MyCaches/%@",user.id]];
    NSString *pStr = [path stringByAppendingString:pathName];
    NSData *data1=[NSData dataWithContentsOfFile:pStr];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data1];
}




@end
