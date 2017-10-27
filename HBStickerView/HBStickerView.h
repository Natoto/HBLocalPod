//
//  StickerView.h
//  StickerDemo
//
//  Created by CKJ on 16/1/26.
//  Copyright © 2016年 CKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StickerViewDelegate;

typedef enum : NSUInteger {
    HBSTICK_TXT = 100,
    HBSTICK_EMOJI,
    HBSTICK_IMAGE,
    HBSTICK_BGIMAGE, //背景图片，不可移动
} HBSTICK_TYPE;

@interface HBStickerView : UIView

@property (nonatomic, assign) HBSTICK_TYPE stickType;

@property (strong, nonatomic) UIView *contentView;

@property (assign, nonatomic) BOOL enabledControl; // determine the control view is shown or not, default is YES
@property (assign, nonatomic) BOOL enabledDeleteControl; // default is YES
@property (assign, nonatomic) BOOL enabledShakeAnimation; // default is YES
@property (assign, nonatomic) BOOL enabledBorder; // default is YES

@property (strong, nonatomic) UIImage *contentImage;
@property (assign, nonatomic) id<StickerViewDelegate> delegate;


- (instancetype)initWithContentFrame:(CGRect)frame contentImage:(UIImage *)contentImage isbgimage:(BOOL)isbg;
- (instancetype)initWithContentFrame:(CGRect)frame contentImage:(UIImage *)contentImage;
- (instancetype)initWithContentFrame:(CGRect)frame text:(NSString *)text;
- (instancetype)initWithContentFrame:(CGRect)frame contentView:(UIView *)contentView;

- (void)performTapOperation;

@end

@protocol StickerViewDelegate <NSObject>

@optional

- (void)stickerViewDidTapContentView:(HBStickerView *)stickerView;

- (void)stickerViewDidTapDeleteControl:(HBStickerView *)stickerView;

- (UIImage *)stickerView:(HBStickerView *)stickerView imageForRightTopControl:(CGSize)recommendedSize;

- (void)stickerViewDidTapRightTopControl:(HBStickerView *)stickerView; // Effective when resource is provided.

- (UIImage *)stickerView:(HBStickerView *)stickerView imageForLeftBottomControl:(CGSize)recommendedSize;

- (void)stickerViewDidTapLeftBottomControl:(HBStickerView *)stickerView; // Effective when resource is provided.

- (void)stickerViewEndMoveControl:(HBStickerView *)stickerView center:(CGPoint)center;


- (void)stickerViewMovingControl:(HBStickerView *)stickerView center:(CGPoint)center;



@end
