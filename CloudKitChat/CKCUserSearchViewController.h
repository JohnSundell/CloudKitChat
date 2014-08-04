#import "CKCTableViewController.h"

@class CKCUserSearchViewController;
@class CKCUser;
@class CKCUserSearchViewModel;

@protocol CKCUserSearchViewControllerDelegate <NSObject>

- (void)userSearchViewController:(CKCUserSearchViewController *)viewController
                   didSelectUser:(CKCUser *)user;

@end

@protocol CKCUserSearchViewModel;

@interface CKCUserSearchViewController : CKCTableViewController <UISearchResultsUpdating>

@property (nonatomic, weak) id<CKCUserSearchViewControllerDelegate> delegate;

- (instancetype)initWithViewModel:(CKCUserSearchViewModel *)viewModel NS_DESIGNATED_INITIALIZER;

@end
