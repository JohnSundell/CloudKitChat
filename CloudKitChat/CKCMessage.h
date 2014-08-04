#import "CKCModel.h"

/// Model class representing a message in a conversation
@interface CKCMessage : NSObject <CKCModel>

/// The message's text content
@property (nonatomic, copy, readonly) NSString *text;

/// The timestamp corresponding to when the message was sent
@property (nonatomic, copy, readonly) NSDate *timestamp;

/// The identifier of the user that sent the message
@property (nonatomic, readonly) id sentByUserIdentifier;

/// The identifier of the conversation that the message belongs to
@property (nonatomic, readonly) id conversationIdentifier;

/// Initialize a new instance of this class with the required data
- (instancetype)initWithIdentifier:(id)identifier
                              text:(NSString *)text
                         timestamp:(NSDate *)timestamp
              sentByUserIdentifier:(id)sentByUserIdentifier
            conversationIdentifier:(id)conversationIdentifier NS_DESIGNATED_INITIALIZER;

@end
