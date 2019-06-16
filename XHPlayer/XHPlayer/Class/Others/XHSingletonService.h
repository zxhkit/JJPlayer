//
//  XHSingletonService.h
//  XHPlayer
//
//  Created by zhouxuanhe on 2018/5/11.
//  Copyright © 2018 xuanhe. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ServiceSingletonH(methodName) + (instancetype)shared##methodName;

#define ServiceSingletonM(methodName) \
static id instace = nil; \
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
if (instace == nil) { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instace = [super allocWithZone:zone]; \
}); \
} \
return instace; \
} \
\
- (id)init \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instace = [super init]; \
}); \
return instace; \
} \
\
+ (instancetype)shared##methodName \
{ \
return [[self alloc] init]; \
} \
- (id)copyWithZone:(struct _NSZone *)zone \
{ \
return instace; \
} \
\
- (id)mutableCopyWithZone:(struct _NSZone *)zone{\
return instace;\
}
