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

@property (strong, nonatomic)  UILabel  * lbl_title;
@property (strong, nonatomic)  UILabel  * lbl_message;
@property (strong, nonatomic)  UILabel  * lbl_detail;
@property (strong, nonatomic)  UIButton * btn_confirm;
@property (strong, nonatomic)  UIButton * btn_cancel;
@property (strong, nonatomic)  UIView   * alertView;
@property (nonatomic, assign) BOOL isshow;
-(void)dismiss;
-(void)dismiss:(BOOL)animation sender:(id)sender;


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
