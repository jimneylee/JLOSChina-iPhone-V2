//
//  OSCSearchDisplayController.h
//  JLOSChina
//
//  Created by Lee jimney on 6/2/14.
//  Copyright (c) 2014 jimneylee. All rights reserved.
//

#import "OSCSearchDisplayController.h"

#define SEARCH_ACTIVE_BG_COLOR RGBCOLOR(201, 201, 206)

@interface OSCSearchDisplayController()
<UISearchDisplayDelegate, UISearchBarDelegate,
UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIViewController *searchContentsController;
@property (nonatomic, copy) NSString *searchText;

@end

@implementation OSCSearchDisplayController

- (instancetype)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar
                                                                     contentsController:viewController];
        _searchDisplayController.delegate = self;
        _searchDisplayController.searchResultsDataSource = self;
        _searchDisplayController.searchResultsDelegate = self;
        _searchDisplayController.searchResultsTableView.rowHeight = 44.f;
        _searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _searchDisplayController.searchBar.delegate = self;

        // fix bug:http://stackoverflow.com/questions/19140020/ios7-uisearchbar-statusbar-color
        //viewController.navigationController.view.backgroundColor = SEARCH_ACTIVE_BG_COLOR;
    }
    return self;
}

- (UISearchBar *)searchBar
{
   return self.searchDisplayController.searchBar;
}

- (UIViewController *)searchContentsController
{
    return self.searchDisplayController.searchContentsController;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITableViewDataSource
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;//[self.searchViewModel numberOfSections];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return 0;//[self.searchViewModel titleForHeaderInSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 0;//[self.searchViewModel numberOfItemsInSection:sectionIndex];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[UITableViewCell alloc] init];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITableViewDataDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self.searchDisplayController setActive:NO animated:YES];

    if (self.delegate && [self.delegate respondsToSelector:@selector(searchWithKeywords:selectedScopeButtonIndex:)]) {
        [self.delegate searchWithKeywords:self.searchText//searchBar.text
                 selectedScopeButtonIndex:self.searchBar.selectedScopeButtonIndex];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //[self.searchViewModel searchWithkeywords:searchBar.text];
    //[self.searchDisplayController.searchResultsTableView reloadData];
    self.searchText = searchText;
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    
}

@end
