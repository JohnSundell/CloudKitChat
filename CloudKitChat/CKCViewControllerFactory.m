#import "CKCViewControllerFactory.h"
#import "BuildSettings.h"

#import "CKCConversationsListViewController.h"
#import "CKCConversationsListViewModel.h"

#import "CKCConversationViewController.h"
#import "CKCConversationViewModel.h"

#import "CKCUserSearchViewController.h"
#import "CKCUserSearchViewModel.h"

@interface CKCViewControllerFactory ()

@property (nonatomic, strong) CKCUser *localUser;
@property (nonatomic, strong) id<CKCModelLoader> modelLoader;

@end

@implementation CKCViewControllerFactory

- (instancetype)initWithLocalUser:(CKCUser *)localUser modelLoader:(id<CKCModelLoader>)modelLoader
{
    if (!(self = [super init])) {
        return nil;
    }
    
    _localUser = localUser;
    _modelLoader = modelLoader;
    
    return self;
}

- (UIViewController *)conversationsListViewController
{
    CKCConversationsListViewModel *viewModel = [[CKCConversationsListViewModel alloc] initWithLocalUser:self.localUser
                                                                                            modelLoader:self.modelLoader];
    
    return [[CKCConversationsListViewController alloc] initWithViewModel:viewModel viewControllerFactory:self];
}

- (UIViewController *)conversationViewControllerForConversation:(CKCConversation *)conversation
{
    CKCConversationViewModel *viewModel = [[CKCConversationViewModel alloc] initWithConversation:conversation modelLoader:self.modelLoader];
    
    return [[CKCConversationViewController alloc] initWithViewModel:viewModel];
}

- (UISearchController *)userSearchViewControllerWithDelegate:(id<CKCUserSearchViewControllerDelegate>)delegate
{
    CKCUserSearchViewModel *viewModel = [[CKCUserSearchViewModel alloc] initWithLocalUser:self.localUser
                                                                              modelLoader:self.modelLoader];
    
    CKCUserSearchViewController *resultsVC = [[CKCUserSearchViewController alloc] initWithViewModel:viewModel];
    resultsVC.delegate = delegate;
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:resultsVC];
    searchController.searchResultsUpdater = resultsVC;
    searchController.searchBar.placeholder = @"Find a user to talk to";
    
    return searchController;
}

@end
