# XHPlayer
一个简单易用的播放器


kVideoPlayerManager.maxRecordCount = 2;    
XHFullPlayerViewController *videoPlayer = [[XHFullPlayerViewController alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, VideoH(kScreenWidth))];   
[self.view addSubview:videoPlayer.view];    
[self addChildViewController:videoPlayer];   
self.videoPlayerVC = videoPlayer;   
[self.videoPlayerVC setUrl:self.urls[0]];    
[self.videoPlayerVC setTitle:self.names[0]];   
  



![示例图](https://github.com/zxhkit/XHPlayer/blob/master/XHPlayer/XHPlayer/Snip.png)















