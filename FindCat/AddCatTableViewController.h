//
//  AddCatTableViewController.h
//  FindCat
//
//  Created by 王晴 on 16/2/16.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Cat;

@interface AddCatTableViewController : UITableViewController

@property (strong, nonatomic) Cat *editCat;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
