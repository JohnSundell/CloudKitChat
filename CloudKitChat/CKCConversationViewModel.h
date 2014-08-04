#import "CKCViewModel.h"

@class CKCConversation;
@class CKCMessage;
@class CKCUser;
@protocol CKCModelLoader;

@interface CKCConversationViewModel : NSObject <CKCViewModel>

@property (nonatomic, strong, readonly) CKCConversation *conversation;

- (instancetype)initWithConversation:(CKCConversation *)conversation modelLoader:(id<CKCModelLoader>)modelLoader;

/// Return the message for a certain index
- (CKCMessage *)messageAtIndex:(NSUInteger)index;

/// Return the sender for a message at a certain index
- (CKCUser *)senderForMessageAtIndex:(NSUInteger)index;

/// Return whether the sender for a message at an index is the local user
- (BOOL)senderIsLocalUserForMessageAtIndex:(NSUInteger)index;

/// Send a new message with a certain text
- (void)sendMessageWithText:(NSString *)text completionHandler:(void(^)(BOOL success))completionHandler;

@end
