//
//  CatListViewController.h
//  FindCat
//
//  Created by 王晴 on 16/2/13.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CatListViewController : UITableViewController

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
