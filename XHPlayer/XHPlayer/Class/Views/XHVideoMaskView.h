//
//  XHVideoMaskView.h
//  XHPlayer
//
//  Created by zhouxuanhe on 2018/5/11.
//  Copyright © 2018 xuanhe. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, VideoMaskViewStatus) {
    VideoMaskViewStatus_hide             = 0,
    VideoMaskViewStatus_showPlayBtn      = 1,
    VideoMaskViewStatus_showReplayBtn    = 2,
    VideoMaskViewStatus_showFastForward  = 3,
    VideoMaskViewStatus_showLoading      = 4,
    VideoMaskViewStatus_showPlayFailed   = 5
};

typedef void(^videoPlayerPlayBlock)(BOOL isPlay);
typedef void(^videoPlayerReplayClickBlock)(void);
typedef void(^videoPlayerPlayFailedClickBlock)(void);

#import "XHFastForwardView.h"

@interface XHVideoMaskView : UIView

/** 视频播放回调*/
@property (nonatomic, copy) videoPlayerPlayBlock playBlock;
/** 视频播放回调*/
@property (nonatomic, copy) videoPlayerReplayClickBlock replayBlock;
/** 视频播放失败点击回调*/
@property (nonatomic, copy) videoPlayerPlayFailedClickBlock playFailedClickBlock;

/** 快进视图 */
@property (nonatomic, strong, readonly) XHFastForwardView *fastForwardView;
/** 是否暂停中 */
@property (nonatomic, assign, readonly) BOOL isPausing;
/** 遮罩层显示状态 */
@property (nonatomic, assign) VideoMaskViewStatus maskViewStatus;


- (void)setPlayStatus:(BOOL)play;

- (void)show;

- (void)hide;

@end
