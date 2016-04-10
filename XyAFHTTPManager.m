//
//  XyAFHTTPManager.m
//  QinDianSheQu
//
//  Created by 金斗云 on 16/3/11.
//  Copyright © 2016年 Xydawn. All rights reserved.
//

#import "XyAFHTTPManager.h"
#import "GDataXMLElement+util.h"
#import "MBProgressHUD+MJ.h"
#import "OpenUDID.h"
#import "Refretoken.h"
@implementation XyAFHTTPManager

+(AFHTTPRequestOperationManager *)shareManger{
    AFHTTPRequestOperationManager *manger;
    manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer = [AFJSONRequestSerializer serializer];
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    return manger;
}

+(AFHTTPRequestOperationManager *)shareJsonManger{
    AFHTTPRequestOperationManager *manger;
    manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer = [AFJSONRequestSerializer serializer];
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    [manger.requestSerializer setValue:[OpenUDID value] forHTTPHeaderField:@"Machinecode"];
    return manger;
}
//[[UIDevice currentDevice].identifierForVendor UUIDString]


//+(AFHTTPRequestOperationManager *)sharePutManger{
//    static AFHTTPRequestOperationManager *manger;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manger = [AFHTTPRequestOperationManager manager];
//        manger.requestSerializer = [AFJSONRequestSerializer serializer];
//        manger.responseSerializer = [AFJSONResponseSerializer serializer];
//        [manger.requestSerializer setValue:@"11111" forHTTPHeaderField:@"Machinecode"];
//    });
//    return manger;
//}


+(void)getDownloadWith:(NSString *)url DataWith:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated andError:(void(^)(NSError *error))errorBlock withHead:(NSDictionary *)head andGetresponseObject:(GetResponseObject)getObjc andShowToView:(UIView *)view{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (view) {
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    
    [[self shareManger]GET:[NSString stringWithFormat:@"%@%@",K_HEAD,url] parameters:head success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (view) {
        [MBProgressHUD hideHUDForView:view animated:YES];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (responseObject) {
            
            if (getObjc) {
                getObjc(responseObject);
            }
            
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseObject options:0 error:nil];
            NSData *jsonData = [doc.rootElement.stringValue dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            CHQLog(@"%@",dict);
            
            if ([dict[@"status"] isEqualToNumber:@0]) {
                if (succeed) {
                    CHQLog(@"%@",dict[@"data"]);
                    succeed(dict[@"data"]);
                }
            }else{
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD showError:dict[@"msg"]];
                });

                
                if (defeated) {
                    defeated(dict);
                }
            }
            
       
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD showError:@"请求异常"];
            });
 
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        CHQLog(@"%@",operation);
        CHQLog(@"%@",error);
        
        if (view) {
            
            [MBProgressHUD hideHUDForView:view animated:YES];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD showError:@"网络请求失败"];
        });

        if (errorBlock) {
            errorBlock(error);
        }
    }];
    
}

+(void)getWithTokenDownloadWith:(NSString *)url DataWith:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated andError:(void(^)(NSError *error))errorBlock withHead:(NSDictionary *)head andGetresponseObject:(GetResponseObject)getObjc andShowToView:(UIView *)view{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (view) {
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    
    AFHTTPRequestOperationManager *manger = [self shareJsonManger];
    
    [manger.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"sid"] forHTTPHeaderField:@"E-Auth-Token"];
    XY(weakSelf)
    
    [manger GET:[NSString stringWithFormat:@"%@%@",K_HEAD2,url] parameters:head success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CHQLog(@"%@  %@",operation.responseString , head);
        
        [weakSelf getDataWithObject:responseObject DataWith:succeed andDefeated:defeated andGetresponseObject:getObjc andShowToView:view];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        CHQLog(@"%@",operation);
        CHQLog(@"%@",error);
        
        if (view) {
            
            [MBProgressHUD hideHUDForView:view animated:YES];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([error.localizedDescription isEqualToString:@"未能读取数据，因为它的格式不正确。"]) {
                [MBProgressHUD showError:@"未能获取到数据！"];
            }else{
                [MBProgressHUD showError:error.localizedDescription];
            }
        });
        
        if (errorBlock) {
            errorBlock(error);
        }
    }];
    
}

