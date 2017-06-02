//
//       _      ______
//	/\ _\ \    /\  __ \
//	\   _  \   \ \  __<
//	 \ \  \ \   \ \_____\
//	  \/   \/    \/_____/
//
//
//
//  Created by boob on 16/4/29.
//  Copyright © 2016年 YY.COM All rights reserved.
//

#import "TextFieldXibCell.h"

@interface TextFieldXibCell ()<UITextFieldDelegate>
#pragma mark- as

@property (strong,nonatomic) UIButton * btn_txtrightView;
@property (strong,nonatomic) UIButton * btn_txtleftView;
#pragma mark- model

@end

@implementation TextFieldXibCell

-(void)awakeFromNib
{
    //    [self inputAccessoryView];
    self.txt_content.delegate = self;
    self.txt_content.enablesReturnKeyAutomatically = YES;
}
-(void)setcellTitleFontsize:(NSNumber *)titleFontsize
{
    if (titleFontsize) {
//        self.lbl_title.font = [UIFont systemFontOfSize:titleFontsize.floatValue];
        self.txt_content.font = [UIFont systemFontOfSize:titleFontsize.floatValue];
    }
}

-(void)setcellplaceholder:(NSString *)placeholder
{
    self.txt_content.placeholder = placeholder;
}

-(void)setcellTitleColor:(NSString *)color
{
    if (color) {
//        self.lbl_title.textColor = [CELL_STRUCT_Common colorWithStructKey:color];
    }
}


-(void)setcellTitle:(NSString *)title
{
//    self.lbl_title.text = title.length?title:nil;
}

-(void)setcellValue:(NSString *)value
{
    self.txt_content.text = value.length?value:nil;
}

-(void)layoutSubviews{
    
    if (self.showTopLine) {
        [self drawToplinelayer];
    }
    else
    {
        [self clearTopLayer];
    }
    if (self.showBottomLine) {
        [self drawBottomlinelayer];
    }else
    {
        [self clearBottomLayer];
    }
    NSDictionary * dictionary = self.dictionary;
    NSString * edgeinsetsValue = [dictionary objectForKey:key_cellstruct_contentInsets];
    if (edgeinsetsValue && [[edgeinsetsValue class] isSubclassOfClass:[NSString class]]) {
        NSString * edgestring =  [dictionary objectForKey:key_cellstruct_contentInsets];
        UIEdgeInsets edgeinsets = UIEdgeInsetsFromString(edgestring);
        CGRect frame = CGRectMake(edgeinsets.left, edgeinsets.top, self.bounds.size.width - edgeinsets.left - edgeinsets.right, self.bounds.size.height - edgeinsets.top - edgeinsets.bottom);
        if (!CGRectEqualToRect(self.contentView.frame, frame)){
            self.contentView.frame = frame;
            self.selectedBackgroundView.frame = frame;
        }
    }
}
-(void)setcelldictionary:(NSMutableDictionary *)dictionary
{
    [super setcelldictionary:dictionary];
    NSString * viewbgclr = [dictionary objectForKey:@"key_view_background"];
    if (viewbgclr && [[viewbgclr class] isSubclassOfClass:[NSString class]] ) {
        self.backgroundColor = [CELL_STRUCT_Common colorWithStructKey:viewbgclr];
    }else
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    NSNumber * editable = [dictionary valueForKey:key_cellstruct_editabled];
    if (editable) {
        self.txt_content.enabled = editable.boolValue;
    }
    else
    {
        self.txt_content.enabled = !editable.boolValue;
    }
    
    NSString * keyboardtype = [dictionary valueForKey:key_cellstruct_txtkeyboardtype];
    if ([keyboardtype isEqualToString:value_cellstruct_txtkeyboardtype_number]) {
        self.txt_content.keyboardType = UIKeyboardTypeNumberPad;
        //        self.txt_content.inputAccessoryView = self.inputAccessoryView;
    }
    else
    {
        self.txt_content.keyboardType = UIKeyboardTypeDefault;
        //        self.txt_content.inputAccessoryView = nil;
    }
    
    NSNumber * securetxtenty = [dictionary valueForKey:key_cellstruct_lbltxtsecureTextEntry];
    self.txt_content.secureTextEntry = securetxtenty.boolValue;
//    NSString * txtalignment =  dictionary[key_cellstruct_textAlignment];
    NSString * txtalignment2 =  dictionary[key_cellstruct_textAlignment2];
    if ([txtalignment2 isEqualToString:value_cellstruct_textAlignment_center]) {
        self.txt_content.textAlignment = NSTextAlignmentCenter;
    }
    else if ([txtalignment2 isEqualToString:value_cellstruct_textAlignment_right]) {
        self.txt_content.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        self.txt_content.textAlignment = NSTextAlignmentLeft;
    }
    
    if (_btn_txtrightView) {
        NSString * rightbgcolor = dictionary[key_cellstruct_rightbgcolor];
        _btn_txtrightView.backgroundColor = [CELL_STRUCT_Common colorWithStructKey:rightbgcolor];
        
        NSString * righttitlecolor = dictionary[key_cellstruct_righttitlecolor];
        righttitlecolor = righttitlecolor?righttitlecolor:@"0xff6969";
        [_btn_txtrightView setTitleColor:[CELL_STRUCT_Common colorWithStructKey:righttitlecolor] forState:UIControlStateNormal];
    }
}

