//
//  PPSlideCaptureView.m
//  VedioFilterDemo
//
//  Created by boob on 2017/5/24.
//  Copyright © 2017年 YY.COM. All rights reserved.
//


#import "PPCameraFilters.h"
#import "PPSlideCaptureView.h"

#import <GPUImage/GPUImage.h>

@interface PPSlideCaptureView()
{
    CGPoint beginpoint;
    BOOL isdraging;
}

@property (strong, nonatomic)  GPUImageView *vidioImageView;

//@property (strong, nonatomic)  GPUImageView *pictureImageView;

@property (retain, nonatomic)  GPUImageView *filter2View;

@property (nonatomic, strong)  UIImageView * maskview;

@property (nonatomic, strong) NSArray<GPUImageFilterGroup *> * ftgroups;


@end

@implementation PPSlideCaptureView
//@synthesize pictureImageView = _pictureImageView;
-(void)dealloc{
    NSLog(@"%s",__func__);
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self createsubviews];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self createsubviews];
}

-(void)createsubviews{
    
    UIImageView * imageview2 = [[UIImageView alloc] init];
    imageview2.backgroundColor = [UIColor whiteColor];
    imageview2.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
    imageview2.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.filter2View.maskView = imageview2;
    self.maskview = imageview2;
    
    [self.ftgroups enumerateObjectsUsingBlock:^(GPUImageFilterGroup * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.stillCamera addTarget:obj];
    }];
    
    GPUImageFilterGroup *f1 = self.ftgroups[0];//[PPCameraFilters sketch];
    
    [f1 addTarget:self.vidioImageView];
    self.currentIndex = 0;
    
    GPUImageFilterGroup *f2 = self.ftgroups[1]; //[PPCameraFilters contrast];
    [f2 addTarget:self.filter2View];
    self.maskIndex = 1;
    
}



/**
 * 当前滤镜
 */
-(GPUImageFilterGroup *)currentGroup{
    return self.ftgroups[_currentIndex];
}

//更新maskview滤镜
- (void)updateMaskFilterAtIndex:(NSInteger)index {
    
//    NSLog(@"%s %d",__func__,index);
    GPUImageFilterGroup * oldf2 = self.ftgroups[self.maskIndex];
    [oldf2 removeTarget:self.filter2View];
    
    GPUImageFilterGroup * f2 = self.ftgroups[index];
    [f2 addTarget:self.filter2View];
    self.maskIndex = index;
    
}


//本身
- (void)updateFilterAtIndex:(NSInteger)index {

    NSLog(@"%s %ld",__func__,(long)index);
    [self.currentGroup removeTarget:self.vidioImageView];
    
    GPUImageFilterGroup *filter = self.ftgroups[index];
    [filter addTarget:self.vidioImageView];
    
    _currentIndex = index;
    if (self.delegate && [self.delegate respondsToSelector:@selector(PPSlideCaptureView:updateFilterAtIndex:)]) {
        [self.delegate PPSlideCaptureView:self updateFilterAtIndex:index];
    }
    
}

-(NSArray<GPUImageFilterGroup *> *)ftgroups{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ftgroupsOfslideCaptureView:)]) {
        if (!_ftgroups) {
            _ftgroups = [self.delegate ftgroupsOfslideCaptureView:self];
        }
        return _ftgroups;
    }
    
    if (!_ftgroups) {
        GPUImageFilterGroup *f6 = [PPCameraFilters normal];
        GPUImageFilterGroup *f1 = [PPCameraFilters shiguang]; //ok
        GPUImageFilterGroup *f2 = [PPCameraFilters shaolv];
        GPUImageFilterGroup *f3 = [PPCameraFilters yese];
        GPUImageFilterGroup *f4 = [PPCameraFilters heibai]; //ok
        _ftgroups = @[f6,f1,f2,f3,f4]; 
    }
    return _ftgroups;
}


-(void)nextfliter:(NSInteger)idx{
    
//    NSLog(@"%s %d",__func__,idx);
    NSInteger nextidx = [self nextindex:idx];
    [self updateFilterAtIndex:nextidx];
    
}

-(void)lastfilter:(NSInteger)idx{
    
//    NSLog(@"%s %d",__func__,idx);
    NSInteger lastidx = [self lastindex:idx];
    [self updateFilterAtIndex:lastidx];
}
-(NSInteger)lastindex:(NSInteger)idx{
    return  (idx-1)<0?(self.ftgroups.count - 1):(idx-1);
}

