//
//  UIDevice+XHVideoRotation.m
//  XHPlayer
//
//  Created by zhouxuanhe on 2018/5/11.
//  Copyright © 2018 xuanhe. All rights reserved.
//

#import "UIDevice+XHVideoRotation.h"

@implementation UIDevice (XHVideoRotation)

+ (void)rotateToOrientation:(UIInterfaceOrientation)orientation{
    // 设置方向
    NSNumber *orientationTarget = [NSNumber numberWithInt:orientation];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

@end
