//
//  ChangeColorBtn.m
//  QinDianSheQu
//
//  Created by 金斗云 on 16/3/14.
//  Copyright © 2016年 Xydawn. All rights reserved.
//

#import "ChangeColorBtn.h"

@implementation ChangeColorBtn

-(void)awakeFromNib{
    
    switch (self.tag) {
        case 300:{
            self.backgroundColor = kBackGroundColor;
            self.layer.borderColor = kBackGroundColor.CGColor;
            [self setTitleColor:RGBACOLOR(107, 69, 10, 1) forState:UIControlStateNormal];
        }break;
        case 301:{
            self.backgroundColor = [UIColor whiteColor];
            self.layer.borderColor = RGBACOLOR(128, 128, 128, 1).CGColor;
        }break;
        default:
            break;
    }
    
  
    self.layer.borderWidth = 0.5f;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3.0f;

    [self addTarget:self action:@selector(chageBtnColor:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(cancelBtnColor:) forControlEvents:UIControlEventTouchCancel];
    [self addTarget:self action:@selector(cancelBtnColor:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)chageBtnColor:(UIButton *)button{

        
    self.alpha = 0.6;

    
}

-(void)cancelBtnColor:(UIButton *)button{

    self.alpha = 1.0;
    
}

@end
