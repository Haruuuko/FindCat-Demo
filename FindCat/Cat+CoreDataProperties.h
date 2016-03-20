//
//  Cat+CoreDataProperties.h
//  FindCat
//
//  Created by 王晴 on 16/3/17.
//  Copyright © 2016年 王晴. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Cat.h"

NS_ASSUME_NONNULL_BEGIN

@class Location;

@interface Cat (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *catName;
@property (nullable, nonatomic, retain) NSString *catNickname;
@property (nullable, nonatomic, retain) NSString *iconImage;
@property (nullable, nonatomic, retain) NSString *initial;
@property (nullable, nonatomic, retain) NSNumber *photoID;
@property (nullable, nonatomic, retain) NSSet<Location *> *taggedLocations;

@end

@interface Cat (CoreDataGeneratedAccessors)

- (void)addTaggedLocationsObject:(Location *)value;
- (void)removeTaggedLocationsObject:(Location *)value;
- (void)addTaggedLocations:(NSSet<Location *> *)values;
- (void)removeTaggedLocations:(NSSet<Location *> *)values;

@end

NS_ASSUME_NONNULL_END
