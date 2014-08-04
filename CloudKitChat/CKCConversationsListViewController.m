#import "CKCConversationsListViewController.h"
#import "CKCConversationsListViewModel.h"
#import "CKCViewControllerFactory.h"
#import "CKCConversation.h"

@interface CKCConversationsListViewController () <CKCUserSearchViewControllerDelegate>

@property (nonatomic, strong) CKCConversationsListViewModel *viewModel;

@end

@implementation CKCConversationsListViewController

- (instancetype)initWithViewModel:(CKCConversationsListViewModel *)viewModel viewControllerFactory:(CKCViewControllerFactory *)viewControllerFactory
{
    if (!(self = [super initWithViewControllerFactory:viewControllerFactory])) {
        return nil;
    }
    
    _viewModel = viewModel;
    _viewModel.delegate = self;
    
    self.title = @"Conversations";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewConversationButtonSelected)];
    
    return self;
}

- (void)addNewConversationButtonSelected
{
    UISearchController *userSearchVC = [self.viewControllerFactory userSearchViewControllerWithDelegate:self];
    [self presentViewController:userSearchVC animated:YES completion:nil];
}

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDataForViewModel:self.viewModel];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.numberOfConversations;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKCConversation *conversation = [self.viewModel conversationAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CKCTableViewControllerCellIdentifier];
    cell.imageView.image = conversation.userInterfaceImage;
    cell.textLabel.text = conversation.userInterfaceTitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKCConversation *conversation = [self.viewModel conversationAtIndex:indexPath.row];
    UIViewController *conversationVC = [self.viewControllerFactory conversationViewControllerForConversation:conversation];
    
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    
    __weak typeof(self) _self = self;
    
    [self.viewModel deleteConversationAtIndex:indexPath.row completionHandler:^(BOOL success) {
        if (success) {
            [_self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}

#pragma mark - CKCUserSearchViewControllerDelegate

- (void)userSearchViewController:(CKCUserSearchViewController *)viewController didSelectUser:(CKCUser *)user
{
    __weak typeof(self) _self = self;
    
    [self.viewModel addConversationWithUser:user completionHandler:^(CKCConversation *conversation) {
        UIViewController *conversationVC = [_self.viewControllerFactory conversationViewControllerForConversation:conversation];
        
        [_self.navigationController pushViewController:conversationVC animated:YES];
    }];
}

@end
