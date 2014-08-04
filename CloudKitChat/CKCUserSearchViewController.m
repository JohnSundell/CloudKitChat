#import "CKCUserSearchViewController.h"
#import "CKCUserSearchViewModel.h"
#import "CKCUser.h"

@interface CKCUserSearchViewController ()

@property (nonatomic, strong) CKCUserSearchViewModel *viewModel;

@end

@implementation CKCUserSearchViewController

- (instancetype)initWithViewModel:(CKCUserSearchViewModel *)viewModel
{
    if (!(self = [super init])) {
        return nil;
    }
    
    _viewModel = viewModel;
    _viewModel.delegate = self;
    
    return self;
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.viewModel updateForSearchString:searchController.searchBar.text];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.numberOfResults;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKCUser *user = [self.viewModel userAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CKCTableViewControllerCellIdentifier];
    cell.imageView.image = user.profilePicture;
    cell.textLabel.text = user.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKCUser *user = [self.viewModel userAtIndex:indexPath.row];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate userSearchViewController:self didSelectUser:user];
}

@end
