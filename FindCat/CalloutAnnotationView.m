//
//  LocationTagAnnotationView.m
//  FindCat
//
//  Created by 王晴 on 16/4/10.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import "CalloutAnnotationView.h"

#define  Arror_height 15

@implementation CalloutAnnotationView

-(instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, -88);
        self.frame = CGRectMake(0, 0, 240, 95);
        
        CalloutCell *locationCell = [[[NSBundle mainBundle]loadNibNamed:@"CalloutCell" owner:nil options:nil] firstObject];
        [self  addSubview:locationCell];
        self.locationTagView = locationCell;
    }
    return self;
}

- (void)showLocationDetails{
    NSLog(@"showLocationDetails");
}

-(void)drawRect:(CGRect)rect{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);    
}

-(void)drawInContext:(CGContextRef)context{
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
}

- (void)getDrawPath:(CGContextRef)context{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-Arror_height;
    
    CGContextMoveToPoint(context, midx+Arror_height, maxy);
    CGContextAddLineToPoint(context,midx, maxy+Arror_height);
    CGContextAddLineToPoint(context,midx-Arror_height, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

@end
