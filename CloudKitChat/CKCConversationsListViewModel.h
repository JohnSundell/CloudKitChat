#import "CKCViewModel.h"

@class CKCUser;
@class CKCConversation;
@protocol CKCModelLoader;

/// View model for the Conversations List view
@interface CKCConversationsListViewModel : NSObject <CKCViewModel>

/// The total number of conversations
@property (nonatomic, readonly) NSUInteger numberOfConversations;

/// Create a new instance of this class with the required data
- (instancetype)initWithLocalUser:(CKCUser *)localUser modelLoader:(id<CKCModelLoader>)modelLoader;

/// Return the conversation at a certain index
- (CKCConversation *)conversationAtIndex:(NSUInteger)index;

/// Add a conversation with a user
- (void)addConversationWithUser:(CKCUser *)user completionHandler:(void(^)(CKCConversation *conversation))completionHandler;

/// Delete the conversation at a certain index
- (void)deleteConversationAtIndex:(NSUInteger)index completionHandler:(void(^)(BOOL success))completionHandler;

@end
