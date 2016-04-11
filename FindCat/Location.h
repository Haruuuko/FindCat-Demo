//
//  Location.h
//  FindCat
//
//  Created by 王晴 on 16/3/9.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Location : NSManagedObject <MKAnnotation>

@end

NS_ASSUME_NONNULL_END

#import "Location+CoreDataProperties.h"
