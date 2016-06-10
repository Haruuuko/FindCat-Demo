//
//  MultiPickerViewModel.h
//  FindCat
//
//  Created by 王晴 on 16/4/13.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MultiPickerViewModel : NSObject

@property (strong, nonatomic) UITableView *multiPickerView;

- (void)initMultiPickerViewWithTextField:(UITextField *)textField dataArray:(NSArray *)data;

@end
