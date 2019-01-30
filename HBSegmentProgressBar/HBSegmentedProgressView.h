//
//  OJFSegmentedProgressView.h
//  OJFSegmentedProgressView
//
//  Created by Oliver Foggin on 05/10/13.
//  Copyright (c) 2013 Oliver Foggin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    OJFSegmentedProgressViewStyleDiscrete,
    OJFSegmentedProgressViewStyleContinuous,
} OJFSegmentedProgressViewStyle;

@interface HBSegmentedProgressView : UIView

@property (nonatomic) NSUInteger numberOfSegments;
@property (nonatomic) CGFloat segmentSeparatorSize;
@property (nonatomic, assign) BOOL  signalHide;
@property (nonatomic) OJFSegmentedProgressViewStyle style;

@property (nonatomic) float progress;
@property (nonatomic, strong) UIColor *progressTintColor;
@property (nonatomic, strong) UIColor *trackTintColor;

- (id)initWithNumberOfSegments:(NSUInteger)numberOfSegments;

-(void)setVideoIndex:(NSInteger)index progress:(CGFloat)progress;
@end
