#import "CKCTableViewController.h"

@class CKCConversationViewModel;

@interface CKCConversationViewController : CKCTableViewController

- (instancetype)initWithViewModel:(CKCConversationViewModel *)viewModel NS_DESIGNATED_INITIALIZER;

@end
