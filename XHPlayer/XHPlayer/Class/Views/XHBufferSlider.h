//
//  XHBufferSlider.h
//  XHPlayer
//
//  Created by zhouxuanhe on 2018/5/11.
//  Copyright © 2018 xuanhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHBufferSlider : UIView

@property (nonatomic, assign) CGFloat minimumValue;

@property (nonatomic, assign) CGFloat maximumValue;

@property (nonatomic, assign) CGFloat bufferValue;//缓冲进度值

@property (nonatomic, assign) CGFloat progressValue;//进度值

// Color

@property (nonatomic, strong) UIColor * _Nullable progressTrackColor;//进度颜色

@property (nonatomic, strong) UIColor * _Nullable bufferTrackColor;//缓冲进度颜色

@property (nonatomic, strong) UIColor * _Nullable maxBufferTrackColor;//背景色

@property (nonatomic, strong) UIColor * __nullable thumbTintColor;//滑块颜色


// Image

@property (nonatomic, strong) UIImage * _Nullable progressTrackImage;//进度图片

@property (nonatomic, strong) UIImage * _Nullable bufferTrackImage;//缓冲进度图片

@property (nonatomic, strong) UIImage * _Nullable maxBufferTrackImage;//背景图片

@property (nonatomic, strong) UIImage * _Nullable thumbImage;//滑块图片


// Methods
- (void)addTarget:(nullable id)target action:(nonnull SEL)sel
                            forControlEvents:(UIControlEvents)controlEvent;


@end
