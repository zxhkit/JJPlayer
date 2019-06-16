//
//  XHViewFactory.h
//  XHPlayer
//
//  Created by zhouxuanhe on 2018/5/11.
//  Copyright © 2018 xuanhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+getImage.h"

@interface XHViewFactory : NSObject


+ (UIButton *)buttonWithNormalImage:(UIImage *)normalImage
                      selectedImage:(UIImage *)selectedImage;

@end
