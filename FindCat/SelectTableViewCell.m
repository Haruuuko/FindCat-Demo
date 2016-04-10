//
//  SelectTableViewCell.m
//  FindCat
//
//  Created by 王晴 on 16/4/9.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import "SelectTableViewCell.h"
#import "NSManagedObject+ManagePhoto.h"
#import "UIImage+Resize.h"

@interface SelectTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIImageView *chosenImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImage;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation SelectTableViewCell

-(void)setCat:(Cat *)cat{
    _cat = cat;
    self.nameLabel.text = cat.catName;
    if ([cat hasPhotoAtIndex:cat.photoID]) {
        self.iconImage.image = [[cat photoImageAtIndex:cat.photoID]resizedImageWithBounds:CGSizeMake(44, 44)];
    }else{
        self.iconImage.image = [UIImage imageNamed:@"catImage"];
    }
}

+(instancetype)initCellWithTableView:(UITableView *)tableView{
    static NSString *cellIdentifier = @"SelectCatList";
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"SelectTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        nibsRegistered = YES;
    }
    
    SelectTableViewCell *cell = (SelectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SelectTableViewCell" owner:nil options:nil]firstObject];
    }
    tableView.rowHeight = cell.frame.size.height;
    return cell;
}

- (void)chosenImageForCat:(Cat *)cat inCatsArray:(NSMutableArray *)cats{
    if ([cats containsObject:cat]) {
        self.chosenImage.image = [UIImage imageNamed:@"chosen"];
    }else{
        self.chosenImage.image = [UIImage imageNamed:@"unchosen"];
    }
}

//- (void)awakeFromNib {
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
