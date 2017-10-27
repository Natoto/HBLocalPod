//
//  PPStickTextView.h
//  POPA
//
//  Created by boob on 2017/9/30.
//  Copyright © 2017年 YY.COM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PPStickLabel;
@interface PPStickTextView : UIView
@property (nonatomic, strong) NSString * text;
@property (nonatomic, assign) NSTextAlignment  textAlignment;
@property (nonatomic, strong) UIFont * font;
@property (nonatomic, strong) UIView * inputView;
@property (nonatomic, strong) UIColor * textColor;
@property (nonatomic, assign) UIReturnKeyType returnKeyType;
@property (nonatomic, weak) id<UITextViewDelegate> delegate;

@property (nonatomic, strong) UITextView * textView;
@property (nonatomic, strong) PPStickLabel * label;

- (void)scaleTextView:(UIPinchGestureRecognizer *)pinchGestRecognizer;

@end


@interface NSString(OneKit)

/**
 *  判断字符串是否为空
 *
 *  @return 结果
 */
+ (BOOL)isEmpty:(NSString*)str;

/**
 *  创建GUID字符串
 *
 *  @return 结果
 */
+ (NSString*)newGUID;
/**
 * 用0填充字符串
 * @param value 数字
 * @param length 长度
 * @return 结果
 */
+ (NSString*)fill:(NSInteger)value length:(NSInteger)length;
/**
 *  去掉换行和空白字符
 *
 *  @return 结果
 */
- (NSString*)trim;

/**
 *  子字符串在父字符串中的位置(从哪里开始)
 *
 *  @param string 子字符串
 *
 *  @return 位置
 */
- (NSInteger)indexOf:(NSString *)string;

/**
 *  判断字符串中是否包含所传入的字符串
 *
 *  @param string 字符串
 *
 *  @return 结果
 */
- (BOOL)contains:(NSString *)string;

/**
 *  判断字符串是否以当前传入的字符串为开始
 *
 *  @param string 字符串
 *
 *  @return 结果
 */
- (BOOL)startWith:(NSString *)string;

/**
 *  判断字符串是否以当前传入的字符串为结束
 *
 *  @param string 字符串
 *
 *  @return 结果
 */
- (BOOL)endWith:(NSString *)string;

/**
 *  替换字符串中的内容
 *
 *  @param target 被替换的字符串
 *  @param to     目标字符串
 *
 *  @return 结果
 */
- (NSString*)replace:(NSString *)target to:(NSString*)to;

/**
 *  将字符串中的内容通过“split”标识拆分成数组
 *
 *  @param split 分隔符
 *
 *  @return 结果数组
 */
- (NSArray*)split:(NSString *)split;

/**
 *  将字符串以URL编码
 *
 *  @return 结果
 */
- (NSString *)URLEncode;

/**
 *  计算字符串大小
 *
 *  @param size 大小
 *  @param font 字体大小
 *
 *  @return 返回结果
 */
- (CGSize)sizeWithSize:(CGSize)size font:(UIFont*)font;

@end
