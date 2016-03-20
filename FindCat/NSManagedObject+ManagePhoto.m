//
//  NSManagedObject+ManagePhoto.m
//  FindCat
//
//  Created by 王晴 on 16/3/19.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import "NSManagedObject+ManagePhoto.h"

@implementation NSManagedObject (ManagePhoto)

+ (NSInteger)nextPhotoId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger photoID = [defaults integerForKey:@"PhotoID"];
    [defaults setInteger:photoID+1 forKey:@"PhotoID"];
    [defaults synchronize];
    return photoID;
}

- (BOOL)hasPhotoAtIndex:(NSNumber *)photoID{
    return (photoID != nil)&&([photoID integerValue] != -1);
}

- (NSString *)photoPathAtIndex:(NSNumber *)photoID{
    NSString *filename = [NSString stringWithFormat: @"Photo-%ld.jpg", [photoID integerValue]];
    return [[self documentsDirectory] stringByAppendingPathComponent:filename];
}

- (UIImage *)photoImageAtIndex:(NSNumber *)photoID{
    NSAssert(photoID != nil, @"No photo ID set");
    NSAssert([photoID integerValue] != -1, @"Photo ID is -1");
    return [UIImage imageWithContentsOfFile:[self photoPathAtIndex:photoID]];
}

#pragma mark - private methods

- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];
    return documentsDirectory;
}

@end
