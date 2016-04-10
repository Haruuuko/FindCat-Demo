//
//  FirstViewController.m
//  FindCat
//
//  Created by 王晴 on 16/2/5.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import "MapViewController.h"
#import "TagCatTableViewController.h"
#import "Location.h"
#import "Cat.h"
#import "WGS84TOGCJ02.h"
#import "UIImage+Resize.h"
#import "NSManagedObject+ManagePhoto.h"
#import "NSManagedObjectContext+FetchRequest.h"
#import "LocalCatsTableViewController.h"

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CLLocation *updatingLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKAnnotationView *userLocationView;
@property (strong, nonatomic) NSArray *locationsInAll;

@end

@implementation MapViewController

#pragma mark - init and setup

- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
    }
    return _locationManager;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contextDidChange:)
                                                     name:NSManagedObjectContextObjectsDidChangeNotification
                                                   object:self.managedObjectContext];
    }
    return self;
}

- (void)checkLocationAuthorizationStatus{
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertController *locationAlert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                               message:@"请在设置中开启定位服务"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
        [locationAlert addAction:[UIAlertAction actionWithTitle:@"设置"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        if (UIApplicationOpenSettingsURLString != NULL) {
                                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                        }
                                                    }]];
        [locationAlert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                          style:UIAlertActionStyleDefault
                                                        handler:nil]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                       //在另外一个线程中处理这些操作，然后通知主线程更新界面。
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:locationAlert animated:YES completion:nil];
                
            });
        });
    }
}

- (void)contextDidChange:(NSNotification *)notification {
    if ([self isViewLoaded]) {
        [self updateLocations];
    }
}

- (void)updateLocations{
    if (self.locationsInAll != nil) {
        [self.mapView removeAnnotations:self.locationsInAll];
    }
    self.locationsInAll = [self.managedObjectContext fetchRequestEntityForName:@"Location"];
    [self.mapView addAnnotations:self.locationsInAll];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.mapView.delegate = self;
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 3.0;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    [self checkLocationAuthorizationStatus];
    [self.locationManager startUpdatingLocation];
    if ([CLLocationManager headingAvailable]) {
        self.locationManager.headingFilter = 5;
        [self.locationManager startUpdatingHeading];
    }
    [self updateLocations];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError %@", error);    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    if (locations != nil && locations.count > 0) {
        self.updatingLocation = [locations lastObject];
        
        //检查坐标是否在中国境内，并从WGS坐标系转为GCJ坐标系
        if (![WGS84TOGCJ02 isLocationOutOfChina:self.updatingLocation.coordinate]) {
            CLLocationCoordinate2D coordinateInGCJ = [WGS84TOGCJ02 transformFromWGSToGCJ:self.updatingLocation.coordinate];
            NSLog(@"%f, %f",coordinateInGCJ.latitude, coordinateInGCJ.longitude);
        
            MKCoordinateSpan span = MKCoordinateSpanMake(0.01,0.01);
            MKCoordinateRegion region = MKCoordinateRegionMake(coordinateInGCJ, span);
            [self.mapView setRegion:region animated:NO];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    //rotate the userLocationView arrow with heading
    if (newHeading.headingAccuracy > 0) {
        CLLocationDirection direction = newHeading.magneticHeading;
        CGAffineTransform transform = CGAffineTransformMakeRotation(direction*M_PI/180);
        self.userLocationView.transform = transform;
    }
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        self.userLocationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:@"userLocationIdentifier"];
        //use a custom image for the user annotation
        self.userLocationView.image = [UIImage imageNamed:@"userLocationArrow"];
        return self.userLocationView;
    }
    if ([annotation isKindOfClass:[Location class]]) {
        Location *location = (Location *)annotation;
        static NSString *catAnnotationIdentifier = @"CatAnnotationIdentifier";
        MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:catAnnotationIdentifier];
        
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc]initWithAnnotation:annotation
                                                  reuseIdentifier:catAnnotationIdentifier];
            
            UIImage *pinImage = [UIImage imageNamed:@"catPin"];
            UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [detailButton addTarget:self action:@selector(showLocationDetails:) forControlEvents:UIControlEventTouchUpInside];
            
            annotationView.image = pinImage;
            annotationView.centerOffset = CGPointMake(0, -20);
            annotationView.canShowCallout = YES;
            annotationView.rightCalloutAccessoryView = detailButton;
        }else{
            annotationView.annotation = annotation;
        }
        
        UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        if ([location hasPhotoAtIndex:location.photoID]) {
            leftView.image = [[location photoImageAtIndex:location.photoID]resizedImageWithBounds:CGSizeMake(44, 44)];
        }else{
            leftView.image = [UIImage imageNamed:@"catImage"];
            leftView.contentMode = UIViewContentModeScaleAspectFit;
        }
        annotationView.leftCalloutAccessoryView = leftView;
        
        UIButton *button = (UIButton *)annotationView.rightCalloutAccessoryView;
        button.tag = [self.locationsInAll indexOfObject:annotation];
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if ([view.annotation isKindOfClass:[Location class]]) {
        view.image = [UIImage imageNamed:@"catPinTouch"];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    if ([view.annotation isKindOfClass:[Location class]]) {
        view.image = [UIImage imageNamed:@"catPin"];
    }
}

#pragma mark - event response

- (void)showLocationDetails:(UIButton *)button{
    [self performSegueWithIdentifier:@"TagCat" sender:button];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"TagCat"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        TagCatTableViewController *controller = (TagCatTableViewController *)navigationController.topViewController;
        //判断是否点击大头针
        UIButton *button = (UIButton *)sender;
        if (button.buttonType == UIButtonTypeDetailDisclosure) {
            Location *location = self.locationsInAll[button.tag];
            controller.tagDetail = location;
        }        
        controller.location = self.updatingLocation;
        controller.managedObjectContext = self.managedObjectContext;
    }else if ([segue.identifier isEqualToString:@"LocalCats"]){
        LocalCatsTableViewController *catsController = (LocalCatsTableViewController *)segue.destinationViewController;
        catsController.managedObjectContext = self.managedObjectContext;
    }
}

@end
