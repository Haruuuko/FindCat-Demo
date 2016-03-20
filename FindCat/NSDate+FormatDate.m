//
//  NSDate+FormatDate.m
//  FindCat
//
//  Created by 王晴 on 16/3/19.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import "NSDate+FormatDate.h"

@implementation NSDate (FormatDate)

- (NSString *)stringWithFormatDate{
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterNoStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
    }
    return [formatter stringFromDate:self];
}

@end
