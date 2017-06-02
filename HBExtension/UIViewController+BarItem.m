//
//  UINavigationController+BarItem.m
//  JHTDoctor
//
//  Created by boob on 16/5/23.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import "UIViewController+BarItem.h"


@implementation UIViewController(BarItem)


-(UIButton *)setrightBarButtonItemWithImage:(UIImage *)image target:(id)target selector:(SEL)selector
{
    return [self setBarButtonItemWithImage:image leftbar:NO target:target selector:selector];
}

-(UIButton *)setrightBarButtonItemWithTitle:(NSString *)title target:(id)target selector:(SEL)selector
{
    return [self setBarButtonItemWithTitle:title leftbar:NO target:target selector:selector];
}

-(UIButton *)setleftBarButtonItemWithImage:(UIImage *)image target:(id)target selector:(SEL)selector
{
    return [self setBarButtonItemWithImage:image leftbar:YES target:target selector:selector];
}

-(UIButton *)setleftBarButtonItemWithTitle:(NSString *)title target:(id)target selector:(SEL)selector
{
    return [self setBarButtonItemWithTitle:title leftbar:YES target:target selector:selector];
}

-(UIButton *)setBarButtonItemWithTitle:(NSString *)title leftbar:(BOOL)left target:(id)target selector:(SEL)selector
{
    return [self setBarButtonItemWithTitle:title image:nil leftbar:left target:target selector:selector];
}

-(UIButton *)setBarButtonItemWithImage:(UIImage *)image leftbar:(BOOL)left target:(id)target selector:(SEL)selector
{
    return [self setBarButtonItemWithTitle:nil image:image leftbar:left target:target selector:selector];
}



-(UIButton *)setBarButtonItemWithTitle:(NSString *)title image:(UIImage *)image leftbar:(BOOL)left target:(id)target selector:(SEL)selector
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:17.];
    if (!image && title) {
        //button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTintColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        
    }
    if (title){
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    if (selector) {
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        //         button.showsTouchWhenHighlighted = YES;
    }
    if (left) {
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.frame = CGRectMake(0, 0, 60, 30);
         UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    else
    {
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.frame = CGRectMake(0, 0, 60, 30);
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    return button;
}


-(void)setBarButtonItemWithTitles:(NSArray *)titles images:(NSArray<UIImage *> *)images leftbar:(BOOL)left target:(id)target selector:(SEL)selector
{
    
    NSMutableArray * items = [NSMutableArray  new];
    NSInteger maxcount = MAX(titles.count, images.count);
    for (NSInteger index = 0; index < maxcount; index++) {
        UIImage * image;
        if (images.count > index) {
            image = images[index];
        }
        NSString * title;
        if (titles.count > index) {
            title = titles[index];
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:17.];
        button.tag = 100 + index;
        if (!image && title) {
            //button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button setTintColor:[UIColor whiteColor]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
            
        }
        if (title){
            [button setTitle:title forState:UIControlStateNormal];
        }
        if (image) {
            [button setImage:image forState:UIControlStateNormal];
        }
        if (selector) {
            [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
            //         button.showsTouchWhenHighlighted = YES;
        }
        if (left) {
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//            button.frame = CGRectMake(0, 0, 60, 30);
            [button sizeToFit];
            UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
            [items addObject:leftItem];
        }
        else
        {
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//            button.frame = CGRectMake(0, 0, 60, 30);
            [button sizeToFit];
            UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//            self.navigationItem.rightBarButtonItem = rightItem;
            [items addObject:rightItem];
        }
    }
 
    if (left) {
        [self.navigationItem setLeftBarButtonItems:items];
 
    }
    else
    {
        [self.navigationItem setRightBarButtonItems:items];
 
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
