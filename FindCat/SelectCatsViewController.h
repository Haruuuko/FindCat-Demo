//
//  SelectCatsViewController.h
//  FindCat
//
//  Created by 王晴 on 16/2/15.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface SelectCatsViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *chosenCats;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
