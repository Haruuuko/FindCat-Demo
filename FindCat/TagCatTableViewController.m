//
//  AddCatTableViewController.m
//  FindCat
//
//  Created by 王晴 on 16/2/6.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import "TagCatTableViewController.h"
#import "SelectCatsViewController.h"
#import "Cat.h"
#import "WGS84TOGCJ02.h"
#import "NSManagedObject+ManagePhoto.h"
#import "ImagePickerModel.h"

@interface TagCatTableViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ImagePickerModelDelegate>

@property (weak, nonatomic) IBOutlet UILabel *catsLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITableViewCell *addressCell;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) CLPlacemark *address;
@property (strong, nonatomic) NSMutableArray *catsMember;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) ImagePickerModel *imagePicker;

@end

@implementation TagCatTableViewController

#pragma mark - init and setup

- (CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

- (NSMutableArray *)catsMember{
    if (!_catsMember) {
        _catsMember = [[NSMutableArray alloc]init];
    }
    return _catsMember;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:self.managedObjectContext];
    }
    return self;
}

- (void)setupLabels{
    if(self.tagDetail.taggedCats.count > 0) {
        NSMutableString *cats = [[NSMutableString alloc]init];
        for (Cat *cat in self.tagDetail.taggedCats) {
            [self.catsMember addObject:cat];
            [cats appendString:[NSString stringWithFormat:@"%@ ", cat.catName]];
        }
        self.catsLabel.text = cats;
    }
    
    if ([self.tagDetail hasPhotoAtIndex:self.tagDetail.photoID]) {
                        NSLog(@"TAG  %@",[self.tagDetail photoPathAtIndex:self.tagDetail.photoID]);
        UIImage *existingImage = [self.tagDetail photoImageAtIndex:self.tagDetail.photoID];
        if (existingImage != nil) {
            self.imageView.image = existingImage;
        }
    }
    
    if (self.tagDetail.placemark == nil) {
        [self getGeocoderAddress];
    }else{
        self.addressCell.textLabel.text = [NSString stringWithFormat:@"%@",self.tagDetail.placemark.name];
    }
    
    if (self.tagDetail.locationDescription != nil) {
        self.descriptionTextView.text = self.tagDetail.locationDescription;
    }
}

- (void)updateLabels{
    if (self.catsMember.count > 0) {
        NSMutableString *cats = [[NSMutableString alloc]init];
        for (Cat *cat in self.catsMember) {
            [cats appendString:[NSString stringWithFormat:@"%@ ", cat.catName]];
        }
        self.catsLabel.text = cats;
    }else{
        self.catsLabel.text = @"猫咪";
    }
    
    if (self.image != nil) {
        self.imageView.image = self.image;
    }
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLabels];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateLabels];
    [self.tableView reloadData];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.001;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        [self.descriptionTextView becomeFirstResponder];
    }else if (indexPath.section == 0 && indexPath.row == 0){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.imagePicker = [[ImagePickerModel alloc]init];
        self.imagePicker.delegete = self;
        [self.imagePicker showPhotoMenu];
    }
}

#pragma mark - ImagePickerModelDelegate

- (void)imagePickerDidFinishWithImage:(UIImage *)image{
    self.image = image;
}

#pragma mark - UITextViewDelegate

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    self.tagDetail.descriptionText = [textView.text stringByReplacingCharactersInRange:range withString:text];
//    return YES;
//}
//
//- (void)textViewDidEndEditing:(UITextView *)textView{
//    self.tagDetail.descriptionText = textView.text;
//}

#pragma mark - UITableViewDataSource

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
//    // Configure the cell...
//    
//    return cell;
//}

#pragma mark - event response

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ChooseCat"]) {
        SelectCatsViewController *controller = (SelectCatsViewController *)segue.destinationViewController;
        controller.managedObjectContext = self.managedObjectContext;
        controller.chosenCats = self.catsMember;
    }
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender {
    if (self.tagDetail == nil) {
        Location *location = [NSEntityDescription insertNewObjectForEntityForName:@"Location"
                                                           inManagedObjectContext:self.managedObjectContext];
        location.photoID = @-1;
        if (![WGS84TOGCJ02 isLocationOutOfChina:self.location.coordinate]) {
            CLLocationCoordinate2D coordinateInGCJ = [WGS84TOGCJ02 transformFromWGSToGCJ:self.location.coordinate];
            location.latitude = @(coordinateInGCJ.latitude);
            location.longitude = @(coordinateInGCJ.longitude);
        }else{
            location.latitude = @(self.location.coordinate.latitude);
            location.longitude = @(self.location.coordinate.longitude);
        }
        
        location.placemark = self.address;
        location.locationDescription = self.descriptionTextView.text;
        location.date = [NSDate date];
        location.taggedCats = [NSSet setWithArray:self.catsMember];
        [self savePhotoToLocation:location];
        
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }else{
        self.tagDetail.taggedCats = [NSSet setWithArray:self.catsMember];
        self.tagDetail.locationDescription = self.descriptionTextView.text;
        [self savePhotoToLocation:self.tagDetail];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getGeocoderAddress{
        [self.geocoder reverseGeocodeLocation:self.location
                            completionHandler:^(NSArray *placemarks, NSError *error){
                                if (error == nil && [placemarks count] > 0) {
//                                    self.tagDetail.placemark = [placemarks lastObject];
                                    self.address = [placemarks lastObject];
//                                    NSLog(@"%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n",self.address.country,self.address.administrativeArea,self.address.subAdministrativeArea,self.address.locality,self.address.subLocality,self.address.thoroughfare,self.address.subThoroughfare,self.address.name);
                                    self.addressCell.textLabel.text = [NSString stringWithFormat:@"%@",self.address.name];
                                }else{
                                    self.addressCell.textLabel.text = @"未能获取地址，请稍后重试";
                                }
                            }];
}

- (void)savePhotoToLocation:(Location *)location{
    if (self.image != nil) {
        if (![location hasPhotoAtIndex:location.photoID]) {
            location.photoID = @([Location nextPhotoId]);
        }

        NSData *data = UIImageJPEGRepresentation(self.image, 0.5);
        NSError *error;
        if (![data writeToFile:[location photoPathAtIndex:location.photoID] options:NSDataWritingAtomic error:&error]) {
            NSLog(@"Error writing file: %@", error);
        }
    }
}

- (void)applicationDidEnterBackground{
    if (self.imagePicker != nil) {
        [self dismissViewControllerAnimated:NO completion:nil];
        self.imagePicker = nil;
    }
    [self.descriptionTextView resignFirstResponder];
}

@end
