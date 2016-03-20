//
//  AddCatTableViewController.h
//  FindCat
//
//  Created by 王晴 on 16/2/6.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Location+CoreDataProperties.h"

@interface TagCatTableViewController : UITableViewController<CLLocationManagerDelegate>

@property (strong, nonatomic) Location *tagDetail;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic,strong)NSManagedObjectContext *managedObjectContext;

@end
