//
//  Location.m
//  FindCat
//
//  Created by 王晴 on 16/3/9.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import "Location.h"
#import "Cat.h"

@implementation Location

#pragma mark - MKAnnotation

- (CLLocationCoordinate2D)coordinate{
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

@end
