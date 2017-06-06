//
//  EditCellProtocol.h
//  PENG
//
//  Created by zeno on 15/8/27.
//  Copyright (c) 2015年 nonato. All rights reserved.
//

//#ifndef PENG_EditCellProtocol_h
//#define PENG_EditCellProtocol_h
//#endif
//#import "BaseTableViewCell.h"

@class BaseCollectionViewCell;
@class BaseTableViewCell;
/**
 *  含有 Textfield 编辑框的cell的协议
 */
@protocol EditTableViewCellDelegate

@optional

-(BOOL)EditTableViewCell:(BaseTableViewCell *)EditTableViewCell textFieldShouldReturn:(UITextField *)textField;
-(BOOL)EditTableViewCell:(BaseTableViewCell *)EditTableViewCell textField:(UITextField *)textField textChange:(NSString *)resultingString;
-(BOOL)EditTableViewCell:(BaseTableViewCell *)EditTableViewCell  textFieldShouldBeginEditing:(UITextField *)textField;
-(void)EditTableViewCell:(BaseTableViewCell *)EditTableViewCell textFieldDidEndEditing:(UITextField *)textField;
-(void)EditTableViewCell:(BaseTableViewCell *)EditTableViewCell textFieldDidBeginEditing:(UITextField *)textField;
@end
/**
 *  含有 textfield 编辑框的view的协议
 */
@protocol EditViewDelegate

@optional

-(BOOL)EditView:(UIView *)EditView textFieldShouldReturn:(UITextField *)textField;
-(BOOL)EditView:(UIView *)EditView textField:(UITextField *)textField textChange:(NSString *)resultingString;
-(BOOL)EditView:(UIView *)EditView  textFieldShouldBeginEditing:(UITextField *)textField;
-(void)EditView:(UIView *)EditView textFieldDidEndEditing:(UITextField *)textField;
-(void)EditView:(UIView *)EditView textFieldDidBeginEditing:(UITextField *)textField;
@end


@protocol EditCollectionViewCellDelegate

@optional

-(BOOL)EditCollectionViewCell:(BaseCollectionViewCell *)EditCollectionViewCell textFieldShouldReturn:(UITextField *)textField;
-(BOOL)EditCollectionViewCell:(BaseCollectionViewCell *)EditCollectionViewCell textField:(UITextField *)textField textChange:(NSString *)resultingString;
-(BOOL)EditCollectionViewCell:(BaseCollectionViewCell *)EditCollectionViewCell  textFieldShouldBeginEditing:(UITextField *)textField;
-(void)EditCollectionViewCell:(BaseCollectionViewCell *)EditCollectionViewCell textFieldDidEndEditing:(UITextField *)textField;
-(void)EditCollectionViewCell:(BaseCollectionViewCell *)EditCollectionViewCell textFieldDidBeginEditing:(UITextField *)textField;
@end



@protocol SoloTextViewCellDelegate <NSObject>

@optional
- (BOOL)SoloTextViewCell:(BaseTableViewCell *)cell textViewShouldBeginEditing:(UITextView *)textView;
- (BOOL)SoloTextViewCell:(BaseTableViewCell *)cell textViewShouldEndEditing:(UITextView *)textView;

- (void)SoloTextViewCell:(BaseTableViewCell *)cell textViewDidBeginEditing:(UITextView *)textView;
- (void)SoloTextViewCell:(BaseTableViewCell *)cell textViewDidEndEditing:(UITextView *)textView;

- (BOOL)SoloTextViewCell:(BaseTableViewCell *)cell textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text resultstring:(NSString *)resultstring;
- (void)SoloTextViewCell:(BaseTableViewCell *)cell textViewDidChange:(UITextView *)textView;

- (void)SoloTextViewCell:(BaseTableViewCell *)cell textViewDidChangeSelection:(UITextView *)textView;

- (void)SoloTextViewCell:(BaseTableViewCell *)cell textViewDidEndSelecting:(UITextView *)textView;

- (BOOL)SoloTextViewCell:(BaseTableViewCell *)cell textViewShouldReturn:(UITextView *)textView;
@end

/*
 #pragma mark textfield delegate
 
 -(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
 {
 if (self.delegate && [self.delegate respondsToSelector:@selector(EditTableViewCell:textFieldShouldBeginEditing:)]) {
 return [self.delegate EditTableViewCell:self textFieldShouldBeginEditing:textField];
 }
 return YES;
 }
 -(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
 {
 if (self.delegate && [self.delegate respondsToSelector:@selector(EditTableViewCell:textField:textChange:)]) {
 NSString *resultingString = [textField.text stringByReplacingCharactersInRange:range withString: string];
 //        NSLog(@"shouldChangeCharactersInRange: %@", resultingString);
 [self.delegate EditTableViewCell:self textField:textField textChange:resultingString];
 }
 return YES;
 }
 -(void)textFieldDidBeginEditing:(UITextField *)textField
 {
 if (self.delegate && [self.delegate respondsToSelector:@selector(EditTableViewCell:textFieldDidBeginEditing:)]) {
 [self.delegate EditTableViewCell:self textFieldDidBeginEditing:textField];
 }
 }
 -(void)textFieldDidEndEditing:(UITextField *)textField
 {
 if (self.delegate && [self.delegate respondsToSelector:@selector(EditTableViewCell:textFieldDidEndEditing:)]) {
 [self.delegate EditTableViewCell:self textFieldDidEndEditing:textField];
 }
 }
 
 -(BOOL)textFieldShouldReturn:(UITextField *)textField
 {
 if (self.delegate && [self.delegate respondsToSelector:@selector(EditTableViewCell:textFieldShouldReturn:)]) {
 return [self.delegate EditTableViewCell:self textFieldShouldReturn:textField];
 }
 return YES;
 }
 
 */
