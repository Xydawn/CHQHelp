//
//  UIViewController+Showalert.m
//  TangXianManual
//
//  Created by lq on 15/9/10.
//  Copyright (c) 2015年 Han. All rights reserved.
//

#import "UIViewController+Showalert.h"
#import <objc/runtime.h>
#import "LZXHelper.h"
typedef void(^ActionBlock) (void);
static char key;
@implementation UIViewController (Showalert)
-(UIAlertView *)showOnAlertViewWithTitle:(NSString *)title msg:(NSString *)msg{
    UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:title message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    return alert;
}

-(void)addPanGestureRecognizerToView{
    UISwipeGestureRecognizer *pan = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(popToUIViewController)];
    pan.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:pan];
}

-(void)popToUIViewController{
    /*
     - (BOOL)isBeingPresented ;
     - (BOOL)isBeingDismissed ;
     
     - (BOOL)isMovingToParentViewController ;
     - (BOOL)isMovingFromParentViewController
     */
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UITapGestureRecognizer *)addTapWithClick:(void (^)(void))block With:(UIView *)view{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionClick:)];
    objc_setAssociatedObject(view, &key, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [view addGestureRecognizer:tap];
    return tap;
}
-(void)actionClick:(UITapGestureRecognizer *)tap{
    ActionBlock block = objc_getAssociatedObject(tap.view, &key);
    if (block) {
        block();
    }
}

-(AFHTTPRequestOperationManager *)shareManger{
    static AFHTTPRequestOperationManager *manger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [AFHTTPRequestOperationManager manager];
        manger.requestSerializer = [AFHTTPRequestSerializer serializer];
        manger.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    return manger;
}

