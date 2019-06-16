//
//  AppDelegate+XHVideoRotation.m
//  XHPlayer
//
//  Created by zhouxuanhe on 2018/5/11.
//  Copyright © 2018 xuanhe. All rights reserved.
//

#import "AppDelegate+XHVideoRotation.h"
#import <objc/runtime.h>
@implementation AppDelegate (XHVideoRotation)



#pragma mark - 添加屏幕旋转控制
- (UIInterfaceOrientationMask)orientationMask {
    UIInterfaceOrientationMask mask = [objc_getAssociatedObject(self, @selector(orientationMask)) integerValue];
    if (mask == 0) {
        mask = UIInterfaceOrientationMaskPortrait;
    }
    return mask;
}

- (void)setOrientationMask:(UIInterfaceOrientationMask)orientationMask{
    objc_setAssociatedObject(self, @selector(orientationMask), @(orientationMask), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//override
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    UIInterfaceOrientationMask mask = [self orientationMask];
    return mask;
}

@end
