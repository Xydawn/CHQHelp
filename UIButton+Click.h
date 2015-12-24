//
//  UIButton+Click.h

//
//  Created by CHQ on 15-7-29.
//  Copyright (c) 2015年 Xydawn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Click)
-(void)handaction:(void (^)(void))block;
@end