#pragma mark - 数据下载
-(void)getDownloadWith:(NSString *)url DataWith:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated with:(NSDictionary *)head showWith:(UITableView *)tabelview{

    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([self huanCunChuLiWithPath:url andSuceess:succeed]) {
        if (tabelview) {
            [tabelview footerEndRefreshing];
            [tabelview headerEndRefreshing];
            [tabelview reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [self shareManger];

   
    
    __weak typeof(self) weakSelf = self;
    [manager GET:[NSString stringWithFormat:@"%@%@",K_HEAD,url] parameters:head success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            CHQLog(@"url+++++++%@",operation.request);
            CHQLog(@"%@",responseObject);
            NSData *data=[[NSData alloc]init];
            data=[NSKeyedArchiver archivedDataWithRootObject:responseObject];
            [data writeToFile:[LZXHelper getFullPathWithFile:url] atomically:YES];
            NSString * status =responseObject[@"head"][@"status"];

            if ([status isEqualToString:@"success"]) {
                succeed(responseObject[@"body"]);

            }else{
                NSString *message = responseObject[@"head"][@"msg"];
                [weakSelf showHint:message];
                defeated(responseObject[@"body"]);
            }
      
        }else{
            [weakSelf showHint:@"请求异常"];
        }
        if (tabelview) {
            [tabelview footerEndRefreshing];
            [tabelview headerEndRefreshing];
            [tabelview reloadData];
        }
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (tabelview) {
            [tabelview footerEndRefreshing];
            [tabelview headerEndRefreshing];
        }
          [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        CHQLog(@"%@",error);
        [weakSelf showHint:@"请求异常"];
    }];

}


-(void)getDownloadWith:(NSString *)url DataWith:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated with:(NSDictionary *)head showOnCollView:(UICollectionView *)collView{
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([self huanCunChuLiWithPath:url andSuceess:succeed]) {
        if (collView) {
            [collView footerEndRefreshing];
            [collView headerEndRefreshing];
            [collView reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [self shareManger];
    
    
    
    __weak typeof(self) weakSelf = self;
    [manager GET:[NSString stringWithFormat:@"%@%@",K_HEAD,url] parameters:head success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            CHQLog(@"url+++++++%@",operation.request);
            CHQLog(@"%@",responseObject);
            NSData *data=[[NSData alloc]init];
            data=[NSKeyedArchiver archivedDataWithRootObject:responseObject];
            [data writeToFile:[LZXHelper getFullPathWithFile:url] atomically:YES];
            NSString * status =responseObject[@"head"][@"status"];
            
            if ([status isEqualToString:@"success"]) {
                succeed(responseObject[@"body"]);
                
            }else{
                NSString *message = responseObject[@"head"][@"msg"];
                [weakSelf showHint:message];
                defeated(responseObject[@"body"]);
            }
            
        }else{
            [weakSelf showHint:@"请求异常"];
        }
        if (collView) {
            [collView footerEndRefreshing];
            [collView headerEndRefreshing];
            [collView reloadData];
        }
       [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (collView) {
            [collView footerEndRefreshing];
            [collView headerEndRefreshing];
        }
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        CHQLog(@"%@",error);
        [weakSelf showHint:@"请求异常"];
    }];
    
}
-(void)getDownloadWith:(NSString *)url with:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated with:(NSDictionary *)head showOnCollView:(UICollectionView *)collView{
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [self shareManger];
    
    
    
    __weak typeof(self) weakSelf = self;
    [manager GET:[NSString stringWithFormat:@"%@%@",K_HEAD,url] parameters:head success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            CHQLog(@"url+++++++%@",operation.request);
            CHQLog(@"%@",responseObject);
            NSData *data=[[NSData alloc]init];
            data=[NSKeyedArchiver archivedDataWithRootObject:responseObject];
            [data writeToFile:[LZXHelper getFullPathWithFile:url] atomically:YES];
            NSString * status =responseObject[@"head"][@"status"];
            
            if ([status isEqualToString:@"success"]) {
                succeed(responseObject[@"body"]);
                
            }else{
                NSString *message = responseObject[@"head"][@"msg"];
                [weakSelf showHint:message];
                defeated(responseObject[@"body"]);
            }
            
        }else{
            [weakSelf showHint:@"请求异常"];
        }
        if (collView) {
            [collView footerEndRefreshing];
            [collView headerEndRefreshing];
            [collView reloadData];
        }
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (collView) {
            [collView footerEndRefreshing];
            [collView headerEndRefreshing];
        }
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        CHQLog(@"%@",error);
        [weakSelf showHint:@"请求异常"];
    }];
    
}



-(void)getDownloadWith:(NSString *)url With:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated with:(NSDictionary *)head{
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    AFHTTPRequestOperationManager *manager = [self shareManger];
    

    
    __weak typeof(self) weakSelf = self;
    [manager GET:[NSString stringWithFormat:@"%@%@",K_HEAD,url] parameters:head success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            CHQLog(@"url+++++++%@",operation.request);
            CHQLog(@"%@",responseObject);
            NSString * status =responseObject[@"head"][@"status"];
            
            if ([status isEqualToString:@"success"]) {
                succeed(responseObject[@"body"]);
                
            }else{
                NSString *message = responseObject[@"head"][@"msg"];
                [weakSelf showHint:message];
                defeated(responseObject[@"body"]);
            }
            
        }else{
            [weakSelf showHint:@"请求异常"];
        }
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        CHQLog(@"%@",error);
        CHQLog(@"%@'",operation.request)
        [weakSelf showHint:@"请求异常"];
        if (objc_getAssociatedObject(weakSelf, @"errorBlock")) {
            void(^errorBlock)(void) =objc_getAssociatedObject(weakSelf, @"errorBlock");
            errorBlock();
        }
    }];
    
}

-(void)postDownloadWith:(NSString *)url DataWith:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated with:(NSDictionary *)head showWith:(UITableView *)tabelview{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([self huanCunChuLiWithPath:url andSuceess:succeed]) {
        if (tabelview) {
            [tabelview footerEndRefreshing];
            [tabelview headerEndRefreshing];
            [tabelview reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }

    
    AFHTTPRequestOperationManager *manager = [self shareManger];
    
    
    __weak typeof(self) weakSelf = self;
    [manager POST:[NSString stringWithFormat:@"%@%@",K_HEAD,url] parameters:head success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            CHQLog(@"url+++++++%@",operation.request);
            CHQLog(@"%@",responseObject);
            NSData *data=[[NSData alloc]init];
            data=[NSKeyedArchiver archivedDataWithRootObject:responseObject];
            [data writeToFile:[LZXHelper getFullPathWithFile:url] atomically:YES];
            NSString * status =[responseObject[@"head"][@"status"] stringValue];
            
       
            
            if ([status isEqualToString:@"success"]) {
                succeed(responseObject[@"body"]);
                
            }else{
                NSString *message = responseObject[@"head"][@"msg"];
                [weakSelf showHint:message];
                defeated(responseObject[@"body"]);
            }
            
        }else{
            [weakSelf showHint:@"请求异常"];
        }
        if (tabelview) {
            [tabelview footerEndRefreshing];
            [tabelview headerEndRefreshing];
            [tabelview reloadData];
        }
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (tabelview) {
            [tabelview footerEndRefreshing];
            [tabelview headerEndRefreshing];
        }
        CHQLog(@"%@",error);
          [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf showHint:@"请求异常"];
    }];
    
}



