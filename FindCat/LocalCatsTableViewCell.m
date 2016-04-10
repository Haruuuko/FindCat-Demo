//
//  LocalCatsTableViewCell.m
//  FindCat
//
//  Created by 王晴 on 16/4/10.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import "LocalCatsTableViewCell.h"
#import "NSManagedObject+ManagePhoto.h"
#import "UIImage+Resize.h"

@interface LocalCatsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImage;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@end

@implementation LocalCatsTableViewCell

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
    static NSString *cellIdentifier = @"LocalCatList";
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"LocalCatsTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        nibsRegistered = YES;
    }
    
    LocalCatsTableViewCell *cell = (LocalCatsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"LocalCatsTableViewCell" owner:nil options:nil]firstObject];
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
