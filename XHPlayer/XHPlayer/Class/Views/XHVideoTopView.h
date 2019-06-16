//
//  XHVideoTopView.h
//  XHPlayer
//
//  Created by zhouxuanhe on 2018/5/11.
//  Copyright © 2018 xuanhe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^videoBackBlock)(void);

typedef void(^videoShowListBlock)(BOOL show);

@class XHVideoConfigModel;

@interface XHVideoTopView : UIView

@property (nonatomic, copy) videoBackBlock  backBlock;

@property (nonatomic, copy) videoShowListBlock  showListBlock;

@property (nonatomic, strong) XHVideoConfigModel *configModel;

@property (nonatomic, copy) NSString *title;

@end
