//
//  CDSearchViewController.m
//  customDemo
//
//  Created by shendeMac on 2017/12/20.
//  Copyright © 2017年 sandsyu. All rights reserved.
//

#import "CDSearchViewController.h"
#import "CDResultTableViewController.h"
@interface CDSearchViewController () <UISearchControllerDelegate,UISearchBarDelegate>
@property (nonatomic,strong) UISearchController *search;
@end

@implementation CDSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *searchBack = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height + 50, self.view.frame.size.width, 50)];
    searchBack.backgroundColor = [UIColor greenColor];
    [self.view addSubview:searchBack];
    [searchBack addSubview:self.search.searchBar];

}

- (UISearchController *)search {
    if (_search == nil) {
        CDResultTableViewController *result = [[CDResultTableViewController alloc] init];
        _search = [[UISearchController alloc] initWithSearchResultsController:result];
        _search.delegate = self;
        _search.searchBar.delegate = self;
        _search.searchResultsUpdater = result;
        
        // 设置search bar
        _search.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _search.searchBar.placeholder = @"what the fuck";
        _search.dimsBackgroundDuringPresentation = YES;
    }
    return _search;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
