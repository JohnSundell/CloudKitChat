#import "CKCTableViewController.h"

NSString * const CKCTableViewControllerCellIdentifier = @"cell";

@implementation CKCTableViewController

- (instancetype)initWithViewControllerFactory:(CKCViewControllerFactory *)viewControllerFactory
{
    if (!(self = [super init])) {
        return nil;
    }
    
    _viewControllerFactory = viewControllerFactory;
    
    return self;
}

- (Class)cellClass
{
    return [UITableViewCell class];
}

- (void)loadDataForViewModel:(id<CKCViewModel>)viewModel
{
    [viewModel loadData];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[self cellClass]
           forCellReuseIdentifier:CKCTableViewControllerCellIdentifier];
}

#pragma mark - CKCViewModelDelegate

- (void)viewModelDidLoad:(id<CKCViewModel>)viewModel
{
    [self.tableView reloadData];
}

@end
