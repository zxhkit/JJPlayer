//
//  XHVideoConfigModel.h
//  XHPlayer
//
//  Created by zhouxuanhe on 2018/5/11.
//  Copyright © 2018 xuanhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHVideoConfigModel : NSObject

/** 是否仅支持全屏 */
@property (nonatomic, assign) BOOL onlyFullScreen;
/** 设置URL后自动播放 */
@property (nonatomic, assign) BOOL autoPlay;

@end
