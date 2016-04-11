//
//  LocationTagCell.m
//  FindCat
//
//  Created by 王晴 on 16/4/10.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import "CalloutCell.h"
#import "NSManagedObject+ManagePhoto.h"
#import "UIImage+Resize.h"
#import "NSDate+FormatDate.h"
#import "Cat.h"

@interface CalloutCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *catsLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@end

@implementation CalloutCell

-(void)setLocation:(Location *)location{
    _location = location;
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 6.0;
    self.dateLabel.text = [self.location.date stringWithFormatDate];
    self.placeLabel.text = [NSString stringWithFormat:@"%@",self.location.placemark.name];
    
    if(self.location.taggedCats.count > 0) {
        NSMutableString *cats = [[NSMutableString alloc]init];
        for (Cat *cat in self.location.taggedCats) {
            [cats appendString:[NSString stringWithFormat:@"%@ ", cat.catName]];
        }
        self.catsLabel.text = cats;
    }
    if ([location hasPhotoAtIndex:location.photoID]) {
        self.iconImage.image = [[location photoImageAtIndex:location.photoID]resizedImageWithBounds:CGSizeMake(80, 80)];
    }else{
        self.iconImage.image = [UIImage imageNamed:@"catImage"];
    }

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
