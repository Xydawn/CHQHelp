//
//  KeyBlackView.m
//  TangXianManual
//
//  Created by lq on 15/8/27.
//  Copyright (c) 2015年 Han. All rights reserved.
//


#import "KeyBlackView.h"

@interface KeyBlackView ()
@property(nonatomic,strong)UITextField *textField;
@end

@implementation KeyBlackView

-(void)showOnView:(UIView *)view withTheTextFelid:(UITextField *)textField{
    self.textField = textField;
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc]init];
    viewTap.delegate = self;
    [viewTap addTarget:self action:@selector(resignFirst)];
    self.frame = CGRectMake(0, 54,k_width,0 );
    [self addGestureRecognizer:viewTap];
    self.backgroundColor = [UIColor clearColor];
    [view addSubview:self];
}
-(void)didmove{
     self.frame = CGRectMake(0, 54, k_width, k_height-54);
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }];
}
-(void)resignFirst{
    [self.textField resignFirstResponder];
}
-(void)dismiss{
         self.frame = CGRectMake(0, 54, k_width, 0);
    [UIView animateWithDuration:0.5 animations:^{
         self.backgroundColor = [UIColor clearColor];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