+(void)postWithTokenDownloadWith:(NSString *)url DataWith:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated andError:(void(^)(NSError *error))errorBlock withHead:(NSDictionary *)head andGetresponseObject:(GetResponseObject)getObjc andShowToView:(UIView *)view{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (view) {
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    
    AFHTTPRequestOperationManager *manger = [self shareJsonManger];


    [manger.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"sid"] forHTTPHeaderField:@"E-Auth-Token"];
    XY(weakSelf)
    
    [manger POST:[NSString stringWithFormat:@"%@%@",K_HEAD2,url] parameters:head success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CHQLog(@"%@  %@",operation.responseString , head);
        [weakSelf getDataWithObject:responseObject DataWith:succeed andDefeated:defeated andGetresponseObject:getObjc andShowToView:view];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        CHQLog(@"%@",operation);
        CHQLog(@"%@",error);
        
        if (view) {
            
            [MBProgressHUD hideHUDForView:view animated:YES];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([error.localizedDescription isEqualToString:@"未能读取数据，因为它的格式不正确。"]) {
                [MBProgressHUD showError:@"未能获取到数据！"];
            }else{
                [MBProgressHUD showError:error.localizedDescription];
            }
        });
        
        if (errorBlock) {
            errorBlock(error);
        }
    }];
    
}


+(void)postDownloadWith:(NSString *)url DataWith:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated andError:(void(^)(NSError *error))errorBlock withHead:(NSDictionary *)head andGetresponseObject:(GetResponseObject)getObjc andShowToView:(UIView *)view{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (view) {
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    
    AFHTTPRequestOperationManager *manger = [self shareManger];
    
    XY(weakSelf)
    
    [manger POST:[NSString stringWithFormat:@"%@%@",K_HEAD2,url] parameters:head success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CHQLog(@"%@  %@",operation.responseString , head);
        
        [weakSelf getDataWithObject:responseObject DataWith:succeed andDefeated:defeated andGetresponseObject:getObjc andShowToView:view];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        CHQLog(@"%@",operation);
        CHQLog(@"%@",error);
        
        if (view) {
            
            [MBProgressHUD hideHUDForView:view animated:YES];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([error.localizedDescription isEqualToString:@"未能读取数据，因为它的格式不正确。"]) {
                [MBProgressHUD showError:@"未能获取到数据！"];
            }else{
                [MBProgressHUD showError:error.localizedDescription];
            }
        });
        
        if (errorBlock) {
            errorBlock(error);
        }
    }];
    
}

+(void)deleteWithTokenDownloadWith:(NSString *)url DataWith:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated andError:(void(^)(NSError *error))errorBlock withHead:(NSDictionary *)head andGetresponseObject:(GetResponseObject)getObjc andShowToView:(UIView *)view{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (view) {
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    
    AFHTTPRequestOperationManager *manger = [self shareJsonManger];
    
    
    [manger.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"sid"] forHTTPHeaderField:@"E-Auth-Token"];
    XY(weakSelf)
    
    [manger DELETE:[NSString stringWithFormat:@"%@%@",K_HEAD2,url] parameters:head success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CHQLog(@"%@  %@",operation.responseString , head);
        [weakSelf getDataWithObject:responseObject DataWith:succeed andDefeated:defeated andGetresponseObject:getObjc andShowToView:view];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        CHQLog(@"%@",operation);
        CHQLog(@"%@",error);
        
        if (view) {
            
            [MBProgressHUD hideHUDForView:view animated:YES];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([error.localizedDescription isEqualToString:@"未能读取数据，因为它的格式不正确。"]) {
                [MBProgressHUD showError:@"未能获取到数据！"];
            }else{
                [MBProgressHUD showError:error.localizedDescription];
            }
        });
        
        if (errorBlock) {
            errorBlock(error);
        }
    }];
    
}


