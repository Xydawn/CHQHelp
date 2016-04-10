//
//  XyMenu.h
//  QinDianSheQu
//
//  Created by 金斗云 on 16/3/24.
//  Copyright © 2016年 Xydawn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XyMenu : UIView
@property (nonatomic,copy) void(^tableCLick)(NSString *,NSString *);
-(void)showMenu;
-(void)hideMenu;
-(void)showOrMiss;
@end
