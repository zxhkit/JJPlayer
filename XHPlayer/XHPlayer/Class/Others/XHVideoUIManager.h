//
//  XHVideoUIManager.h
//  XHPlayer
//
//  Created by zhouxuanhe on 2018/5/11.
//  Copyright © 2018 xuanhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHSingletonService.h"

#define kXHVideoUIManager [XHVideoUIManager sharedXHVideoUIManager]

@interface XHVideoUIManager : NSObject

ServiceSingletonH(XHVideoUIManager)

@end
