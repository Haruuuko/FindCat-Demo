//
//  SelectTableViewCell.h
//  FindCat
//
//  Created by 王晴 on 16/3/5.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cat.h"

@interface SelectTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameOnlyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *chosenImageView;

- (void)chosenImageForCat:(Cat *)cat inCatsArray:(NSMutableArray *)cats;

@end
