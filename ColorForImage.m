//
//  ColorForImage.m
//  QinDianSheQu
//
//  Created by 金斗云 on 16/3/31.
//  Copyright © 2016年 Xydawn. All rights reserved.
//

#import "ColorForImage.h"

@implementation ColorForImage
+ (UIImage *)buttonImageFromColor:(UIColor *)color andSize:(CGSize )size{

    CGRect rect = CGRectMake(0, 0, size.width,size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
