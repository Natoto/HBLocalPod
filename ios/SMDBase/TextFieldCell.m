//
//  TextFieldCell.m
//  hjb
//
//  Created by zeno on 16/3/16.
//  Copyright © 2016年 YY.COM All rights reserved.
//
#import <Masonry/Masonry.h>
#import "TextFieldCell.h"
#import "TextInputAccessoryView.h"

@interface TextFieldCell()<UITextFieldDelegate>
@property (strong, nonatomic) TextInputAccessoryView  * inputAccessoryView;
@end

@implementation TextFieldCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _txt_content = [UITextField new];
        _txt_content.delegate = self;
        _txt_content.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.contentView addSubview:_txt_content];
        [_txt_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 5, 5, 5));
        }];
        _txt_content.layer.cornerRadius = 5;
        _txt_content.layer.borderColor = [UIColor colorWithRed:229./255. green:229./255. blue:229./255 alpha:1].CGColor;
        _txt_content.layer.borderWidth = 0.5;
        _txt_content.backgroundColor = [UIColor colorWithRed:251./255. green:251./255. blue:251./255 alpha:1];
    }
    return self;
}


-(void)setcellTitle:(NSString *)title
{
    self.txt_content.text = title;
}


-(void)setcellplaceholder:(NSString *)placeholder
{
    self.txt_content.placeholder = placeholder;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(IBAction)AcessoryButtonTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hbtableViewCell:subView:TapWithTag:)]) {
        [self.delegate hbtableViewCell:self subView:sender TapWithTag:0x111];
    }
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


-(void)setcelldictionary:(NSMutableDictionary *)dictionary
{
    [super setcelldictionary:dictionary];
    if (dictionary[key_cellstruct_placehoder]) {
        self.txt_content.placeholder = [dictionary objectForKey:key_cellstruct_placehoder];
    }
    self.txt_content.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    NSString * keyboardtype = [dictionary objectForKey:key_cellstruct_txtkeyboardtype];
    self.txt_content.keyboardType = UIKeyboardTypeDefault;
    if (keyboardtype) {
        if ([keyboardtype isEqualToString:value_cellstruct_txtkeyboardtype_number]) {
            self.txt_content.keyboardType = UIKeyboardTypePhonePad;
        }
    }
    
    NSString * edgestr = dictionary[key_cellstruct_contentInsets];
    if (edgestr) {
        UIEdgeInsets  edge=UIEdgeInsetsFromString(edgestr);
        [_txt_content mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(edge);
        }];
    }
    NSString * txtalignment2 =  dictionary[key_cellstruct_textAlignment];
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
    
    
    
    NSNumber * secureentry = [dictionary objectForKey:key_cellstruct_txtsecureTextEntry];
    if (secureentry) {
        self.txt_content.secureTextEntry = secureentry.boolValue;
    }
    
    NSNumber * editing = [dictionary objectForKey:key_cellstruct_editing];
    if (editing) {
        self.editing = editing.boolValue;
    }
    
    NSNumber * editable = [dictionary objectForKey:key_cellstruct_editabled];
    if (editable) {
        self.txt_content.enabled = editable.boolValue;
    }
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

@end
