//
//  MyCatsTableViewCell.h
//  FindCat
//
//  Created by 王晴 on 16/4/9.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cat.h"

@interface MyCatsTableViewCell : UITableViewCell

@property (strong, nonatomic) Cat *cat;

+(instancetype)initCellWithTableView:(UITableView *)tableView;

@end
