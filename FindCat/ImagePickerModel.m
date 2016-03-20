//
//  ImagePickerModel.m
//  FindCat
//
//  Created by 王晴 on 16/3/20.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import "ImagePickerModel.h"

@interface ImagePickerModel()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIAlertController *actionSheet;

@end

@implementation ImagePickerModel

#pragma mark - ImagePickerModelDelegate

- (void)showPhotoMenu {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [self.actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self.actionSheet addAction:[UIAlertAction actionWithTitle:@"拍照"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action){
                                                               [self takePhotoWithCamera];
                                                           }]];
        [self.actionSheet addAction:[UIAlertAction actionWithTitle:@"从相册中选择"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action){
                                                               [self choosePhotoFromLibrary];
                                                           }]];
        [(UIViewController *)self.delegete presentViewController:self.actionSheet animated:YES completion:nil];
    } else {
        [self choosePhotoFromLibrary];
    }
}

- (void)takePhotoWithCamera {
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    [(UIViewController *)self.delegete presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)choosePhotoFromLibrary {
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    [(UIViewController *)self.delegete presentViewController:self.imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [self.delegete imagePickerDidFinishWithImage:image];
    [(UIViewController *)self.delegete dismissViewControllerAnimated:YES completion:nil];
    self.imagePicker = nil;
}

- (void)imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
    [(UIViewController *)self.delegete dismissViewControllerAnimated:YES completion:nil];
    self.imagePicker = nil;
}

@end
