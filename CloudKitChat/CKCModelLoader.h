#import <Foundation/Foundation.h>
#import "CKCImage.h"

@class CKCUser;
@class CKCConversation;
@class CKCMessage;

/// Protocol that all model loaders of CloudKitChat must conform to
@protocol CKCModelLoader <NSObject>

/// Setup the loader for use
- (void)setupWithCompletionHandler:(void(^)(BOOL success))completionHandler;

/// Load the local user
- (void)loadLocalUserWithCompletionHandler:(void(^)(CKCUser *localUser))completionHandler;

/// Save the local user
- (void)saveLocalUserWithName:(NSString *)name
               profilePicture:(CKCImage *)profilePicture
            completionHandler:(void(^)(CKCUser *localUser))completionHandler;

/// Load all conversations for the local user
- (void)loadConversationsForLocalUser:(CKCUser *)localUser completionHandler:(void(^)(NSArray *conversations))completionHandler;

/// Save a conversation
- (void)saveConversation:(CKCConversation *)conversation completionHandler:(void(^)(CKCConversation *savedConversation))completionHandler;

/// Load all messages for a certain conversation
- (void)loadMessagesForConversation:(CKCConversation *)conversation completionHandler:(void(^)(NSArray *messages))completionHandler;

/// Save a message
- (void)saveMessage:(CKCMessage *)message completionHandler:(void(^)(BOOL success))completionHandler;

/// Load all users matching a search string
- (void)loadUsersMatchingSearchString:(NSString *)searchString completionHandler:(void(^)(NSArray *users))completionHandler;

@end