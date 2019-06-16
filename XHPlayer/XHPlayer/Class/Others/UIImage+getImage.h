//
//  UIImage+getImage.h
//  XHPlayer
//
//  Created by zhouxuanhe on 2018/5/11.
//  Copyright © 2018 xuanhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (getImage)


+ (UIImage *)imageFromBundleWithName:(NSString *)imageName;


- (UIImage *)imageWithSize:(CGSize)size;


@end
