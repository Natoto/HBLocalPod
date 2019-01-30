//
//  OJFSegmentedProgressView.m
//  OJFSegmentedProgressView
//
//  Created by Oliver Foggin on 05/10/13.
//  Copyright (c) 2013 Oliver Foggin. All rights reserved.
//

#import "HBSegmentedProgressView.h"

@implementation HBSegmentedProgressView

- (id)initWithNumberOfSegments:(NSUInteger)numberOfSegments
{
    self = [super init];
    if (self) {
        // Add customisation here...
        self.numberOfSegments = numberOfSegments;
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
        self.segmentSeparatorSize = 5.0;
        self.style = OJFSegmentedProgressViewStyleDiscrete;
    }
    return self;
}

- (id)init
{
    return [self initWithNumberOfSegments:10];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.numberOfSegments = 10;
        self.contentMode = UIViewContentModeRedraw;
        self.segmentSeparatorSize = 2.0;
        self.style = OJFSegmentedProgressViewStyleDiscrete;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.backgroundColor = [UIColor clearColor];
    self.numberOfSegments = 10;
    self.contentMode = UIViewContentModeRedraw;
    self.segmentSeparatorSize = 5.0;
    self.style = OJFSegmentedProgressViewStyleDiscrete;
}
-(void)setHidden:(BOOL)hidden{
    if (self.signalHide) {
        if (self.numberOfSegments == 1) {
            [super setHidden:YES];
        }
        else{
            [super setHidden:hidden];
        }
    }
    else{
        [super setHidden:hidden];
    }
}

-(void)setVideoIndex:(NSInteger)index progress:(CGFloat)progress{
    self.progress = index/(float)self.numberOfSegments + progress/(float)self.numberOfSegments;
}

- (void)setSegmentSeparatorSize:(CGFloat)segmentSeparatorSize
{
    if (segmentSeparatorSize <= 1) {
        segmentSeparatorSize = 1;
    }
    _segmentSeparatorSize = segmentSeparatorSize;
    [self setNeedsDisplay];
}

- (void)setNumberOfSegments:(NSUInteger)numberOfSegments
{
    if (numberOfSegments <= 0) {
        numberOfSegments = 1;
    }
    _numberOfSegments = numberOfSegments;
    [self setNeedsDisplay];
    if (self.signalHide && numberOfSegments == 1) {
        self.hidden = YES;
    }
}

- (void)setProgress:(float)progress
{
    int oldSegments = [self numberOfFullSegments];

    if (progress > 1.0) {
        _progress = 1.0;
    } else if (progress < 0.0) {
        _progress = 0.0;
    } else {
        _progress = progress;
    }

    if ([self numberOfFullSegments] != oldSegments
            || self.style == OJFSegmentedProgressViewStyleContinuous) {
        [self setNeedsDisplay];
    }
}

- (void)setStyle:(OJFSegmentedProgressViewStyle)style
{
    _style = style;
    [self setNeedsDisplay];
}

- (UIColor *)progressTintColor
{
    if (_progressTintColor == nil) {
        _progressTintColor = [UIColor blueColor];
    }
    return _progressTintColor;
}

- (UIColor *)trackTintColor
{
    if (_trackTintColor == nil) {
        _trackTintColor = [UIColor lightGrayColor];
    }
    return _trackTintColor;
}

- (int)numberOfFullSegments
{
    switch (self.style) {
        case OJFSegmentedProgressViewStyleDiscrete:
            return (int)roundf(self.numberOfSegments * self.progress);
        case OJFSegmentedProgressViewStyleContinuous:
            return (int)(self.numberOfSegments * self.progress);
    }
}

- (float)portionOfLastSegment
{
    return (self.numberOfSegments * self.progress) - (int)(self.numberOfSegments * self.progress);
}

- (float)segmentSize
{
    float segmentTotalSize = self.frame.size.width - self.segmentSeparatorSize * (self.numberOfSegments - 1);

    return segmentTotalSize / self.numberOfSegments;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    [self.progressTintColor set];
    UIColor * bgcolor = self.progressTintColor;
    
    float y = 0;
    float height = self.frame.size.height;
    float width = [self segmentSize];

    for (int segment = 0; segment < self.numberOfSegments; segment++) {
        float x = segment * (self.segmentSeparatorSize + width);

        if (self.style == OJFSegmentedProgressViewStyleContinuous
                && segment == [self numberOfFullSegments]) {
            float percentage = [self portionOfLastSegment];
            
           [self kt_drawRectWithRoundedCorner:height/2 frame:CGRectMake(x, y, width, height) context:context backgroundColor:self.trackTintColor borderColor:[UIColor clearColor]];
            
            CGRect fillrect = CGRectMake(x, y, width * percentage, height);
            [self kt_drawRectWithRoundedCorner:height/2.0 frame:fillrect context:context backgroundColor:self.progressTintColor borderColor:self.progressTintColor];
            
            [self.trackTintColor set];
            
            //[self kt_drawRectWithRoundedCorner:height/2.0 frame:CGRectMake(x + width * percentage, y, width - width * percentage, height) context:context backgroundColor:self.trackTintColor borderColor:self.trackTintColor];
            
        }

        if (segment >= [self numberOfFullSegments]) {
            [self.trackTintColor set];
            bgcolor = self.trackTintColor;
        }

        if (self.style == OJFSegmentedProgressViewStyleDiscrete
                || segment != [self numberOfFullSegments]){
            [self kt_drawRectWithRoundedCorner:height/2 frame:CGRectMake(x, y, width, height) context:context backgroundColor:bgcolor borderColor:[UIColor clearColor]];
        }

    }
}



-(void)kt_drawRectWithRoundedCorner:(CGFloat)radius
                              frame:(CGRect)frame
                            context:(CGContextRef)context
                    backgroundColor: (UIColor *)backgroundColor
                        borderColor: (UIColor *) borderColor{
    
    frame.size.width = frame.size.width<2*radius?2*radius:frame.size.width;
    CGFloat borderWidth = 0;
//    CGSize sizeToFit = frame.size;
    //CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    CGFloat halfBorderWidth =   borderWidth/ 2.0;
    CGFloat ex = CGRectGetMaxX(frame);
    CGFloat ey = CGRectGetMaxY(frame);
    
    CGFloat sx = CGRectGetMinX(frame);
    CGFloat sy = CGRectGetMinY(frame);
    
    
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
      
    //右上X
    CGFloat  rightTopX = ex - halfBorderWidth;
    //右上Y
    CGFloat rightTopY = sy + halfBorderWidth;
    
    //右下X
    CGFloat rightBottomX = ex - halfBorderWidth;
    //右下Y
    CGFloat rightBottomY = ey - halfBorderWidth; //height - halfBorderWidth;
    
    //左上x 左上y
    CGFloat leftTopX = sx + halfBorderWidth;
    CGFloat leftTopY = sy + halfBorderWidth;
    
    //左下x 左下y
    CGFloat leftBottomX = sx - halfBorderWidth;
    CGFloat leftBottomY = ey - halfBorderWidth;
    
    CGContextMoveToPoint(context, rightTopX - radius, rightTopY) ; // 开始坐标右边开始
    
    CGContextAddArcToPoint(context, rightTopX, rightTopY, rightBottomX, rightBottomY, radius);
    
    CGContextAddArcToPoint(context, rightBottomX, rightBottomY, leftBottomX, leftBottomY, radius);
    
    CGContextAddArcToPoint(context,leftBottomX, leftBottomY, leftTopX, leftTopY, radius);
    
    CGContextAddArcToPoint(context, leftTopX, leftTopY,rightTopX,rightTopY, radius);
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    
}



@end
