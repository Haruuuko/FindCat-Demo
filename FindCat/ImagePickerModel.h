//
//  ImagePickerModel.h
//  FindCat
//
//  Created by 王晴 on 16/3/20.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ImagePickerModelDelegate

- (void)imagePickerDidFinishWithImage:(UIImage *)image;

@end

@interface ImagePickerModel : NSObject

@property (nonatomic, weak) id<ImagePickerModelDelegate> delegete;

- (void)showPhotoMenu;

@end
