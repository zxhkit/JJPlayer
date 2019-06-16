//
//  XHVideoBottomView.h
//  XHPlayer
//
//  Created by zhouxuanhe on 2018/5/11.
//  Copyright © 2018 xuanhe. All rights reserved.
//

#import <UIKit/UIKit.h>




typedef void(^videoPlayerFullScreenBlock)(BOOL isFull);
typedef void(^videoPlayerSliderValueChanged)(float value);

@class XHVideoConfigModel;
@interface XHVideoBottomView : UIView

/** 进度*/
@property (nonatomic, assign ,readonly) CGFloat progressValue;
/** 缓冲进度*/
@property (nonatomic, assign ,readonly) CGFloat bufferValue;
/** 最大进度 */
@property (nonatomic, assign ,readonly) CGFloat maximumValue;
/** 大小屏切换回调*/
@property (nonatomic, copy) videoPlayerFullScreenBlock fullScreenBlock;
/** 进度条拖动回调*/
@property (nonatomic, copy) videoPlayerSliderValueChanged valueChangedBlock;
/** 是否仅显示slider */
@property (nonatomic, assign, readonly) BOOL onlySlider;

@property (nonatomic, strong) XHVideoConfigModel *configModel;


// 显示底部视图
- (void)show;

// 隐藏底部视图
- (void)hide;

// 设置进度
- (void)setProgress:(CGFloat)progressValue;

// 设置缓冲进度
- (void)setBufferValue:(CGFloat)bufferValue;

// 设置最大进度
- (void)setMaximumValue:(CGFloat)value;


@end