-(IBAction)done:(id)sender
{
    [self.txt_content resignFirstResponder];
}

//-(TextInputAccessoryView  *)inputAccessoryView
//{
//    if (!_inputAccessoryView) {
//        _inputAccessoryView = [TextInputAccessoryView  defaultAccessoryView];
//        [_inputAccessoryView addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _inputAccessoryView;
//}

-(BOOL)becomeFirstResponder
{
    [self.txt_content becomeFirstResponder];
    return YES;
}

-(BOOL)resignFirstResponder
{
    [self.txt_content resignFirstResponder];
    return  YES;
}
-(BOOL)isFirstResponder
{
    return [self.txt_content isFirstResponder];
}

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
       return [self.delegate EditTableViewCell:self textField:textField textChange:resultingString];
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
    else
        [textField resignFirstResponder];
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(CGSize)sizeThatFits:(CGSize)size
{
    [self.txt_content sizeToFit];
    if (self.txt_content.bounds.size.height < 40) {
        return CGSizeMake(size.width, 40);
    }
    else
    {
        return CGSizeMake(size.width, self.txt_content.bounds.size.height);
    }
}
//设置右边按钮文字
-(void)setcellRightValue:(NSString *)value
{
    if (value) {
        [self.btn_txtrightView setTitle:value forState:UIControlStateNormal];
        self.txt_content.rightView = self.btn_txtrightView;
        self.txt_content.rightViewMode = UITextFieldViewModeAlways;
    }
    else
    {
        _btn_txtrightView = nil;
        self.txt_content.rightView = nil;
    }
}
//设置右边按钮图标
-(void)setcellValue2:(NSString *)value
{
    if (value.length) {
        [self.btn_txtrightView setImage:[UIImage imageNamed:value] forState:UIControlStateNormal];
        self.txt_content.rightView = self.btn_txtrightView;
        self.txt_content.rightViewMode = UITextFieldViewModeAlways;
    }
    else
    {
        _btn_txtleftView = nil;
//        [_btn_txtrightView setImage:nil forState:UIControlStateNormal];
        self.txt_content.rightView = nil;
    }
}
-(void)setcellProfile:(NSString *)value
{
    if (value.length) {
        self.txt_content.leftView = self.btn_txtleftView;
        self.txt_content.leftViewMode = UITextFieldViewModeAlways;
//        self.widthoftitle.constant = 0;
        [self.btn_txtleftView setImage:[UIImage imageNamed:value] forState:UIControlStateNormal];
    }
    else
    {
//        self.widthoftitle.constant  = 70;
        self.txt_content.leftView = nil;
    }
}

-(IBAction)rightViewTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hbtableViewCell:subView:TapWithTag:)]) {
        [self.delegate hbtableViewCell:self subView:self.btn_txtrightView TapWithTag:0xe1];
    }
    else
    {
        [self.txt_content becomeFirstResponder];
    }
}

-(IBAction)leftViewTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hbtableViewCell:subView:TapWithTag:)]) {
        [self.delegate hbtableViewCell:self subView:self.btn_txtleftView TapWithTag:0xe0];
    }
}
-(UIButton *)btn_txtrightView
{
    UIButton * button;
    if (!_btn_txtrightView) {
        button = [UIButton  buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 80, self.bounds.size.height);
        [button setTitle:@"修改号码" forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13] ];
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [button addTarget:self action:@selector(rightViewTap:) forControlEvents:UIControlEventTouchUpInside];
        button.showsTouchWhenHighlighted = YES;
        //        button.adjustsImageWhenHighlighted = YES;
        //        button.reversesTitleShadowWhenHighlighted = YES;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [button setTitleColor:KT_HEXCOLORA(0xff6969 ,1) forState:UIControlStateNormal];
        _btn_txtrightView = button;
    }
    else
    {
        button = (UIButton *)_btn_txtrightView;
    }
    return button;
}

//@property (strong,nonatomic) UIButton * btn_txtleftView

-(UIButton *)btn_txtleftView
{
    UIButton * button;
    if (!_btn_txtleftView) {
        button = [UIButton  buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 30, 25);
        [button setTitle:@"" forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13] ];
        [button addTarget:self action:@selector(leftViewTap:) forControlEvents:UIControlEventTouchUpInside];
        button.showsTouchWhenHighlighted = YES;
        [button setTitleColor:KT_HEXCOLORA(0xff6969 ,1) forState:UIControlStateNormal];
        _btn_txtleftView = button;
    }
    else
    {
        button = (UIButton *)_btn_txtleftView;
    }
    return button;
}


@end
