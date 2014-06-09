//
//  GeofenceView.m
//  SwiftObjC
//
//  Created by Zakk Hoyt on 6/6/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWGeofenceView.h"


@interface VWWGeofenceView  ()
@end
@implementation VWWGeofenceView


+(Class)layerClass{
    return [CAShapeLayer class];
}


//-(void)awakeFromNib{
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CAShapeLayer *layer = (CAShapeLayer*)self.layer;
        
        CGPathRef path = CGPathCreateWithRect(self.bounds, NULL);
        _radius = self.bounds.size.width;
        [layer setPath:path];
        [layer setStrokeColor:[UIColor redColor].CGColor];
        [layer setLineWidth:6.0];
        [layer setStrokeStart:0];
        [layer setStrokeEnd:1.0];
        [layer setLineJoin:kCALineJoinBevel];
        [layer setLineCap:kCALineCapRound];
        [layer setFillColor:nil];
        
        CGPathRelease(path);
        

        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [tap requireGestureRecognizerToFail:doubleTap];
        [self addGestureRecognizer:tap];

    }
    return self;
}


-(void)doubleTap:(UITapGestureRecognizer*)recognizer{
    
}

-(void)tap:(UITapGestureRecognizer*)recognizer{
    [UIView animateWithDuration:1.0 animations:^{
        float rnd = arc4random() % 255 / 255.0;
        [self setAlpha:rnd];
    }];
}

-(void)setRadius:(CGFloat)radius{
    _radius = radius;
    CAShapeLayer *layer = (CAShapeLayer*)self.layer;
    
    
    CGPoint center = CGPointMake(CGRectGetMidX([self bounds]), CGRectGetMidY([self bounds]));

                                      
                                      
                                      
    CGPathRef path = CGPathCreateWithRect(CGRectMake(center.x - radius/2.0, center.y - radius/2.0, radius, radius), NULL);

    [layer setPath:path];
}
-(void)setStrokeEnd:(CGFloat)strokeEnd{
    _strokeEnd = strokeEnd;
    CAShapeLayer *layer = (CAShapeLayer*)self.layer;
    [layer setStrokeEnd:strokeEnd];
}


-(void)setLineDashLength:(NSInteger)lineDashLength{
    _lineDashLength = lineDashLength;
    CAShapeLayer *layer = (CAShapeLayer*)self.layer;

    if(lineDashLength > 0){
        [layer setLineDashPattern:@[@(lineDashLength), @(lineDashLength * 4)]];
    } else {
        [layer setLineDashPattern:nil];
    }
    
}

// lineCpa
// lineDashPattern
// lineDashPhase
// strokeColor
// strokeBegin
// strokeEnd
// fillColor

-(void)t{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath moveToPoint:CGPointMake(0, 220)];
    [bezierPath addCurveToPoint:CGPointMake(160, 115) controlPoint1:CGPointMake(0, 220) controlPoint2:CGPointMake(305, 20)];
    [bezierPath addCurveToPoint:CGPointMake(305, 20) controlPoint1:CGPointMake(300, 132) controlPoint2:CGPointMake(305, 20)];
    CAShapeLayer *shapeLayer = nil;
    [shapeLayer setPath:bezierPath.CGPath];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
