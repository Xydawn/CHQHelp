//
//  UIViewController+Showalert.h
//  TangXianManual
//
//  Created by lq on 15/9/10.
//  Copyright (c) 2015年 Han. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Showalert)

-(UIAlertView *)showOnAlertViewWithTitle:(NSString *)title msg:(NSString *)msg;

-(void)addPanGestureRecognizerToView;


-(NSString *)getUserId;
-(NSString *)getUserPassword;
-(NSString *)getUserName;

- (void)customizedNavBarWithTitle:(NSString *)title;

-(AFHTTPRequestOperationManager *)shareManger;

-(void)getDownloadWith:(NSString *)url DataWith:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated with:(NSDictionary *)head showWith:(UITableView *)tabelview;

-(void)getDownloadWith:(NSString *)url With:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated with:(NSDictionary *)head;

-(void)postDownloadWith:(NSString *)url DataWith:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated with:(NSDictionary *)head showWith:(UITableView *)tabelview;

-(void)postDownloadWith:(NSString *)url DataWith:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated with:(NSDictionary *)head;

-(void)getDownloadWith:(NSString *)url with:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated with:(NSDictionary *)head showOnCollView:(UICollectionView *)collView;

-(void)getDownloadWith:(NSString *)url DataWith:(void(^)(id dict))succeed andDefeated:(void(^)(id dict))defeated with:(NSDictionary *)head showOnCollView:(UICollectionView *)collView;
//缓存处理
-(BOOL)huanCunChuLiWithPath:(NSString *)url andSuceess:(void(^)(id dict))succeed;

//存储数据到  NSDocumentDirectory
-(NSString *)setNSDocumentDirectoryWith:(id)dict withPahtName:(NSString *)pathName;
//读取数据从  NSDocumentDirectory
-(id)getNSDocumentDirectoryWithPahtName:(NSString *)pathName;


-(void)pushViewControllerWithName:(NSString *)name;

/*
 //保持文字居左   图片居右
 [_button setTitleEdgeInsets:UIEdgeInsetsMake(0, -_button.imageView.frame.size.width, 0, _button.imageView.frame.size.width)];
 [_button setImageEdgeInsets:UIEdgeInsetsMake(0, _button.titleLabel.bounds.size.width, 0, -_button.titleLabel.bounds.size.width)];
 */

/*
 #pragma mark - 选取图片 #import <AVFoundation/AVFoundation.h> UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate
 
 -(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
 switch (buttonIndex) {
 case 0:{
 UIImagePickerController *picker = [[UIImagePickerController alloc]init];
 picker.delegate = self;
 picker.allowsEditing = YES;
 UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
 if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
 
 picker.sourceType = sourceType;
 if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
 {
 //判断相机是否能够使用
 AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
 if(status == AVAuthorizationStatusAuthorized) {
 // authorized
 [self presentViewController:picker animated:YES completion:nil];
 } else if(status == AVAuthorizationStatusDenied){
 // denied
 return ;
 } else if(status == AVAuthorizationStatusRestricted){
 // restricted
 } else if(status == AVAuthorizationStatusNotDetermined){
 // not determined
 [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
 if(granted){
 [self presentViewController:picker animated:YES completion:nil];
 } else {
 return;
 }
 }];
 }
 }
 
 }else
 {
 NSLog(@"模拟其中无法打开相机,请在真机中使用");
 }
 
 }
 break;
 case 1:{
 UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
 if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
 pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
 //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
 pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
 
 }
 pickerImage.delegate = self;
 pickerImage.allowsEditing = YES;
 [self presentViewController:pickerImage animated:YES completion:nil];
 }break;
 default:
 break;
 }
 }
 
 - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
 
 NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
 if ([type isEqualToString:@"public.image"])
 {
 UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
 CGSize imagesize = image.size;
 imagesize.height =100;
 imagesize.width =100;
 image = [self imageWithImage:image scaledToSize:imagesize];
 self.headV.userIconImage.image = image;
 }        //关闭相册界面
 [picker dismissViewControllerAnimated:YES completion:nil];
 [self post];
 }
 -(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
 
 {
 // Create a graphics image context
 
 UIGraphicsBeginImageContext(newSize);
 // Tell the old image to draw in this new context, with the desired
 // new siz
 [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
 // Get the new image from the context
 UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
 // End the context
 UIGraphicsEndImageContext();
 // Return the new image.
 return newImage;
 }
 
 
 
 #pragma makr - shangchuan
 -(void)post{
 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 manager.requestSerializer = [AFHTTPRequestSerializer serializer];
 manager.responseSerializer = [AFJSONResponseSerializer serializer];
 [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 
 __weak typeof (self) weakSelf = self;
 
 
 [manager POST:[NSString stringWithFormat:@"%@/mcenter/uphead",kWebSite_Head]parameters:@{
 @"token":[self getUserId]
 }
 constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
 
 NSData *iamgedata = UIImagePNGRepresentation(weakSelf.headV.userIconImage.image);
 NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
 NSTimeInterval a=[dat timeIntervalSince1970];
 NSString *timeString = [NSString stringWithFormat:@"%0.0f", a];
 [formData appendPartWithFileData:iamgedata name:@"imgfile" fileName:[NSString stringWithFormat:@"%@.png",timeString] mimeType:@"image/png"];
 
 } success:^(AFHTTPRequestOperation *operation, id responseObject) {
 CHQLog(@"%@",responseObject);
 [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"avatar"] forKey:@"用户头像"];
 [weakSelf showHint:@"头像修改成功"];
 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"change"];
 
 [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
 
 
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 CHQLog(@"%@",error);
 __block NSString *imagepath = [[NSUserDefaults standardUserDefaults]objectForKey:@"用户头像"];
 
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kimage_Head_l,imagepath]];
 NSData *data = [NSData dataWithContentsOfURL:imageURL];
 dispatch_async(dispatch_get_main_queue(), ^{
 if (data) {
 self.headV.userIconImage.image = [UIImage imageWithData:data];
 }
 });
 });
 
 [weakSelf showHint:@"头像修改失败"];
 
 [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
 }];
 
 }
 */
@end
