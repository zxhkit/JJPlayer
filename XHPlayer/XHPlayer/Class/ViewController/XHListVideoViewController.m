//
//  XHListVideoViewController.m
//  XHPlayer
//
//  Created by zhouxuanhe on 2019/6/16.
//  Copyright © 2019 xuanhe. All rights reserved.
//

#import "XHListVideoViewController.h"
#import "XHVideoPlayerView.h"
#import "XHVideoPlayerHeader.h"
#import "XHVideoConst.h"



@interface XHListVideoViewController ()

@end

@implementation XHListVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    kVideoPlayerManager.maxRecordCount = 2;
    XHVideoPlayerView *videoPlayer = [[XHVideoPlayerView alloc]initWithFrame:CGRectMake(0, kNavBarH, kScreenWidth, VideoH(kScreenWidth))];
    videoPlayer.layer.borderWidth = 2;
    [self.view addSubview:videoPlayer];
    [videoPlayer setUrl:@"http://wvideo.spriteapp.cn/video/2016/0503/572802030bf16_wpd.mp4"];

    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
