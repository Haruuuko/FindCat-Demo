//
//  NSManagedObject+ManagePhoto.h
//  FindCat
//
//  Created by 王晴 on 16/3/19.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface NSManagedObject (ManagePhoto)

+ (NSInteger)nextPhotoId;
- (BOOL)hasPhotoAtIndex:(NSNumber *)photoID;
- (NSString *)photoPathAtIndex:(NSNumber *)photoID;
- (UIImage *)photoImageAtIndex:(NSNumber *)photoID;

@end
