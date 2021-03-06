//
//  MyCatsTableViewCell.m
//  FindCat
//
//  Created by 王晴 on 16/4/9.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import "MyCatsTableViewCell.h"
#import "NSManagedObject+ManagePhoto.h"
#import "UIImage+Resize.h"

@interface MyCatsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImage;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@end

@implementation MyCatsTableViewCell

-(void)setCat:(Cat *)cat{
    _cat = cat;
    self.nameLabel.text = cat.catName;
    if ([cat hasPhotoAtIndex:cat.photoID]) {
        self.iconImage.image = [[cat photoImageAtIndex:cat.photoID]resizedImageWithBounds:CGSizeMake(44, 44)];
    }else{
        self.iconImage.image = [UIImage imageNamed:@"catImage"];
    }
    if ([cat.gender isEqualToString:@"母"]) {
        self.genderImage.image = [UIImage imageNamed:@"female"];
    }else{
        self.genderImage.image = [UIImage imageNamed:@"male"];
    }
    self.ageLabel.text = cat.age;
}

+(instancetype)initCellWithTableView:(UITableView *)tableView{
    static NSString *cellIdentifier = @"CatList";
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"MyCatsTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        nibsRegistered = YES;
    }
    
    MyCatsTableViewCell *cell = (MyCatsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyCatsTableViewCell" owner:nil options:nil]firstObject];
    }
    tableView.rowHeight = cell.frame.size.height;
    return cell;
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
