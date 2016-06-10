//
//  PickerViewModel.h
//  FindCat
//
//  Created by 王晴 on 16/4/12.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PickerViewModel : NSObject

@property (strong, nonatomic) UIPickerView *pickerView;

- (void)initPickerViewWithTextField:(UITextField *)textField dataArray:(NSArray *)data;
- (void)showselectRowInPickerView;

@end
