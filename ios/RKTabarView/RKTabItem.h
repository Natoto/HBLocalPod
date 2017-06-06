//  Created by Rafael Kayumov (RealPoc).
//  Copyright (c) 2013 Rafael Kayumov. License: MIT.
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum {
    TabStateEnabled,
    TabStateDisabled,
    TabStateHignLight
} TabState;

typedef enum {
    TabTypeUsual,
    TabTypeButton,
    TabTypeUnexcludable
} TabType;

@interface RKTabItem : NSObject

@property (nonatomic, strong) UIImage *imageHightLight;
@property (nonatomic,assign) BOOL centerItem;
@property (nonatomic,assign) BOOL newMessage;;
@property (readwrite) TabState tabState;
@property (readonly) TabType tabType;
@property (nonatomic, assign, readonly) id target;
@property (readonly) SEL selector;
@property (nonatomic, strong) UIColor *enabledBackgroundColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleFontColor;
@property (nonatomic, strong) UIColor *enableTitleFontColor;
@property (nonatomic, strong, readonly) UIImage *imageForCurrentState;
@property (nonatomic, strong, readonly) UIColor * titleStringForCurrentState;

+ (RKTabItem *)createUsualItemWithImageEnabled:(UIImage *)imageEnabled
                               imageDisabled:(UIImage *)imageDisabled;

+ (RKTabItem *)createUnexcludableItemWithImageEnabled:(UIImage *)imageEnabled
                               imageDisabled:(UIImage *)imageDisabled;

+ (RKTabItem *)createButtonItemWithImage:(UIImage *)image
                         target:(id)target
                       selector:(SEL)selector;

+ (RKTabItem *)createButtonItemWithImage:(UIImage *)imageEnabled
                         imageHightLight:(UIImage *)imageHightLight
                                  target:(id)target
                                selector:(SEL)selector ;
- (void)switchState;

@end
