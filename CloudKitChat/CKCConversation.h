#import "CKCModel.h"
#import "CKCImage.h"

@class CKCUser;
@class CKCMessage;

/// Model class representing a chat conversation
@interface CKCConversation : NSObject <CKCModel>

/// Reference to the local user currently using the app
@property (nonatomic, strong, readonly) CKCUser *localUser;

/// The user with whom the local user is having the conversation with
@property (nonatomic, strong, readonly) CKCUser *remoteUser;

/// The conversation's messages. Stored in historical order, ascending. Contains CKCMessage instances.
@property (nonatomic, strong, readonly) NSArray *messages;

/// The timestamp of the last activity in the conversation
@property (nonatomic, strong, readonly) NSDate *lastActivityTimestamp;

/// Create a new instance of this class with the required properties
- (instancetype)initWithIdentifier:(id)identifier
                         localUser:(CKCUser *)localUser
                        remoteUser:(CKCUser *)remoteUser
                          messages:(NSArray *)messages NS_DESIGNATED_INITIALIZER;

/// Add a message to the conversation
- (void)addMessage:(CKCMessage *)message;

@end

/// Category defining how a CKCConversation should be represented in the User Interface
@interface CKCConversation (UserInterfaceRepresentation)

/// The image of the conversation when presented in the user interface
@property (nonatomic, strong, readonly) CKCImage *userInterfaceImage;

/// The title of the conversation when presented in the user interface
@property (nonatomic, strong, readonly) NSString *userInterfaceTitle;

@end