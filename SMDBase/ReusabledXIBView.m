//
//  BaseXIBView.m
//  PENG
//
//  Created by zeno on 15/11/13.
//  Copyright © 2015年 nonato. All rights reserved.
//

#import "ReusabledXIBView.h"
@interface ReusabledXIBView()
@end
@implementation ReusabledXIBView
////
//-(id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        UIView * contentView = [[[NSBundle mainBundle] loadNibNamed: NSStringFromClass([self class]) owner:self options:nil] firstObject];
//        
//        contentView.translatesAutoresizingMaskIntoConstraints = NO;
//        self.translatesAutoresizingMaskIntoConstraints = NO;
//        
//        [self addSubview: contentView];
//        
//        [self addConstraint: [NSLayoutConstraint constraintWithItem: contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem: self attribute:NSLayoutAttributeLeft multiplier: 1.0 constant: 0]];
//        [self addConstraint: [NSLayoutConstraint constraintWithItem: contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem: self attribute:NSLayoutAttributeRight multiplier: 1.0 constant: 0]];
//        [self addConstraint: [NSLayoutConstraint constraintWithItem: contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem: self attribute:NSLayoutAttributeTop multiplier: 1.0 constant: 0]];
//        [self addConstraint: [NSLayoutConstraint constraintWithItem: contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem: self attribute:NSLayoutAttributeBottom multiplier: 1.0 constant: 0]];
//        
//    }
//    return self;
//}


- (void)loadCardViewFromNib {
    if (!self.isViewLoadedFromNib) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        UIView * contentView = array.lastObject;
        [self addSubview:contentView];
        _reusecontentView = contentView;
         self.isViewLoadedFromNib = YES;
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadCardViewFromNib];
    }
    return self;
}

//
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        CGRect viewFrame = CGRectMake(0, frame, frame.size.width, frame.size.height);
//        self.frame = viewFrame;
        [self loadCardViewFromNib];
        self.reusecontentView.frame = self.bounds;
    }
    return self;
}

//
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) { 
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        UIView * contentView = array.lastObject;
        [self addSubview:contentView];
        _reusecontentView = contentView;
        self.isViewLoadedFromNib = YES;
        
        self.reusecontentView.translatesAutoresizingMaskIntoConstraints = NO;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint: [NSLayoutConstraint constraintWithItem: self.reusecontentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem: self attribute:NSLayoutAttributeLeft multiplier: 1.0 constant: 0]];
        [self addConstraint: [NSLayoutConstraint constraintWithItem: self.reusecontentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem: self attribute:NSLayoutAttributeRight multiplier: 1.0 constant: 0]];
        [self addConstraint: [NSLayoutConstraint constraintWithItem: self.reusecontentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem: self attribute:NSLayoutAttributeTop multiplier: 1.0 constant: 0]];
        [self addConstraint: [NSLayoutConstraint constraintWithItem: self.reusecontentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem: self attribute:NSLayoutAttributeBottom multiplier: 1.0 constant: 0]];
    }
    return self;
} 
@end
