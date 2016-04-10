//
//  CatDetailViewController.m
//  FindCat
//
//  Created by 王晴 on 16/2/17.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import "CatDetailViewController.h"
#import "NSManagedObject+ManagePhoto.h"
#import "Cat.h"

@interface CatDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *catName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CatDetailViewController

#pragma mark - init and setup

- (void)refreshData{
    self.title = self.catDetail.catName;
    self.catName.text = self.catDetail.catName;
    if ([self.catDetail hasPhotoAtIndex:self.catDetail.photoID]) {
        NSLog(@"TAG  %@",[self.catDetail photoPathAtIndex:self.catDetail.photoID]);
        UIImage *existingImage = [self.catDetail photoImageAtIndex:self.catDetail.photoID];
        if (existingImage != nil) {
            self.imageView.image = existingImage;
        }
    }
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.catDetail != nil) {
        [self refreshData];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshData];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.001;
    }
    return 30;
}

#pragma mark - event response

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
     UINavigationController *navigationController = segue.destinationViewController;
     AddCatTableViewController *controller = (AddCatTableViewController *)navigationController.topViewController;
     controller.editCat = self.catDetail;
}

@end
