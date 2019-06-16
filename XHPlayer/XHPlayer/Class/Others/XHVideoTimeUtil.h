//
//  XHVideoTimeUtil.h
//  XHPlayer
//
//  Created by zhouxuanhe on 2018/5/11.
//  Copyright © 2018 xuanhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XHVideoTimeUtil : NSObject

// 将秒数转换为时分秒字符串
+ (NSString *)hmsStringWithFloat:(CGFloat)seconds;

@end
