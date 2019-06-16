//
//  XHVideoPlayerView.m
//  XHPlayer
//
//  Created by zhouxuanhe on 2019/6/16.
//  Copyright © 2019 xuanhe. All rights reserved.
//

#import "XHVideoPlayerView.h"
#import "XHVideoTopView.h"
#import "XHVideoBottomView.h"
#import "XHVideoPlayManager.h"
#import "XHVideoUIManager.h"
#import "XHPlayerView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "XHViewFactory.h"
#import "XHVideoMaskView.h"
#import "XHVideoPlayerHeader.h"
#import "AppDelegate+XHVideoRotation.h"
#import "XHVideoPlayerUtil.h"
#import "UIDevice+XHVideoRotation.h"
#import "XHVideoConst.h"
#import "XHVideoPlayTimeRecord.h"


typedef NS_ENUM(NSUInteger, MoveDirection) {
    MoveDirection_none = 0,
    MoveDirection_up,
    MoveDirection_down,
    MoveDirection_left,
    MoveDirection_right
};
@interface XHVideoPlayerView ()

@property (nonatomic ,strong) XHVideoMaskView * maskView;

@property (nonatomic ,strong) XHVideoTopView * topView;

@property (nonatomic ,strong) XHVideoBottomView * bottomView;

@property (nonatomic ,assign) CGRect originFrame;

@property (nonatomic, assign) BOOL isFullScreen;

@property (nonatomic, strong) XHPlayerView *playerView;

@property (nonatomic, assign) VideoPlayerStatus playStatus;

@property (nonatomic, assign) VideoPlayerStatus prePlayStatus;
/** 隐藏时间 */
@property (nonatomic, assign) NSInteger secondsForBottom;
/** 开始移动 */
@property (nonatomic, assign) CGPoint startPoint;
/** 移动方向 */
@property (nonatomic, assign) MoveDirection moveDirection;
/** 音量调节 */
@property (nonatomic, strong) UISlider *volumeSlider;
/** 系统音量 */
@property (nonatomic, assign) CGFloat sysVolume;
/** 亮度调节 */
@property (nonatomic, assign) CGFloat brightness;
/** 进度调节 */
@property (nonatomic, assign) CGFloat currentTime;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;


@end

#define kFullScreenFrame CGRectMake(0 , 0, kScreenHeight, kScreenWidth)

static const NSInteger maxSecondsForBottom = 5.f;

