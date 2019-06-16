//
//  XHFastForwardView.h
//  XHPlayer
//
//  Created by zhouxuanhe on 2018/5/11.
//  Copyright © 2018 xuanhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHFastForwardView : UIView

/** 最大进度 */
@property (nonatomic, assign) CGFloat maxDuration;

/** 当前值 */
@property (nonatomic, assign, readonly) CGFloat currentDuration;

/** 进度 */
@property (nonatomic, assign) CGFloat progress;

- (void)configForwardLeftImage:(UIImage *)leftImage forwardRightImage:(UIImage *)rightImage;

- (void)moveRight:(BOOL)isRight;
@end