-(void)postDownloadWith:(NSString *)url DataWith:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated with:(NSDictionary *)head{
    AFHTTPRequestOperationManager *manager = [self shareManger];
    
//    if ([self huanCunChuLiWithPath:url andSuceess:succeed]) {
//   
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        return;
//    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [manager POST:[NSString stringWithFormat:@"%@%@",K_HEAD,url] parameters:head success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
//            NSData *data=[[NSData alloc]init];
//            data=[NSKeyedArchiver archivedDataWithRootObject:responseObject];
//            [data writeToFile:[LZXHelper getFullPathWithFile:url] atomically:YES];
            CHQLog(@"url+++++++%@",operation.request);
            CHQLog(@"%@",responseObject);
            
            NSString * status =responseObject[@"head"][@"status"]  ;
        
            
            if ([status isEqualToString:@"success"]) {
                succeed(responseObject[@"body"]);
                
            }else{
                NSString *message = responseObject[@"head"][@"msg"];
                [weakSelf showHint:message];
                defeated(responseObject[@"body"]);
            }
            
        }else{
            
            [weakSelf showHint:@"服务器异常"];
        }
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CHQLog(@"%@",error);
        CHQLog(@"%@",operation.responseString);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf showHint:@"请求异常"];
    }];

}
- (void)customizedNavBarWithTitle:(NSString *)title
{
//    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
//    labelTitle.text = title;
//    labelTitle.font = [UIFont boldSystemFontOfSize:14];
//    labelTitle.textAlignment = NSTextAlignmentCenter;
//    labelTitle.textColor = [UIColor blackColor];
//    self.navigationItem.titleView = labelTitle;
    self.title = title;
}

-(NSString *)getUserId{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    
}

-(NSString *)getUserName{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
}
-(NSString *)getUserPassword{
    NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:@"userpassword"];
    return  [password md5sum];
}

//缓存处理
-(BOOL)huanCunChuLiWithPath:(NSString *)url andSuceess:(void(^)(id dict))succeed{
    
    NSString *path =[LZXHelper getFullPathWithFile:url];
    CHQLog(@"缓存路径===%@",path)
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    BOOL isTimeout = [LZXHelper isTimeOutWithFile:path timeOut:24*60*60];
    if ((isExist == YES)&&(isTimeout == NO) ) {
        NSData *data = [NSData dataWithContentsOfFile:[LZXHelper getFullPathWithFile:url]];
        NSDictionary *dict =[NSKeyedUnarchiver unarchiveObjectWithData:data];
        succeed(dict[@"body"]);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showHint:@"缓存加载完成"];
        return 1;
    }else{
        return 0;
    }
}

//存储数据到 NSDocumentDirectory
-(NSString *)setNSDocumentDirectoryWith:(id)dict withPahtName:(NSString *)pathName{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSAllDomainsMask, YES);
    NSString *path = [arr objectAtIndex:0];
    NSString *pStr = [path stringByAppendingString:pathName];
    NSData *data=[[NSData alloc]init];
    data=[NSKeyedArchiver archivedDataWithRootObject:dict];
    [data writeToFile:pStr atomically:YES];
    return pStr;
}
//读取数据到 NSDocumentDirectory
-(id)getNSDocumentDirectoryWithPahtName:(NSString *)pathName{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSAllDomainsMask, YES);
    NSString *path = [arr objectAtIndex:0];
    NSString *pStr = [path stringByAppendingString:pathName];
    NSData *data1=[NSData dataWithContentsOfFile:pStr];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data1];
}


@end
