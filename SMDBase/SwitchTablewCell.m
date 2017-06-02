//
//  SwitchTablewCell.m
//  hjb
//
//  Created by zeno on 16/3/18.
//  Copyright © 2016年 YY.COM All rights reserved.
//

#import "SwitchTablewCell.h"
@interface SwitchTablewCell()
@property(nonatomic,strong) UISwitch * m_switch;
@end
@implementation SwitchTablewCell
@synthesize AcessoryButton = _AcessoryButton;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(void)setcellRightValue:(NSString *)value
{
    if (value.length) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(hb_AcessoryButton:)]) {
            UIControl * control = [self.delegate hb_AcessoryButton:self];
            _AcessoryButton = control;
        }
        if (self.AcessoryButton) {
            if ([[self.AcessoryButton class] isSubclassOfClass:[UISwitch class]]) {
                UISwitch * btn = (UISwitch *)self.AcessoryButton;
                btn.on = value.boolValue;
            }
            self.accessoryView = self.AcessoryButton;
        }
    }
}

-(void)setcelldictionary:(NSMutableDictionary *)dictionary
{
    [super setcelldictionary:dictionary];
    
    NSString * ontintcolorstr = [dictionary objectForKey:key_cellswitch_onTintColor];
    if (ontintcolorstr.length) {
        UISwitch * btn = (UISwitch *)self.AcessoryButton;
        btn.onTintColor = [CELL_STRUCT_Common colorWithStructKey:ontintcolorstr];
    }    
    NSString * tintcolorstr = [dictionary objectForKey:key_cellswitch_tintColor];
    if (tintcolorstr.length) {
        UISwitch * btn = (UISwitch *)self.AcessoryButton;
        btn.tintColor = [CELL_STRUCT_Common colorWithStructKey:tintcolorstr];
    }
}

-(IBAction)dataChange:(UISwitch *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(PENGView:subView:TapWithObject:)]) {
        [self.delegate PENGView:self subView:sender TapWithObject:@(sender.on)];
    }
}
-(UISwitch *)AcessoryButton
{
    UISwitch * button;
    if (!_AcessoryButton) {
        button = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        [button addTarget:self action:@selector(dataChange:) forControlEvents:UIControlEventValueChanged];
        _AcessoryButton = button;
    }
    else
    {
        button = (UISwitch *)_AcessoryButton;
    }
    return button;
}

 
@end
