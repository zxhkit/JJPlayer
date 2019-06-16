//
//  XHViewFactory.m
//  XHPlayer
//
//  Created by zhouxuanhe on 2018/5/11.
//  Copyright © 2018 xuanhe. All rights reserved.
//

#import "XHViewFactory.h"


@implementation XHViewFactory



+ (UIButton *)buttonWithNormalImage:(UIImage *)normalImage
                      selectedImage:(UIImage *)selectedImage;{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setShowsTouchWhenHighlighted:YES];
    
    if(normalImage)
    [btn setImage:normalImage forState:UIControlStateNormal];
    
    if (selectedImage)
    [btn setImage:selectedImage forState:UIControlStateSelected];
    
    [btn setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    
    return btn;
}

@end
