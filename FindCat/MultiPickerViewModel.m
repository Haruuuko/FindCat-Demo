//
//  MultiPickerViewModel.m
//  FindCat
//
//  Created by 王晴 on 16/4/13.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import "MultiPickerViewModel.h"

@interface MultiPickerViewModel ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) NSMutableArray *selectedArray;

@end

@implementation MultiPickerViewModel

- (void)initMultiPickerViewWithTextField:(UITextField *)textField dataArray:(NSArray *)data{
    UITableView *picker = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 216) style:UITableViewStylePlain];
    picker.separatorStyle = UITableViewCellSeparatorStyleNone;
    picker.showsVerticalScrollIndicator = NO;
    picker.scrollsToTop = NO;
    picker.dataSource = self;
    picker.delegate = self;
    textField.inputView = picker;
    textField.tintColor = [UIColor clearColor];
    if (![textField.text isEqual: @""]) {
        self.selectedArray = [NSMutableArray arrayWithArray:[textField.text componentsSeparatedByString:@","]];
    }else{
        self.selectedArray = [[NSMutableArray alloc]init];
    }
    self.multiPickerView = picker;
    self.dataArray = data;
    self.textField = textField;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Add 4 additional rows for whitespace on top and bottom
    return self.dataArray.count + 3;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MultiPickerCell";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row < 2 || indexPath.row >= (self.dataArray.count + 2)) {
        // Whitespace cell
        cell.textLabel.text = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.imageView.image = nil;
    }else {
        NSInteger actualRow = indexPath.row - 2;
        cell.textLabel.text = self.dataArray[actualRow];
        cell.imageView.image = [UIImage imageNamed:self.dataArray[actualRow]];
        if ([self.selectedArray containsObject:self.dataArray[actualRow]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 1 && indexPath.row < (self.dataArray.count + 2)) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        // Inform delegate
        NSInteger actualRow = indexPath.row - 2;
        if ([self.selectedArray containsObject:self.dataArray[actualRow]]) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self.selectedArray removeObject:self.dataArray[actualRow]];
        }else{
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.selectedArray addObject:self.dataArray[actualRow]];
        }
        NSString *string = [[NSMutableString alloc]init];
        string = [self.selectedArray componentsJoinedByString:@","];
        self.textField.text = string;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UITableView *)tableView {
    int co = ((int)tableView.contentOffset.y % (int)tableView.rowHeight);
    if (co < tableView.rowHeight / 2)
        [tableView setContentOffset:CGPointMake(0, tableView.contentOffset.y - co) animated:YES];
    else
        [tableView setContentOffset:CGPointMake(0, tableView.contentOffset.y + (tableView.rowHeight - co)) animated:YES];
}

- (void)scrollViewDidEndDragging:(UITableView *)scrollView willDecelerate:(BOOL)decelerate {
    if(decelerate)
        return;
    [self scrollViewDidEndDecelerating:scrollView];
}

@end
