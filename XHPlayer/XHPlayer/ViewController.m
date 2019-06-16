//
//  ViewController.m
//  XHPlayer
//
//  Created by zhouxuanhe on 2018/5/11.
//  Copyright © 2018 xuanhe. All rights reserved.
//

#import "ViewController.h"
#import "XHListPlayerViewController.h"
#import "XHFullPlayerViewController.h"
#import "XHListVideoViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIButton * listBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [listBtn setTitle:@"进入视频播放列表" forState:UIControlStateNormal];
    [listBtn setFrame:CGRectMake(0, 0, 200, 44)];
    [listBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [listBtn setCenter:self.view.center];
    [listBtn addTarget:self action:@selector(enterListPlayerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:listBtn];
    
    UIButton * fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fullBtn setTitle:@"进入全屏播放" forState:UIControlStateNormal];
    CGRect fullBtnFrame = listBtn.frame;
    fullBtnFrame.origin.y = CGRectGetMaxY(listBtn.frame)+20;
    [fullBtn setFrame:fullBtnFrame];
    [fullBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [fullBtn addTarget:self action:@selector(enterFullPlayerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fullBtn];
    
    UIButton * viewsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewsBtn setTitle:@"进入listView播放" forState:UIControlStateNormal];
    CGRect viewBtnFrame = fullBtn.frame;
    viewBtnFrame.origin.y = CGRectGetMaxY(fullBtn.frame)+20;
    [viewsBtn setFrame:viewBtnFrame];
    [viewsBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [viewsBtn addTarget:self action:@selector(enterViewPlayerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewsBtn];
    
    
    
}


-(void)enterListPlayerAction{
    XHListPlayerViewController *vc = [[XHListPlayerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)enterFullPlayerAction{
    
    XHFullPlayerViewController * vc = [[XHFullPlayerViewController alloc] init];
    [vc.configModel setOnlyFullScreen:YES];
    [vc setUrl:@"http://wvideo.spriteapp.cn/video/2016/0317/56ea981c857df_wpd.mp4"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)enterViewPlayerAction{
    
    XHListVideoViewController *vc = [[XHListVideoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}



@end
