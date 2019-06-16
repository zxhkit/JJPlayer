//
//  XHCircleLoading.h
//  XHPlayer
//
//  Created by zhouxuanhe on 2018/5/11.
//  Copyright © 2018 xuanhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHCircleLoading : UIView

/** 直径 */
@property (nonatomic, assign) CGFloat circleDiameter;
/** 一次动画时长 */
@property (nonatomic, assign) CGFloat duration;
/** 画线颜色 */
@property (nonatomic, strong) UIColor *strokeColor;
/** 线条宽度 */
@property (nonatomic, assign) CGFloat lineWidth;
/** layer背景色 */
@property (nonatomic, strong) UIColor *fillColor;

- (void)startAnimating;

- (void)stopAnimating;

@end
