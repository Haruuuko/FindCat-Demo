//
//  SelectLocationAnnotation.m
//  FindCat
//
//  Created by 王晴 on 16/4/10.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import "CalloutMapAnnotation.h"

@implementation CalloutMapAnnotation

- (id)initWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude {
    if (self = [super init])
    {
        self.latitude = latitude;
        self.longitude = longitude;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.latitude;
    coordinate.longitude = self.longitude;
    return coordinate;
}

@end
