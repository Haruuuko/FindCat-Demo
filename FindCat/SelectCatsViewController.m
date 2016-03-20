//
//  SelectCatsViewController.m
//  FindCat
//
//  Created by 王晴 on 16/2/15.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import "SelectCatsViewController.h"
#import "Cat.h"
#import "SelectTableViewCell.h"
#import "UIImage+Resize.h"
#import "NSManagedObject+ManagePhoto.h"
#import "NSManagedObjectContext+FetchRequest.h"

@interface SelectCatsViewController ()<UISearchBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate,NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *searchCats;
@property (strong, nonatomic) NSArray *catsInAll;

@end

@implementation SelectCatsViewController

#pragma mark - init and setup

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Cat" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"initial" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"catName" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor1,sortDescriptor2]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"initial" cacheName:@"CatsLoad"];
    aFetchedResultsController.delegate = self;
    _fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    _catsInAll = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (![_fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _fetchedResultsController;
}

#pragma  mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [self.searchController.view removeFromSuperview]; // It works!
    _fetchedResultsController.delegate = nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    if (self.searchController.active) {
        return 1;
    }
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    if (self.searchController.active) {
        return self.searchCats.count;
    }
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SelectCatList";
    SelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                            forIndexPath:indexPath];
    if (!cell) {
        cell = [[SelectTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:cellIdentifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (self.searchController.active) {
        return nil;
    }
    NSMutableArray *indexs = [[NSMutableArray alloc]init];
    for (id <NSFetchedResultsSectionInfo> sectionInfo in [self.fetchedResultsController sections]) {
        [indexs addObject:sectionInfo.name];
    }
    return indexs;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.searchController.active) {
        return nil;
    }
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo name];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.searchController.active) {
        return 0;
    }
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    Cat *cat = nil;
    if (self.searchController.active) {
        cat = self.searchCats[indexPath.row];
    }else{
        cat = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    if ([self.chosenCats containsObject:cat]) {
        [self.chosenCats removeObject:cat];
    }else{
        [self.chosenCats addObject:cat];
    }
    [cell chosenImageForCat:cat inCatsArray:self.chosenCats];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchText = searchController.searchBar.text;
    self.catsInAll = [self.managedObjectContext fetchRequestEntityForName:@"Cat"];
    [self searchDataWithKeyWord:searchText];
    [self.tableView reloadData];
}

#pragma mark - private methods

- (void)searchDataWithKeyWord:(NSString *)keyWord{
    self.searchCats = [NSMutableArray array];
    for (Cat *cat in self.catsInAll) {
        if ([cat.catName containsString:keyWord] || [cat.catNickname containsString:keyWord]) {
            [self.searchCats addObject:cat];
        }
    }
}

- (void)configureCell:(SelectTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Cat *cat = nil;
    // Configure the cell...
    if (self.searchController.active) {
        cat = self.searchCats[indexPath.row];
    }else{
        cat = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    if ([cat.catNickname isEqualToString:@""]) {
        cell.nameOnlyLabel.text = cat.catName;
        cell.nameOnlyLabel.font = [UIFont systemFontOfSize:18];
        cell.nameLabel.text = nil;
    }else{
        cell.nameLabel.text = cat.catName;
        cell.nameLabel.font = [UIFont systemFontOfSize:18];
        cell.nameOnlyLabel.text = nil;
    }
    cell.nicknameLabel.text = cat.catNickname;
    cell.nicknameLabel.textColor = [UIColor grayColor];
    cell.nicknameLabel.font = [UIFont systemFontOfSize:14];
    if ([cat hasPhotoAtIndex:cat.photoID]) {
        cell.iconImageView.image = [[cat photoImageAtIndex:cat.photoID]resizedImageWithBounds:CGSizeMake(44, 44)];
    }else{
        cell.iconImageView.image = [UIImage imageNamed:@"catImage"];
    }
    [cell chosenImageForCat:cat inCatsArray:self.chosenCats];
}

@end
