#import <UIKit/UIKit.h>
#import "CKCViewModel.h"

@class CKCViewControllerFactory;

extern NSString * const CKCTableViewControllerCellIdentifier;

@interface CKCTableViewController : UITableViewController <CKCViewModelDelegate>

@property (nonatomic, strong, readonly) CKCViewControllerFactory *viewControllerFactory;

- (instancetype)initWithViewControllerFactory:(CKCViewControllerFactory *)viewControllerFactory;
- (Class)cellClass;
- (void)loadDataForViewModel:(id<CKCViewModel>)viewModel;

@end
