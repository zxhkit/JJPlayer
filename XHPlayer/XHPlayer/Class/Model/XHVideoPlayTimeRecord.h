//
//  XHVideoPlayTimeRecord.h
//  XHPlayer
//
//  Created by zhouxuanhe on 2018/5/11.
//  Copyright © 2018 xuanhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHVideoPlayTimeRecord : NSObject

/** 播放url */
@property (nonatomic, copy) NSString *url;

/** 播放时长记录 */
@property (nonatomic, assign) float playTime;


@end
