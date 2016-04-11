//
//  SelectLocationAnnotation.h
//  FindCat
//
//  Created by 王晴 on 16/4/10.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Location.h"

@interface CalloutMapAnnotation : NSObject<MKAnnotation>

@property (nonatomic,assign) CLLocationDegrees latitude;
@property (nonatomic,assign) CLLocationDegrees longitude;
@property (nonatomic,strong) Location *location;
@property (nonatomic,assign) BOOL preventSelectionChange;

- (id)initWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude;

@end
