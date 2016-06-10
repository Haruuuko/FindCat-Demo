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
#import "PickerViewModel.h"
#import "MultiPickerViewModel.h"

@interface AddCatTableViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ImagePickerModelDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UITextField *catName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *genderField;
@property (weak, nonatomic) IBOutlet UITextField *ageField;
@property (weak, nonatomic) IBOutlet UITextField *hairColorField;
@property (weak, nonatomic) IBOutlet UITextField *hairPatternField;
@property (weak, nonatomic) IBOutlet UITextField *disabilityField;
@property (weak, nonatomic) IBOutlet UITextField *appearAreaField;
@property (weak, nonatomic) IBOutlet UITextField *characterField;

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) ImagePickerModel *imagePicker;

@property (strong, nonatomic) NSArray *gender;
@property (strong, nonatomic) NSArray *age;
@property (strong, nonatomic) NSArray *hairPattern;
@property (strong, nonatomic) NSArray *hairColor;
@property (strong, nonatomic) PickerViewModel *genderPickerView;
@property (strong, nonatomic) PickerViewModel *agePickerView;
@property (strong, nonatomic) PickerViewModel *hairPatternPickerView;
@property (strong, nonatomic) MultiPickerViewModel *hairColorPickerView;

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
        self.genderField.text = self.editCat.gender;
        self.ageField.text = self.editCat.age;
        self.hairPatternField.text = self.editCat.hairPattern;
        self.hairColorField.text = self.editCat.hairColor;
        self.disabilityField.text = self.editCat.disability;
        self.appearAreaField.text = self.editCat.appearArea;
        self.characterField.text = self.editCat.characteristic;
        self.doneButton.enabled = YES;
        if ([self.editCat hasPhotoAtIndex:self.editCat.photoID]) {
            UIImage *existingImage = [self.editCat photoImageAtIndex:self.editCat.photoID];
            if (existingImage != nil) {
                self.imageView.image = existingImage;
                NSLog(@"imageNotNil");
            }
        }
    }else{
        [self.catName becomeFirstResponder];
    }
    self.gender = @[@"公",@"母"];
    self.genderPickerView = [[PickerViewModel alloc]init];
    [self.genderPickerView initPickerViewWithTextField:self.genderField dataArray:self.gender];
    
    self.age = @[@"1个月",@"3个月",@"6个月",@"1岁",@"3岁",@"5岁",@"8岁",@"10岁以上"];
    self.agePickerView = [[PickerViewModel alloc]init];
    [self.agePickerView initPickerViewWithTextField:self.ageField dataArray:self.age];
    
    self.hairPattern = @[@"全色",@"双色",@"狸花",@"玳瑁",@"三花",@"杂纹"];
    self.hairPatternPickerView = [[PickerViewModel alloc]init];
    [self.hairPatternPickerView initPickerViewWithTextField:self.hairPatternField dataArray:self.hairPattern];
    
    self.hairColor = @[@"黑色",@"灰色",@"黄色",@"红色",@"白色"];
    self.hairColorPickerView = [[MultiPickerViewModel alloc]init];
    [self.hairColorPickerView initMultiPickerViewWithTextField:self.hairColorField dataArray:self.hairColor];
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

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.genderField) {
        [self.genderPickerView showselectRowInPickerView];
    }else if (textField == self.ageField){
        [self.agePickerView showselectRowInPickerView];
    }
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
        cat.gender = self.genderField.text;
        cat.age = self.ageField.text;
        cat.hairPattern = self.hairPatternField.text;
        cat.hairColor = self.hairColorField.text;
        cat.disability = self.disabilityField.text;
        cat.appearArea = self.appearAreaField.text;
        cat.characteristic = self.characterField.text;
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
        self.editCat.gender = self.genderField.text;
        self.editCat.age = self.ageField.text;
        self.editCat.hairPattern = self.hairPatternField.text;
        self.editCat.hairColor = self.hairColorField.text;
        self.editCat.disability = self.disabilityField.text;
        self.editCat.appearArea = self.appearAreaField.text;
        self.editCat.characteristic = self.characterField.text;
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