@implementation XHVideoPlayerView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.originFrame = frame;
        
        [self setupUI];
        [self initW];
        [self handleVideoPlayerStatus];
        [self handleProgress];
        [self addObservers];
        [self addTapGesture];
        
    }
    return self;
}
//
//
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    //允许屏幕旋转
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    if (self.configModel.onlyFullScreen) {
//        delegate.orientationMask = UIInterfaceOrientationMaskLandscape;
//        [UIDevice rotateToOrientation:UIInterfaceOrientationLandscapeRight];
//        [self changeFullScreen:YES];
//    }else{
//        delegate.orientationMask = UIInterfaceOrientationMaskAllButUpsideDown;
//    }
//    //禁用侧滑手势方法
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    //开启屏幕长亮
//    [UIApplication sharedApplication].idleTimerDisabled = YES;
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    [self cancelTimer];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
//    //关闭屏幕旋转
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    delegate.orientationMask = UIInterfaceOrientationMaskPortrait;
//    [UIDevice rotateToOrientation:UIInterfaceOrientationPortrait];
//    //关闭屏幕长亮
//    [UIApplication sharedApplication].idleTimerDisabled = NO;
//    //禁用侧滑手势方法
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    //暂停播放
//    [self pause];
//}


- (void)dealloc{
    
    NSLog(@"播放器已销毁");
    [kVideoPlayerManager reset];
}



- (void)initW
{
    self.secondsForBottom = maxSecondsForBottom;
    self.currentTime      = 0;
    
    //获取系统音量滚动条
    MPVolumeView *volumeView = [[MPVolumeView alloc]init];
    for (UIView *tmpView in volumeView.subviews) {
        if ([[tmpView.class description] isEqualToString:@"MPVolumeSlider"]) {
            self.volumeSlider = (UISlider *)tmpView;
        }
    }
}


- (void)clearInfo{
    
    if (_bottomView) {
        [self.bottomView setProgress:0];
        [self.bottomView setMaximumValue:0];
        [self.bottomView setBufferValue:0];
    }
    
    self.playStatus = videoPlayer_unknown;
    self.currentTime = 0;
}
#pragma mark - About UI
- (void)setupUI
{
    // 设置self
    if (!self.configModel.onlyFullScreen) {
        [self setFrame:self.originFrame];
    }else{
        [self setFrame:CGRectMake(0, 0,kScreenWidth, kScreenHeight)];
    }
    
    [self setClipsToBounds:YES];
    
    // 设置player
    [self.playerView setFrame:CGRectMake(0, 0,CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self.playerView setBackgroundColor:[UIColor clearColor]];
    [self.playerView setImage:imgVideoBackImg];
    [self.playerView setUserInteractionEnabled:YES];
    [self addSubview:self.playerView];
    
    
    //设置遮罩层
    self.maskView = [[XHVideoMaskView alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth(self.playerView.bounds), CGRectGetHeight(self.playerView.bounds))];
    self.maskView.backgroundColor = kVideoMaskViewBGColor;
    self.maskView.maskViewStatus = VideoMaskViewStatus_showPlayBtn;
    WS(weakSelf);
    self.maskView.playBlock = ^(BOOL isPlay) {
        if (isPlay) {
            [weakSelf play];
        }else{
            [weakSelf pause];
        }
        
        [weakSelf resetTimer];
    };
    
    __weak XHVideoMaskView * weakMaskView = self.maskView;
    self.maskView.replayBlock = ^{
        [kVideoPlayerManager seekToTime:0];
        weakMaskView.maskViewStatus = VideoMaskViewStatus_showPlayBtn;
        [weakSelf resetTimer];
    };
    
    self.maskView.playFailedClickBlock = ^{
        [weakSelf setUrl:weakSelf.url];
    };
    [self.playerView addSubview:self.maskView];
    
    
    
    // 设置topView
    self.topView.frame = CGRectMake(0, 0, self.frame.size.width, kBottomBarHalfHeight);
    [self addSubview:self.topView];
    
    // 设置BottomView
    self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - kBottomBarHalfHeight, self.frame.size.width, kBottomBarHalfHeight);
    self.bottomView.configModel = self.configModel;
    [self addSubview:self.bottomView];
}


- (void)changeFullScreen:(BOOL)changeFull{
    
    self.isFullScreen = changeFull;
    
    [self.superview bringSubviewToFront:self];
    
    [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
        if (changeFull) {
            self.frame = kVideoFullFrame;
        }else{
            self.frame = self.originFrame;
        }
        
        self.playerView.frame = self.bounds;
        self.maskView.frame = self.playerView.bounds;
        
        // 发送屏幕改变通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationChangeScreen object:@(changeFull)];
    }];
}
#pragma mark - 底部栏显示/隐藏

- (void)addTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startTimer)];
    [self addGestureRecognizer:tap];
    [self startTimer];
}

- (void)showBottomAction
{
    if (!self.bottomView.onlySlider) {
        [self.bottomView hide];
    }else{
        [self.bottomView show];
    }
}


