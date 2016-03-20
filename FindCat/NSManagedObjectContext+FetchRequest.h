//
//  NSManagedObjectContext+FetchRequest.h
//  FindCat
//
//  Created by 王晴 on 16/3/19.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (FetchRequest)

- (NSArray *)fetchRequestEntityForName:(NSString *)name;

@end
