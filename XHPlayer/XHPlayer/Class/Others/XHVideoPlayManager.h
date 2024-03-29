//
//  XHVideoPlayManager.h
//  XHPlayer
//
//  Created by zhouxuanhe on 2018/5/11.
//  Copyright © 2018 xuanhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "XHSingletonService.h"

#define kVideoPlayerManager [XHVideoPlayManager sharedXHVideoPlayManager]

#pragma mark - 状态回调
typedef void(^VideoPlayerManagerReadyBlock)(CGFloat totoalDuration);//准备播放回调
typedef void(^VideoPlayerManagerMonitoringBlock)(CGFloat currentDuration);//播放监听回调
typedef void(^VideoPlayerManagerLoadingBlock)(void);//loading回调
typedef void(^VideoPlayerManagerPlayFailedBlock)(void);//播放失败回调
typedef void(^VideoPlayerManagerPlayEndBlock)(void);//播放结束回调

#pragma mark - 时长回调
typedef void(^VideoPlayerManagerCurrentDurationBlock)(CGFloat currentDuration);//播放时长回调
typedef void(^VideoPlayerManagerTotalDurationBlock)(CGFloat totalDuration);//视频总时长回调
typedef void(^VideoPlayerManagerBufferDurationBlock)(CGFloat bufferDuration);//缓冲时长回调

@class XHVideoPlayTimeRecord;

@interface XHVideoPlayManager : NSObject

@property (nonatomic, strong, readonly) AVPlayer       *player;

/** 最大播放记录数 */
@property (nonatomic, assign) NSInteger maxRecordCount;

/** 是否为本地视频*/
@property (nonatomic, assign, readonly) BOOL            isLocalVideo;


ServiceSingletonH(XHVideoPlayManager)

- (void)readyBlock:(VideoPlayerManagerReadyBlock)readyBlock
   monitoringBlock:(VideoPlayerManagerMonitoringBlock)monitoringBlock
      loadingBlock:(VideoPlayerManagerLoadingBlock)loadingBlock
          endBlock:(VideoPlayerManagerPlayEndBlock)endBlock
       failedBlock:(VideoPlayerManagerPlayFailedBlock)faildBlock;


- (void)totalDurationBlock:(VideoPlayerManagerTotalDurationBlock)totalBlock
      currentDurationBlock:(VideoPlayerManagerCurrentDurationBlock)currentBlock
       bufferDurationBlock:(VideoPlayerManagerBufferDurationBlock)bufferBlock;


- (AVPlayer *)setUrl:(NSString *)url;

- (void)play;

- (void)pause;

- (void)cancelBuffer;

- (void)seekToTime:(CGFloat)second;

- (void)reset;

/** 记录播放时长*/
- (void)recordUrl:(NSString *)url playTime:(float)playTime;

/** 获取是否有记录*/
- (XHVideoPlayTimeRecord *)recordWithUrl:(NSString *)url;

/** 移除播放记录*/
- (void)removeRecord:(XHVideoPlayTimeRecord *)record;

/** 移除所有播放记录*/
- (void)removeAllPlayRecords;

@end
