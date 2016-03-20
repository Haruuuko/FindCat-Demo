//
//  SelectTableViewCell.m
//  FindCat
//
//  Created by 王晴 on 16/3/5.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import "SelectTableViewCell.h"

@implementation SelectTableViewCell

- (void)chosenImageForCat:(Cat *)cat inCatsArray:(NSMutableArray *)cats{
    if ([cats containsObject:cat]) {
        self.chosenImageView.image = [UIImage imageNamed:@"chosen"];
    }else{
        self.chosenImageView.image = [UIImage imageNamed:@"unchosen"];
    }
}

@end
