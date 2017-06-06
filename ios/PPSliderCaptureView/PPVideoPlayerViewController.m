

#import "PPVideoPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface PPVideoPlayerViewController ()
@property (nonatomic, strong) AVPlayerLayer *avplayer;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) AVPlayer * player;

@property (nonatomic, strong) UIImageView * imageView;

@end

@implementation PPVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view addSubview:self.button];
//    self.button.frame = CGRectMake(20, 20, 40, 40);
    [self imageView];
    if (self.videoPath) {
        self.player =  [AVPlayer playerWithURL:[NSURL fileURLWithPath:self.videoPath]];
        _avplayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _avplayer.frame = self.view.bounds;
        [self.imageView.layer insertSublayer:_avplayer atIndex:0];
        [_avplayer.player play];
        [self addNotification];
    }
    if (self.image) {
        self.imageView.image = self.image;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];

}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_imageView];
    }
    return _imageView;
}
-(IBAction)save:(id)sender{

    if (self.image) {
        UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        [self savesucctips];
    }
    if (self.videoPath) {
        [self save_to_photosAlbum:self.videoPath];
        
    }

}
-(void)dealloc{

    [self removeNotification];
}

/**
 *  添加播放器通知
 */
-(void)addNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 *  播放完成通知
 *
 *  @param notification 通知对象
 */
-(void)playbackFinished:(NSNotification *)notification{
    NSLog(@"视频播放完成.");
    // 播放完成后重复播放
    // 跳到最新的时间点开始播放
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player play];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSLog(@"baocun");
        [self save_to_photosAlbum:self.videoPath];
    }
}

-(void)save_to_photosAlbum:(NSString *)path
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
            
            UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    });
}

- (void)buttonClick
{
    [self dismissViewControllerAnimated:NO completion:nil];
}


// 视频保存回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        [self savesucctips];
    }
}
-(void)savesucctips{
    
    UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"保存成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertview show];
    NSLog(@"视频保存成功.");
}

- (UIButton *)button
{
   if(_button == nil)
   {
       _button = [UIButton buttonWithType:UIButtonTypeCustom];
       [_button setTitle:@"返回" forState:UIControlStateNormal];
       [_button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
   }
    return _button;
}

@end
