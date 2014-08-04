#import <UIKit/UIKit.h>
#import "CKCUserSearchViewController.h"

@class CKCConversation;
@protocol CKCModelLoader;

/// Factory object that creates CloudKitChat view controllers
@interface CKCViewControllerFactory : NSObject

/// Create a new instance of this class with the required data
- (instancetype)initWithLocalUser:(CKCUser *)localUser modelLoader:(id<CKCModelLoader>)modelLoader;

/// Return a view controller representing a Conversations List View
- (UIViewController *)conversationsListViewController;

/// Return a view controller representing a Conversation View for a conversation
- (UIViewController *)conversationViewControllerForConversation:(CKCConversation *)conversation;

/// Return a view controller representing a User Search View
- (UISearchController *)userSearchViewControllerWithDelegate:(id<CKCUserSearchViewControllerDelegate>)delegate;

@end
