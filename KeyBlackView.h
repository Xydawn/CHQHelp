//
//  KeyBlackView.h
//  TangXianManual
//
//  Created by lq on 15/8/27.
//  Copyright (c) 2015年 Han. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyBlackView : UIView<UIGestureRecognizerDelegate>
-(void)showOnView:(UIView *)view withTheTextFelid:(UITextField *)textField;
-(void)dismiss;
-(void)didmove;
@end
