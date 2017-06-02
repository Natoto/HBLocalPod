 
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark -

#undef	__IMAGE
#define __IMAGE( __name )	[UIImage imageNamed:__name]

#pragma mark -

@interface UIImage(Theme)

- (UIImage *)transprent;

- (UIImage *)rounded;
- (UIImage *)rounded:(CGRect)rect;

- (UIImage *)stretched;
- (UIImage *)stretched:(UIEdgeInsets)capInsets;

- (UIImage *)rotate:(CGFloat)angle;
- (UIImage *)rotateCW90;
- (UIImage *)rotateCW180;
- (UIImage *)rotateCW270;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees block:(void(^)(UIImage * img))imageblock;

- (UIImage *)grayscale;

- (UIColor *)patternColor;

- (UIImage *)crop:(CGRect)rect;
- (UIImage *)cropToSquare;
- (UIImage *)cropToRatio:(CGFloat)ratio;//按比例裁剪 不变形处理
- (UIImage *)imageInRect:(CGRect)rect;

+ (UIImage *)imageFromString:(NSString *)name;
+ (UIImage *)imageFromString:(NSString *)name atPath:(NSString *)path;
+ (UIImage *)imageFromString:(NSString *)name stretched:(UIEdgeInsets)capInsets;
//+ (UIImage *)imageFromVideo:(NSURL *)videoURL atTime:(CMTime)time scale:(CGFloat)scale;

+ (UIImage *)merge:(NSArray *)images;
- (UIImage *)merge:(UIImage *)image;
- (UIImage *)resize:(CGSize)newSize;
- (UIImage *)scaleToSize:(CGSize)size;

- (NSData *)dataWithExt:(NSString *)ext;

- (UIImage *)fixOrientation;

/**
 * 通过颜色生成一种纯色的图片
 */
+(UIImage *)buttonImageFromColor:(UIColor *)color frame:(CGRect)frame;

/**
 * 创建圆角的图片
 */
+ (UIImage *)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;


+(UIImage *)imageFromText:(NSArray*) arrContent withFont: (CGFloat)fontSize;


@end