- (void)startTimer
{
    //看是否正在计时，若是则结束计时 否则开始计时
    if (self.timer) {
        
        [self cancelTimerAndHideViews];
        
    }else{
        [self setSecondsForBottom:maxSecondsForBottom];
        [self hideTopView:NO];
        [self.bottomView show];
        
        [self.maskView show];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                                    selector:@selector(timerAction)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}


- (void)resetTimer{
    
    if ([self.timer isValid]) {
        self.secondsForBottom = 5.f;
    }else{
        [self startTimer];
    }
}


- (void)cancelTimerAndHideViews{
    
    [self hideSomeViews];
    
    [self cancelTimer];
}


- (void)cancelTimer{
    
    
    if (!self.timer) {
        return;
    }
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)hideSomeViews{
    
    //顶部视图隐藏
    if (self.isFullScreen) {
        [self hideTopView:YES];
    }
    
    //底部视图隐藏
    [self.bottomView hide];
    
    //中间内容隐藏 暂停 播放失败 和播放结束 无需隐藏显示内容
    if(self.playStatus != videoPlayer_readyToPlay &&
       self.maskView.maskViewStatus != VideoMaskViewStatus_showLoading &&
       self.maskView.maskViewStatus != VideoMaskViewStatus_showPlayFailed &&
       !self.maskView.isPausing){
        [self.maskView hide];
    }
    
    self.secondsForBottom = 0;
}


- (void)hideTopView:(BOOL)hide{
    
    self.topView.hidden = hide;
    //状态栏显示跟随topView
    [[UIApplication sharedApplication] setStatusBarHidden:hide withAnimation:NO];
}


- (void)timerAction{
    
    self.secondsForBottom --;
    NSLog(@"隐藏底部栏:%zd",self.secondsForBottom);
    if (self.secondsForBottom <= 0) {
        [self cancelTimerAndHideViews];
    }
}


#pragma mark - Pravite Methods
- (void)handleVideoPlayerStatus{
    
    WS(weakSelf);
    [kVideoPlayerManager readyBlock:^(CGFloat totoalDuration) {
        NSLog(@"[%@]:准备播放",[weakSelf class]);
        weakSelf.playStatus = videoPlayer_readyToPlay;
        if (weakSelf.configModel.autoPlay) {//是否自动播放
            [weakSelf play];
        }else{
            weakSelf.maskView.maskViewStatus = VideoMaskViewStatus_showPlayBtn;
        }
    } monitoringBlock:^(CGFloat currentDuration) {
        
        if(weakSelf.playStatus!= videoPlayer_pause){
            weakSelf.playStatus = videoPlayer_playing;
        }
        
        if(weakSelf.maskView.maskViewStatus != VideoMaskViewStatus_showPlayBtn) {
            weakSelf.maskView.maskViewStatus = VideoMaskViewStatus_showPlayBtn;
            [weakSelf hideSomeViews];
        };
    }loadingBlock:^{
        NSLog(@"[%@]:加载中",[weakSelf class]);
        weakSelf.playStatus = videoPlayer_loading;
        weakSelf.maskView.maskViewStatus = VideoMaskViewStatus_showLoading;
    }endBlock:^{
        NSLog(@"[%@]:播放结束",[weakSelf class]);
        weakSelf.playStatus = videoPlayer_playEnd;
        weakSelf.maskView.maskViewStatus = VideoMaskViewStatus_showReplayBtn;
        if (weakSelf.playEndBlock) {
            weakSelf.playEndBlock();
        }
    } failedBlock:^{
        NSLog(@"[%@]:播放失败",[weakSelf class]);
        weakSelf.playStatus = videoPlayer_playFailed;
        weakSelf.maskView.maskViewStatus = VideoMaskViewStatus_showPlayFailed;
    }];
}
/**
 *  设置时长
 */
- (void)handleProgress{
    
    WS(weakSelf);
    [kVideoPlayerManager totalDurationBlock:^(CGFloat totalDuration) {
        [weakSelf.bottomView setMaximumValue:totalDuration];
    } currentDurationBlock:^(CGFloat currentDuration) {
        [weakSelf.bottomView setProgress:currentDuration];
    } bufferDurationBlock:^(CGFloat bufferDuration) {
        [weakSelf.bottomView setBufferValue:bufferDuration];
    }];
}

- (void)addObservers{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
}


#pragma mark - 公开方法
- (void)play{
    
    //若有记录则从记录播放
    if ([kVideoPlayerManager recordWithUrl:self.url]) {
        XHVideoPlayTimeRecord * record = [kVideoPlayerManager recordWithUrl:self.url];
        [kVideoPlayerManager seekToTime:record.playTime];
        [kVideoPlayerManager removeRecord:record];
    }
    
    [kVideoPlayerManager play];
    [self setPlayStatus:videoPlayer_playing];
    [self.maskView setPlayStatus:YES];
    
    if (self.playBlock) {
        self.playBlock();
    }
}

- (void)pause{
    
    [kVideoPlayerManager pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setPlayStatus:videoPlayer_pause];
        [self.maskView setPlayStatus:NO];
    });
}


