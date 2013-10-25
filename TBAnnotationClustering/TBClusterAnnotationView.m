//
//  TBClusterAnnotationView.m
//  TBAnnotationClustering
//
//  Created by Theodore Calmes on 10/4/13.
//  Copyright (c) 2013 Theodore Calmes. All rights reserved.
//

#import "TBClusterAnnotationView.h"

CGPoint TBRectCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGRect TBCenterRect(CGRect rect, CGPoint center)
{
    CGRect r = CGRectMake(center.x - rect.size.width/2.0,
                          center.y - rect.size.height/2.0,
                          rect.size.width,
                          rect.size.height);
    return r;
}

static CGFloat const TBScaleFactorAlpha = 0.3;
static CGFloat const TBScaleFactorBeta = 0.4;

CGFloat TBScaledValueForValue(CGFloat value)
{
    return 1.0 / (1.0 + expf(-1 * TBScaleFactorAlpha * powf(value, TBScaleFactorBeta)));
}

@interface TBClusterAnnotationView ()
@property (strong, nonatomic) UILabel *countLabel;
@end

@implementation TBClusterAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupLabel];
        [self setCount:1];
    }
    return self;
}

- (void)setupLabel
{
    _countLabel = [[UILabel alloc] initWithFrame:self.frame];
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    _countLabel.shadowOffset = CGSizeMake(0, -1);
    _countLabel.adjustsFontSizeToFitWidth = YES;
    _countLabel.numberOfLines = 1;
    _countLabel.font = [UIFont boldSystemFontOfSize:12];
    _countLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self addSubview:_countLabel];
}

- (void)setCount:(NSUInteger)count
{
    _count = count;

    CGRect newBounds = CGRectMake(0, 0, roundf(44 * TBScaledValueForValue(count)), roundf(44 * TBScaledValueForValue(count)));
    self.frame = TBCenterRect(newBounds, self.center);

    CGRect newLabelBounds = CGRectMake(0, 0, newBounds.size.width / 1.3, newBounds.size.height / 1.3);
    self.countLabel.frame = TBCenterRect(newLabelBounds, TBRectCenter(newBounds));
    self.countLabel.text = [@(_count) stringValue];

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetAllowsAntialiasing(context, true);

    UIColor *outerCircleStrokeColor = [UIColor colorWithWhite:0 alpha:0.25];
    UIColor *innerCircleStrokeColor = [UIColor whiteColor];
    UIColor *innerCircleFillColor = [UIColor colorWithRed:(255.0 / 255.0) green:(95 / 255.0) blue:(42 / 255.0) alpha:1.0];

    CGRect circleFrame = CGRectInset(rect, 4, 4);

    [outerCircleStrokeColor setStroke];
    CGContextSetLineWidth(context, 5.0);
    CGContextStrokeEllipseInRect(context, circleFrame);

    [innerCircleStrokeColor setStroke];
    CGContextSetLineWidth(context, 4);
    CGContextStrokeEllipseInRect(context, circleFrame);

    [innerCircleFillColor setFill];
    CGContextFillEllipseInRect(context, circleFrame);
}

@end
