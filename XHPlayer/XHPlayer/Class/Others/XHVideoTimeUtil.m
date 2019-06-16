//
//  XHVideoTimeUtil.m
//  XHPlayer
//
//  Created by zhouxuanhe on 2018/5/11.
//  Copyright © 2018 xuanhe. All rights reserved.
//

#import "XHVideoTimeUtil.h"

@implementation XHVideoTimeUtil

// 将秒数转换为时分秒字符串
+ (NSString *)hmsStringWithFloat:(CGFloat)seconds{
    
    NSInteger hour = floor(seconds/60/60);
    NSInteger minutes = floor(seconds/60)-hour*60;
    NSInteger second = seconds - hour*60*60 - minutes*60;
    NSString * timeString = nil;
    if (hour == 0) {
        timeString = [NSString stringWithFormat:@"%02zd:%02zd", minutes, second];
    }else{
        timeString = [NSString stringWithFormat:@"%02zd:%02zd:%02zd", hour, minutes, second];
    }
    
    return timeString;
}

@end