-(NSInteger)nextindex:(NSInteger)idx{
    return  (idx+1)>(self.ftgroups.count-1)?(0):(idx+1);
}

-(void)movemaskviewfromLeft:(BOOL)isfromLeft isToRight:(BOOL)istoRight{
    
//    NSLog(@"isfromleft:%d istoright:%d",isfromLeft,istoRight);
    if (isfromLeft) {
        
        [UIView animateWithDuration:0.5 animations:^{
            if (istoRight) {
                self.maskview.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            }
            else{
                self.maskview.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
            }
        } completion:^(BOOL finished) {
            if (isfromLeft && istoRight) {
                [self lastfilter:self.currentIndex];
                //                self.maskview.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
            }
        }];
    }
    else{
        
        [UIView animateWithDuration:0.5 animations:^{
            if (istoRight) {
                self.maskview.frame = CGRectMake(self.bounds.size.width, 0, 0, self.bounds.size.height);
            }
            else{
                self.maskview.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            }
        } completion:^(BOOL finished) {
            if (!isfromLeft && !istoRight) {
                [self nextfliter:self.currentIndex];
                //                self.maskview.frame = CGRectMake(self.bounds.size.width, 0, 0, self.bounds.size.height);
            }
        }];
    }
}


#pragma mark - 手势

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    CGFloat offsetx = touchPoint.x - beginpoint.x;
    CGFloat absoffsetx = fabs(offsetx);
    //    NSLog(@"%f",offsetx);
    
    if (isdraging == NO) {
        if (absoffsetx > 5) {
            isdraging = YES;
            if (offsetx<0) {//向左滑动
                [self updateMaskFilterAtIndex:[self nextindex:self.currentIndex]];
            }
            else{
                [self updateMaskFilterAtIndex:[self lastindex:self.currentIndex]];
            }
        }
        else{
            NSLog(@"无效滑动....");
        }
        
    }
    else{
        if (offsetx > 0) {//向左走
            self.maskview.frame = CGRectMake(0, 0,  absoffsetx, self.bounds.size.height);
            NSLog(@">>>>>");
        }else{
            self.maskview.frame = CGRectMake(self.bounds.size.width  - absoffsetx, 0,  absoffsetx, self.bounds.size.height);
            //        NSLog(@"<<<<");
        }
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    beginpoint = touchPoint;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    CGFloat offsetx = touchPoint.x - beginpoint.x ;
    
    NSLog(@"%f",offsetx);
    
    CGFloat criticalwidth = 100;
    isdraging = NO;
    if (offsetx>0) {//从左向右滑动
        if (offsetx > criticalwidth) {//向右滑动
            [self movemaskviewfromLeft:YES isToRight:YES];
        }
        else{
            [self movemaskviewfromLeft:YES isToRight:NO];
        }
    }
    else{//从右向左滑动
        
        if (fabs(offsetx) < criticalwidth) {
            [self movemaskviewfromLeft:NO isToRight:YES];
        }
        else{
            [self movemaskviewfromLeft:NO isToRight:NO];
        }
    }
    
}

#pragma mark - setter getter 

-(GPUImageView *)vidioImageView{
    if (!_vidioImageView) {
        _vidioImageView = [[GPUImageView alloc] initWithFrame:self.bounds];
        _vidioImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:_vidioImageView];
    }
    return _vidioImageView;
}

-(GPUImageView *)filter2View{
    if (!_filter2View) {
        _filter2View = [[GPUImageView alloc] initWithFrame:self.vidioImageView.bounds];
        _filter2View.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self.vidioImageView addSubview:_filter2View];
    }
    return _filter2View;
}



- (GPUImageStillCamera *)stillCamera;
{
    if (!_stillCamera) {
        GPUImageStillCamera * imageCamera=[[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
        
        imageCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        imageCamera.horizontallyMirrorFrontFacingCamera = YES;
        imageCamera.horizontallyMirrorRearFacingCamera = NO;
        imageCamera.jpegCompressionQuality = 1;
        GPUImageFilter *filter=[[GPUImageFilter alloc] init]; //默认滤镜.
        [imageCamera addTarget:filter]; 
        _stillCamera = imageCamera;
    }
    return _stillCamera;
}


@end
