//
//  XHPlayerView.m
//  XHPlayer
//
//  Created by zhouxuanhe on 2018/5/11.
//  Copyright © 2018 xuanhe. All rights reserved.
//

#import "XHPlayerView.h"

@implementation XHPlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    AVPlayerLayer *layer = (AVPlayerLayer *)[self layer];
    [layer setVideoGravity: AVLayerVideoGravityResize];
    return [layer player];
}

- (void)setPlayer:(AVPlayer *)player {
    AVPlayerLayer *layer = (AVPlayerLayer *)[self layer];
    [layer setVideoGravity: AVLayerVideoGravityResize];
    [layer setPlayer:player];
}

@end
