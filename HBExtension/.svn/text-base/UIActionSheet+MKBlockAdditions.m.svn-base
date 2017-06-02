//
//  UIActionSheet+MKBlockAdditions.m
//  UIKitCategoryAdditions
//
//  Created by Mugunth on 21/03/11.
//  Copyright 2011 Steinlogic All rights reserved.
//

#import "UIActionSheet+MKBlockAdditions.h"
#import <objc/runtime.h>

@implementation UIActionSheet (MKBlockAdditions)

static const void *key_actionsheet_cancelBlock         = &key_actionsheet_cancelBlock;
static const void *key_actionsheet_dismissblock        = &key_actionsheet_dismissblock;

-(CancelBlock)cancelBlock
{
    return objc_getAssociatedObject(self, key_actionsheet_cancelBlock);
}
-(void)setCancelBlock:(CancelBlock)cancelBlock
{
    [self _checkActionSheetDelegate];
    objc_setAssociatedObject(self, key_actionsheet_cancelBlock, cancelBlock, OBJC_ASSOCIATION_COPY);
}

-(DismissBlock)dismissBlock
{
    return objc_getAssociatedObject(self, key_actionsheet_dismissblock);
}

-(void)setDismissBlock:(DismissBlock)dismissBlock
{
    [self _checkActionSheetDelegate];
    objc_setAssociatedObject(self, key_actionsheet_dismissblock, dismissBlock, OBJC_ASSOCIATION_COPY);
}
//将代理设为自己
- (void)_checkActionSheetDelegate {
    if (self.delegate != (id<UIActionSheetDelegate>)self) {
        //        objc_setAssociatedObject(self, UIActionSheetOriginalDelegateKey, self.delegate, OBJC_ASSOCIATION_ASSIGN);
        self.delegate = (id<UIActionSheetDelegate>)self;
    }
}

+(void) actionSheetWithTitle:(NSString*) title
                     message:(NSString*) message
                     buttons:(NSArray*) buttonTitles
                  showInView:(UIView*) view
                   onDismiss:(DismissBlock) dismissed                   
                    onCancel:(CancelBlock) cancelled
{    
    [UIActionSheet actionSheetWithTitle:title 
                                message:message 
                 destructiveButtonTitle:nil 
                                buttons:buttonTitles 
                             showInView:view 
                              onDismiss:dismissed 
                               onCancel:cancelled];
}

+ (void) actionSheetWithTitle:(NSString*) title                     
                      message:(NSString*) message          
       destructiveButtonTitle:(NSString*) destructiveButtonTitle
                      buttons:(NSArray*) buttonTitles
                   showInView:(UIView*) view
                    onDismiss:(DismissBlock) dismissed                   
                     onCancel:(CancelBlock) cancelled
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title 
                                                             delegate:nil
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:destructiveButtonTitle 
                                                    otherButtonTitles:nil];
    
    
    actionSheet.cancelBlock  = [cancelled copy];
    actionSheet.dismissBlock  = [dismissed copy];
    
    for(NSString* thisButtonTitle in buttonTitles)
        [actionSheet addButtonWithTitle:thisButtonTitle];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", @"")];
    actionSheet.cancelButtonIndex = [buttonTitles count];
    
    if(destructiveButtonTitle)
        actionSheet.cancelButtonIndex ++;
    
    if([view isKindOfClass:[UIView class]])
        [actionSheet showInView:view];
    
    if([view isKindOfClass:[UITabBar class]])
        [actionSheet showFromTabBar:(UITabBar*) view];
    
    if([view isKindOfClass:[UIBarButtonItem class]])
        [actionSheet showFromBarButtonItem:(UIBarButtonItem*) view animated:YES];
    
}


-(void)actionSheet:(UIActionSheet*) actionSheet didDismissWithButtonIndex:(NSInteger) buttonIndex
{
	if(buttonIndex == [actionSheet cancelButtonIndex])
	{
		self.cancelBlock();
	}
    else
    {
        self.dismissBlock((int)buttonIndex);
    }
//    NSLogMethod
}
#pragma mark - UIActionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLogMethod
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
//    NSLogMethod
}

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet {
//    NSLogMethod
}


- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    
//    NSLogMethod
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
//    NSLogMethod
}


@end
