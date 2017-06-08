//
//  PPVideoWaterMarkModel.h
//  Pods
//
//  Created by boob on 2017/6/7.
//
//

#import <Foundation/Foundation.h>

@class GPUImageView;
@class PPVideoWaterMarkModel;

@protocol PPVideoWaterMarkModelDelegate <NSObject>

/**
 * 视频刷新时更新UI位置
 */
-(void)PPVideoWaterMarkModel:(PPVideoWaterMarkModel *)model uielementupdate:(UIView *)subview progress:(CGFloat)progress;

@end

@interface PPVideoWaterMarkModel : NSObject

@property (nonatomic, weak) id<PPVideoWaterMarkModelDelegate> delegate;

/**
 * 水印处理，完成之后才能执行保存到相册操作
 */
-(NSString *)MixVideoPathWithVedioUrl:(NSURL *)url subView:(UIView *)subView fromFilterView:(GPUImageView *)filterView progress:(void (^)(CGFloat))progressblock complete:(void(^)(NSURL * savepath))complete;



-(CATextLayer *)createtextlayer;

/**
 * 第二中方法处理水印
 */
- (void) createWatermark:(CATextLayer *)lable video:(NSURL*)videoURL
                complete:(void(^)(NSURL * savepath))complete;
/**
 * 保存视频到相册
 */
-(void)saveToAblum:(void(^)(NSURL *assetURL))block;


@end
