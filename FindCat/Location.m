//
//  Location.m
//  FindCat
//
//  Created by 王晴 on 16/3/9.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import "Location.h"
#import "Cat.h"
#import "NSDate+FormatDate.h"
#import "NSManagedObject+ManagePhoto.h"

@implementation Location

// Insert code here to add functionality to your managed object subclass

#pragma mark - MKAnnotation

- (CLLocationCoordinate2D)coordinate{
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

- (NSString *)title{
//    NSMutableString *cats = [[NSMutableString alloc]init];
//    for (Cat *cat in self.catsMember) {
//        [cats appendString:[NSString stringWithFormat:@"%@ ", cat.catName]];
//    }
//    return cats;
    return [self.date stringWithFormatDate];
}

- (NSString *)subtitle{
    return [NSString stringWithFormat:@"%@",self.placemark.name];
}

@end