- (void)pausePlayAndBuffer{
    
    [self pause];
    
    [kVideoPlayerManager cancelBuffer];
}


#pragma mark - 事件响应
- (void)applicationDidEnterBackground {
    
    if (self.playStatus == videoPlayer_playing) {
        [self pause];
    }
}


- (void)applicationWillEnterForeground {
    
    if (self.prePlayStatus == videoPlayer_playing) {
        [self play];
    }
}

- (void)playOrPauseAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self play];
    }else{
        [self pause];
    }
}


- (void)popAction{
   // [self.navigationController popViewControllerAnimated:YES];
    //[self removeFromSuperview];
    //[self removeFromParentViewController];
}
#pragma mark - getters / setters
- (XHVideoTopView *)topView{
    if (!_topView) {
        WS(weakSelf);
        _topView = [[XHVideoTopView alloc]init];
        _topView.backBlock = ^(){
            if (weakSelf.configModel.onlyFullScreen) {//仅支持全屏  直接返回
                weakSelf.frame = CGRectZero;
                //[weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                if(weakSelf.isFullScreen){//全屏返回
                    [UIDevice rotateToOrientation:UIInterfaceOrientationPortrait];
                    [weakSelf changeFullScreen:NO];
                }else{//半屏返回操作
                    [weakSelf popAction];
                }
            }
        };
        
        _topView.showListBlock = ^(BOOL show){
            
        };
    }
    return _topView;
}

- (XHVideoBottomView *)bottomView{
    if (!_bottomView) {
        WS(weakSelf);
        _bottomView = [[XHVideoBottomView alloc] init];
        _bottomView.fullScreenBlock = ^(BOOL isFull){
            if(isFull){
                [UIDevice rotateToOrientation:UIInterfaceOrientationLandscapeRight];
            }else{
                [UIDevice rotateToOrientation:UIInterfaceOrientationPortrait];
            }
            [weakSelf changeFullScreen:isFull];
        };
        
        _bottomView.valueChangedBlock = ^(float value) {
            [kVideoPlayerManager seekToTime:value];
        };
    }
    return _bottomView;
}

- (XHPlayerView *)playerView{
    if (!_playerView) {
        _playerView = [[XHPlayerView alloc] init];
    }
    return _playerView;
}


- (void)setUrl:(NSString *)url{
    if (!url) return;
    
    if (![_url isEqualToString:url]) {//若切换URL
        //清除视频标题
        self.videoTitle = @"";
    }
    
    //记录播放时长
    [kVideoPlayerManager recordUrl:_url playTime:self.bottomView.progressValue];
    
    _url = url;
    
    [self clearInfo];
    [self.playerView setPlayer:[kVideoPlayerManager setUrl:_url]];
    self.maskView.maskViewStatus = VideoMaskViewStatus_showLoading;
}

- (void)setVideoTitle:(NSString *)videoTitle{
    _videoTitle = videoTitle;
    self.topView.title = videoTitle;
}

