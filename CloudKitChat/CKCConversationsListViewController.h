#import "CKCTableViewController.h"

@class CKCConversationsListViewModel;

/// View controller prepresenting a Conversations List View
@interface CKCConversationsListViewController : CKCTableViewController

/// Initialize the view controller with a view model
- (instancetype)initWithViewModel:(CKCConversationsListViewModel *)viewModel
            viewControllerFactory:(CKCViewControllerFactory *)viewControllerFactory NS_DESIGNATED_INITIALIZER;

@end
