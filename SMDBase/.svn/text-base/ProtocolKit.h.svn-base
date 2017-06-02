// The MIT License (MIT)
//
// Copyright (c) 2015-2016 forkingdog ( https://github.com/forkingdog )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "PKProtocolExtension.h"


#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
// NSLog(...) NSLog(__VA_ARGS__);
#define NSLogMethod NSLog(@"🔴类名与方法名：%s（在第%d行），描述：%@", __PRETTY_FUNCTION__, __LINE__, NSStringFromClass([self class]));
#else
#  define NSLog(...) ;
#  define NSLogMethod ;
#endif

//圆角
#define KT_CORNER_PROFILE2(VIEW)\
CAShapeLayer *acircle = [CAShapeLayer layer];\
acircle.path = [UIBezierPath bezierPathWithRoundedRect:VIEW.bounds  cornerRadius:VIEW.frame.size.height/2].CGPath;\
acircle.fillColor = [UIColor blackColor].CGColor;\
VIEW.layer.mask = acircle;

#define KT_CORNER_PROFILE(_OBJ) _OBJ.layer.masksToBounds = YES;\
[_OBJ.layer setCornerRadius:CGRectGetHeight([_OBJ bounds]) / 2];\
_OBJ.layer.borderWidth = 0;\
_OBJ.layer.borderColor = [[UIColor whiteColor] CGColor];

#define KT_CORNER_PROFILE_WIDTH(_OBJ, WIDTH) _OBJ.layer.masksToBounds = YES;\
[_OBJ.layer setCornerRadius:CGRectGetHeight([_OBJ bounds]) / 2.0];\
_OBJ.layer.borderWidth = WIDTH;\
_OBJ.layer.borderColor = [[UIColor whiteColor] CGColor];

#define KT_CORNER_RADIUS(_OBJ,_RADIUS)   _OBJ.layer.masksToBounds = YES;\
_OBJ.layer.cornerRadius = _RADIUS;

#define KT_LAYERBOARDER_COLOR(_OBJ,_WIDTH,_COLOR)   _OBJ.layer.masksToBounds = YES;\
_OBJ.layer.borderColor = _COLOR.CGColor;\
_OBJ.layer.borderWidth = _WIDTH;

#define KT_CORNER_RADIUS_VALUE_2    2.0f
#define KT_CORNER_RADIUS_VALUE_5    5.0f
#define KT_CORNER_RADIUS_VALUE_10   10.0f
#define KT_CORNER_RADIUS_VALUE_15   15.0f
#define KT_CORNER_RADIUS_VALUE_20   20.0f

//随机颜色
#define HBRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]
//----------------------------------------------------------------- 颜色
#define KT_HEXCOLORA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define KT_HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]

#define KT_HEXCOLORA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define KT_UIColorWithRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define KT_UIColorWithRGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0f]

//常用变量

//navigationbar 高度
#define HEIGHT_NAVIGATIONBAR 64.0
#define HEIGHT_NAVIGATIONCTR [UIScreen mainScreen].bounds.size.height - HEIGHT_NAVIGATIONBAR
#undef HEIGHT_TABBAR
#define HEIGHT_TABBAR  49.0

#define UISCREEN_BOUNDS ([UIScreen mainScreen].bounds)
#define UISCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define UISCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define APP_VERSION  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

