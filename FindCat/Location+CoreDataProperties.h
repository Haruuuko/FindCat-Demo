//
//  Location+CoreDataProperties.h
//  FindCat
//
//  Created by 王晴 on 16/3/17.
//  Copyright © 2016年 王晴. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Location.h"

NS_ASSUME_NONNULL_BEGIN

@class Cat;

@interface Location (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSString *locationDescription;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) CLPlacemark *placemark;
@property (nullable, nonatomic, retain) NSNumber *photoID;
@property (nullable, nonatomic, retain) NSSet<Cat *> *taggedCats;

@end

@interface Location (CoreDataGeneratedAccessors)

- (void)addTaggedCatsObject:(Cat *)value;
- (void)removeTaggedCatsObject:(Cat *)value;
- (void)addTaggedCats:(NSSet<Cat *> *)values;
- (void)removeTaggedCats:(NSSet<Cat *> *)values;

@end

NS_ASSUME_NONNULL_END
