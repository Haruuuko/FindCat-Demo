//
//  NSManagedObjectContext+FetchRequest.m
//  FindCat
//
//  Created by 王晴 on 16/3/19.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import "NSManagedObjectContext+FetchRequest.h"

@implementation NSManagedObjectContext (FetchRequest)

- (NSArray *)fetchRequestEntityForName:(NSString *)name{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:name
                                              inManagedObjectContext:self];
    [fetchRequest setEntity:entity];

    NSError *error;
    NSArray *foundObjects = [self executeFetchRequest:fetchRequest error:&error];
    if (foundObjects == nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return foundObjects;
}

@end
