//
//  SMDAlertView.h
//  fenda
//
//  Created by boob on 16/11/23.
//  Copyright © 2016年 YY.COM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SMDVoidBlock)();

typedef void (^SMDDismissBlock)(int buttonIndex);
typedef void (^SMDCancelBlock)();
typedef void (^PhotoPickedBlock)(UIImage *chosenImage);

@interface SMDAlertView : UIView

+ (instancetype ) alertViewWithTitle:(NSString*) title
                             message:(NSString*) message
                              detail:(NSString *) detail
                      cancelButtonTitle:(NSString*) cancelButtonTitle
                      otherButtonTitles:(NSArray*) otherButtons
                              onDismiss:(SMDDismissBlock) dismissed
                               onCancel:(SMDCancelBlock) cancelled;



+ (instancetype ) alertViewWithTitle:(NSString*) title
                               message:(NSString*) message
                     cancelButtonTitle:(NSString*) cancelButtonTitle;


+ (instancetype ) alertViewWithTitle:(NSString *) title
                             message:(NSString *) message
                              detail:(NSString *) detail
                   cancelButtonTitle:(NSString*) cancelButtonTitle;
@end
