//
//  UIButton+Click.m

//
//  Created by CHQ on 15-7-29.
//  Copyright (c) 2015年 Xydawn. All rights reserved.
//

#import "UIButton+Click.h"
#import <objc/runtime.h>

typedef void(^ActionBlock) (void);
static char key;
@implementation UIButton (Click)
-(void)handaction:(void (^)(void))block{
    [self addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(self, &key, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void)buttonClick:(UIButton *)butotn{
    ActionBlock block = objc_getAssociatedObject(self, &key);
    if (block) {
        block();
    }
}

@end
