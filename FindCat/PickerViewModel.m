//
//  PickerViewModel.m
//  FindCat
//
//  Created by 王晴 on 16/4/12.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import "PickerViewModel.h"

@interface PickerViewModel ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) UITextField *textField;
@property (nonatomic) NSInteger tag;

@end

@implementation PickerViewModel

- (void)initPickerViewWithTextField:(UITextField *)textField dataArray:(NSArray *)data{
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.dataSource = self;
    picker.delegate = self;
    textField.inputView = picker;
    textField.tintColor = [UIColor clearColor];
    self.pickerView = picker;
    self.dataArray = data;
    self.textField = textField;
    self.tag = -1;
}

- (void)showselectRowInPickerView{
    if (self.tag == -1) {
        [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
        return;
    }
    [self pickerView:self.pickerView didSelectRow:self.tag inComponent:0];
}

#pragma mark - UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArray.count;
}

#pragma mark - UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.dataArray[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.tag = row;
    self.textField.text = [NSString stringWithFormat:@"%@",self.dataArray[row]];
}

@end