+(void)putWithTokenDownloadWith:(NSString *)url DataWith:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated andError:(void(^)(NSError *error))errorBlock withHead:(NSDictionary *)head andGetresponseObject:(GetResponseObject)getObjc andShowToView:(UIView *)view{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (view) {
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    
    AFHTTPRequestOperationManager *manger = [self shareJsonManger];
    
    
    [manger.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"sid"] forHTTPHeaderField:@"E-Auth-Token"];
    
    XY(weakSelf)
    [manger PUT:[NSString stringWithFormat:@"%@%@",K_HEAD2,url] parameters:head success:^(AFHTTPRequestOperation *operation, id responseObject) {

        CHQLog(@"%@  %@",operation.responseString , head);
        [weakSelf getDataWithObject:responseObject DataWith:succeed andDefeated:defeated andGetresponseObject:getObjc andShowToView:view];
        
   
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        CHQLog(@"%@",operation);
        CHQLog(@"%@",error);
        
        if (view) {
            
            [MBProgressHUD hideHUDForView:view animated:YES];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([error.localizedDescription isEqualToString:@"未能读取数据，因为它的格式不正确。"]) {
                [MBProgressHUD showError:@"未能获取到数据！"];
            }else{
                [MBProgressHUD showError:error.localizedDescription];
            }
        });
        
        if (errorBlock) {
            errorBlock(error);
        }
    }];
    
}


+(void)loginWithUrl:(NSString *)url DataWith:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated withHead:(NSDictionary *)head  andShowToView:(UIView *)view{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    
    manger = [AFHTTPRequestOperationManager manager];
    
    manger.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manger POST:[NSString stringWithFormat:@"%@%@",K_HEAD2,url] parameters:head success:^(AFHTTPRequestOperation *operation, id responseObject) {
   
        [MBProgressHUD hideHUDForView:view animated:YES];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (responseObject) {
            
            CHQLog(@"%@  %@",operation.responseString , head);
            
            
            
            
            if ([responseObject[@"status"] integerValue]==-1) {
                
                [OutManager APPOUTWITHALERTWithString:responseObject[@"info"]];
                
            }else if ([responseObject[@"status"] isEqualToNumber:@1]) {
                if (succeed) {
 
                    succeed(responseObject[@"resources"]);
                }
            }else{
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD showError:responseObject[@"info"]];
                });
                
                
                if (defeated) {
                    defeated(responseObject);
                }
            }
            
            
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD showError:@"请求异常"];
            });
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        CHQLog(@"%@",operation);
        CHQLog(@"%@",error);

        [MBProgressHUD hideHUDForView:view animated:YES];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([error.localizedDescription isEqualToString:@"未能读取数据，因为它的格式不正确。"]) {
                [MBProgressHUD showError:@"未能获取到数据！"];
            }else{
                [MBProgressHUD showError:error.localizedDescription];
            }
        });
        
    }];
    
}


+(void)getDataWithObject:(id)responseObject DataWith:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated andGetresponseObject:(GetResponseObject)getObjc andShowToView:(UIView *)view{
    if (view) {
        [MBProgressHUD hideHUDForView:view animated:YES];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    
    if (getObjc) {
        getObjc(responseObject);
    }
    
    if (responseObject) {
        
        
        
        if ([responseObject[@"status"] integerValue]== 2 ) {
            
            [Refretoken refreTokenWithOurTimeWithView:view];
            
        }else
        
        if ([responseObject[@"status"] integerValue]==-1) {
            
            [OutManager APPOUTWITHALERTWithString:responseObject[@"info"]];
            
        }else
        
        if ([responseObject[@"status"] isEqualToNumber:@1]) {
            
            if (succeed) {
                
                if (![responseObject[@"resources"] isKindOfClass:[NSNull class]]) {
                    CHQLog(@"%@",responseObject[@"resources"]);
                    succeed(responseObject[@"resources"]);
                }else{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [MBProgressHUD showError:@"暂无数据"];
                    });
                    
                }
                
            }
        }else{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD showError:responseObject[@"info"]];
            });
            
            
            if (defeated) {
                defeated(responseObject);
            }
        }
        
        
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD showError:@"请求异常"];
        });
        
    }
    
}



@end