- (void)setPlayStatus:(VideoPlayerStatus)playStatus{
    
    self.prePlayStatus = _playStatus;
    _playStatus = playStatus;
}

- (XHVideoConfigModel *)configModel{
    
    if (!_configModel) {
        _configModel = [[XHVideoConfigModel alloc] init];
        _configModel.autoPlay = YES;//默认设置url自动播放
    }
    return _configModel;
}


- (void)setIsFullScreen:(BOOL)isFullScreen{
    
    if (_isFullScreen != isFullScreen) {
        _isFullScreen = isFullScreen;
        //屏幕切换回调
        if (self.screenChangedBlock) {
            self.screenChangedBlock(isFullScreen);
        }
    }
}
#pragma mark - 触摸事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    UITouch * touch = [touches anyObject];
    self.startPoint = [touch locationInView:self];
    self.sysVolume = self.volumeSlider.value;
    self.brightness = [UIScreen mainScreen].brightness;
    self.currentTime = self.bottomView.progressValue;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesMoved:touches withEvent:event];
    
    //状态未知时不可拖动 如（未进入准备状态）
    if(self.playStatus == videoPlayer_unknown ||
       self.playStatus == videoPlayer_playFailed ||
       self.playStatus == videoPlayer_playEnd ||
       self.playStatus == videoPlayer_loading){
        return;
    }
    
    [self setSecondsForBottom:maxSecondsForBottom];
    UITouch * touch = [touches anyObject];
    CGPoint movePoint = [touch locationInView:self];
    
    CGFloat subX = movePoint.x - self.startPoint.x;
    CGFloat subY = movePoint.y - self.startPoint.y;
    CGFloat width  = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    BOOL startInLeft = movePoint.x < width/2.f;
    
    
    if (self.moveDirection == MoveDirection_none) {
        if (subX >= 30) {
            self.moveDirection = MoveDirection_right;
        }else if(subX <= -30){
            self.moveDirection = MoveDirection_left;
        }else if (subY >= 30){
            self.moveDirection = MoveDirection_down;
        }else if (subY <= -30){
            self.moveDirection = MoveDirection_up;
        }
    }
    
    if (self.moveDirection == MoveDirection_right || self.moveDirection == MoveDirection_left) {//快进
        CGFloat ratio = subX/width;
        CGFloat offsetSeconds = self.bottomView.maximumValue*ratio;
        CGFloat seekTime = self.currentTime + offsetSeconds;
        [self.maskView.fastForwardView setMaxDuration:self.bottomView.maximumValue];
        self.maskView.maskViewStatus = VideoMaskViewStatus_showFastForward;
        [self.maskView.fastForwardView moveRight:offsetSeconds>0];
        [self.maskView.fastForwardView setProgress:seekTime/self.bottomView.maximumValue];
        [self resetTimer];
        [self.bottomView hide];
    }else if (self.moveDirection == MoveDirection_up || self.moveDirection == MoveDirection_down){
        if (startInLeft) {//上调亮度
            [UIScreen mainScreen].brightness = self.brightness - subY/height;//10;
        }else{//上调音量
            self.volumeSlider.value = self.sysVolume - subY/height;//10;
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesEnded:touches withEvent:event];
    if (self.moveDirection == MoveDirection_left || self.moveDirection == MoveDirection_right) {
        [kVideoPlayerManager seekToTime:self.maskView.fastForwardView.currentDuration];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.playStatus = self.prePlayStatus;
            [self cancelTimerAndHideViews];
        });
    }
    [self setMoveDirection:MoveDirection_none];
    [self setCurrentTime:0];
}


#pragma mark - 屏幕旋转
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //全屏不支持屏幕旋转
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            //屏幕从竖屏变为横屏时执行
            [self changeFullScreen:YES];
        }else{
            //屏幕从横屏变为竖屏时执行
            [self changeFullScreen:NO];
        }
    });
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    
}







@end
