#import <Foundation/Foundation.h>
#import "CKCImage.h"

@class CKCUser;
@class CKCConversation;
@class CKCMessage;

@protocol CKCModelLoader <NSObject>

- (void)setupWithCompletionHandler:(void(^)(BOOL success))completionHandler;

- (void)loadLocalUserWithCompletionHandler:(void(^)(CKCUser *localUser))completionHandler;

- (void)saveLocalUserWithName:(NSString *)name
               profilePicture:(CKCImage *)profilePicture
            completionHandler:(void(^)(CKCUser *localUser))completionHandler;

- (void)loadConversationsForLocalUser:(CKCUser *)localUser completionHandler:(void(^)(NSArray *conversations))completionHandler;

- (void)loadMessagesForConversation:(CKCConversation *)conversation completionHandler:(void(^)(NSArray *messages))completionHandler;

- (void)saveMessage:(CKCMessage *)message completionHandler:(void(^)(BOOL success))completionHandler;

- (void)loadUsersMatchingSearchString:(NSString *)searchString completionHandler:(void(^)(NSArray *users))completionHandler;

@end