//
//  AddCatTableViewController.m
//  FindCat
//
//  Created by 王晴 on 16/2/16.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import "AddCatTableViewController.h"
#import "Cat.h"
#import "Cat+CoreDataProperties.h"
#import "NSString+PinYin.h"
#import "NSManagedObject+ManagePhoto.h"
#import "ImagePickerModel.h"

@interface AddCatTableViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ImagePickerModelDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UITextField *catName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) ImagePickerModel *imagePicker;

@end

@implementation AddCatTableViewController

#pragma mark - life cycle

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:self.managedObjectContext];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.editCat != nil) {
        self.title = @"Edit Cat";
        self.catName.text = self.editCat.catName;
        self.doneButton.enabled = YES;
        if ([self.editCat hasPhotoAtIndex:self.editCat.photoID]) {
            UIImage *existingImage = [self.editCat photoImageAtIndex:self.editCat.photoID];
            if (existingImage != nil) {
                self.imageView.image = existingImage;
            }
        }
    }else{
        [self.catName becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
    }else if (indexPath.section == 0 && indexPath.row == 1){
        [self.catName becomeFirstResponder];
    }else if (indexPath.section == 2){
        [self.catName resignFirstResponder];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.imagePicker = [[ImagePickerModel alloc]init];
        self.imagePicker.delegete = self;
        [self.imagePicker showPhotoMenu];
    }
}

#pragma mark - ImagePickerModelDelegate

- (void)imagePickerDidFinishWithImage:(UIImage *)image{
    self.image = image;
    self.imageView.image = self.image;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    self.doneButton.enabled = (![self.catName.text isEqualToString: @""]);
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

#pragma mark - event response

- (IBAction)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done {
    if (self.editCat == nil) {  
        Cat *cat = [NSEntityDescription insertNewObjectForEntityForName:@"Cat" inManagedObjectContext:self.managedObjectContext];
        cat.catName = self.catName.text;
        cat.initial = [self.catName.text getFirstLetter];
        cat.photoID = @-1;
        [self savePhotoToLocation:cat];
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        self.editCat.catName = self.catName.text;
        self.editCat.initial = [self.catName.text getFirstLetter];
        [self savePhotoToLocation:self.editCat];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)savePhotoToLocation:(Cat *)cat{
    if (self.image != nil) {
        // 1
        if (![cat hasPhotoAtIndex:cat.photoID]) {
            cat.photoID = @([Cat nextPhotoId]);
        }
        // 2
        NSData *data = UIImageJPEGRepresentation(self.image, 0.5);
        NSError *error;
        if (![data writeToFile:[cat photoPathAtIndex:cat.photoID] options:NSDataWritingAtomic error:&error]) {
            NSLog(@"Error writing file: %@", error);
        }
    }
}

- (void)applicationDidEnterBackground{
    if (self.imagePicker != nil) {
        [self dismissViewControllerAnimated:NO completion:nil];
        self.imagePicker = nil;
    }
    [self.catName resignFirstResponder];
}

@end
