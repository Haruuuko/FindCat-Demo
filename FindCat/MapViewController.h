//
//  FirstViewController.h
//  FindCat
//
//  Created by 王晴 on 16/2/5.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>

@property (nonatomic,strong)NSManagedObjectContext *managedObjectContext;

@end

