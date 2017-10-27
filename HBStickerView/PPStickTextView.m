//
//  PPStickTextView.m
//  POPA
//
//  Created by boob on 2017/9/30.
//  Copyright © 2017年 YY.COM. All rights reserved.
//

#import "PPStickTextView.h"
#import "PPStickLabel.h"
@interface PPStickTextView()<UITextViewDelegate>
//@property (nonatomic, strong)  * <#name#>;
@property (nonatomic, assign) CGAffineTransform oldTransform;
@end

@implementation PPStickTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label.frame = self.bounds;
        self.textView.frame = self.bounds;
        [self addSubview:self.label];
        [self addSubview:self.textView];
        self.textView.delegate = self;
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
//    self.label.frame = self.bounds;
//    self.textView.frame = self.bounds;
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _label.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _textView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}
-(BOOL)becomeFirstResponder{
//    self.oldTransform = self.transform;
//    self.transform = CGAffineTransformIdentity;
    [self showTextView:YES];
    return [self.textView becomeFirstResponder];
}
-(BOOL)resignFirstResponder{
    
//    self.transform = self.oldTransform;
    [self showTextView:NO];
    return [self.textView resignFirstResponder];
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}
 

-(void)showTextView:(BOOL)show{
    self.textView.hidden = !show;
    self.label.hidden = show;
}
- (void)scaleTextView:(UIPinchGestureRecognizer *)pinchGestRecognizer{
//    CGFloat scale = pinchGestRecognizer.scale;
//    self.font = [UIFont fontWithName:self.font.fontName size:self.font.pointSize*scale];
//    [self.delegate textViewDidChange:self];
}


-(void)textViewDidChange:(UITextView *)textView{
    
    _text = textView.text;
    _label.text = _text;
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:textView];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _text = textView.text;
    _label.text = _text;
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
      return  [self.delegate textViewShouldBeginEditing:textView];
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    _text = textView.text;
    _label.text = _text;
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
       return  [self.delegate textViewShouldEndEditing:textView];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    _text = textView.text;
    _label.text = _text;
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)]) {
        [self.delegate textViewDidBeginEditing:textView];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    _text = textView.text;
    _label.text = _text;
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self.delegate textViewDidEndEditing:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    _text = textView.text;
    if (self.delegate && [self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
       return  [self.delegate  textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}


-(void)setReturnKeyType:(UIReturnKeyType)returnKeyType{
    _returnKeyType = returnKeyType;
    self.textView.returnKeyType = returnKeyType;
}
-(void)setText:(NSString *)text{
    _text = text;
    self.textView.text = text;
    self.label.text = text;
}

-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.label.textColor = textColor;
    self.textView.textColor = textColor;
}

-(void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
    self.textView.textAlignment = textAlignment;
    self.label.textAlignment = textAlignment;
}

-(void)setInputView:(UIView *)inputView{
    _inputView = inputView;
    self.textView.inputView = inputView;
}

-(void)setFont:(UIFont *)font{
    _font = font;
    self.textView.font = font;
    self.label.font = font;
}


- (void)didMoveToWindow {
    self.contentScaleFactor = [UIScreen mainScreen].scale * 9.0;
//    self.scrollEnabled = NO;
}

- (PPStickLabel *)label {
    if (!_label) {
        _label = [[PPStickLabel alloc] init];
        UILabel * label = _label;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:40];
        label.adjustsFontSizeToFitWidth = YES;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _label;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor  = [UIColor clearColor];
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _textView;
}



@end

#define isNull(value) ((!value) || ((NSNull*)value == [NSNull null]))

@implementation NSString(OneKit)


+ (void)init
{
    //[OneKit init];
}
+ (BOOL)isEmpty:(NSString*)str
{
    if (isNull(str)) {
        return TRUE;
    }
    if([str isEqualToString:@""]){
        return TRUE;
    }
    return FALSE;
}

+ (NSString *)newGUID{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}
+ (NSString*)fill:(NSInteger)value length:(NSInteger)length
{
    NSString* RESULT = [NSString stringWithFormat:@"%ld",(long)value];
    while (RESULT.length<length) {
        RESULT = [NSString stringWithFormat:@"0%@",RESULT];
    }
    return RESULT;
}
- (NSString*)trim
{
    return  [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSInteger)indexOf:(NSString *)string
{
    NSRange range = [self rangeOfString:string];
    return range.location;
}

- (BOOL)contains:(NSString *)string
{
    return !([self indexOf:string]==NSNotFound);
}

- (BOOL)startWith:(NSString *)string
{
    return ([self indexOf:string]==0);
}

- (BOOL)endWith:(NSString *)string
{
    return ([self indexOf:string] == self.length - string.length);
}

- (NSString*)replace:(NSString *)target to:(NSString*)to
{
    return [self stringByReplacingOccurrencesOfString:target withString:to];
}

- (NSArray*)split:(NSString *)split
{
    return [self componentsSeparatedByString:split];
}

- (NSString *)URLEncode
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,    (CFStringRef)self,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
    return result;
}

- (CGSize)sizeWithSize:(CGSize)size font:(UIFont*)font
{
    return [self boundingRectWithSize:size
                              options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:@{NSFontAttributeName:font}
                              context:nil].size;
}

@end
