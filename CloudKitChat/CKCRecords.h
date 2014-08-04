#import "CKCConversation.h"
#import "CKCMessage.h"
#import "CKCUser.h"

@class CKRecord;

/// Protocol defining how a CloudKitChat model should convert from/to a CloudKit record
@protocol CKCRecord <NSObject>

@required

/// Return a CloudKit record instance from this model
- (CKRecord *)cloudKitRecord;

@optional

/// Initialize the model with a CloudKit record
- (instancetype)initWithCloudKitRecord:(CKRecord *)cloudKitRecord;

@end

extern NSString * const CKCConversationUsersKey;

/// Category that makes CKCConversation conform to the CKCRecord protocol
@interface CKCConversation (CKCRecord) <CKCRecord>

- (instancetype)initWithCloudKitRecord:(CKRecord *)cloudKitRecord
                             localUser:(CKCUser *)localUser
                            remoteUser:(CKCUser *)remoteUser
                              messages:(NSArray *)messages;

@end

extern NSString * const CKCMessageConversationKey;

/// Category that makes CKCMessage conform to the CKCRecord protocol
@interface CKCMessage (CKCRecord) <CKCRecord>

@end

extern NSString * const CKCUserNameKey;
extern NSString * const CKCUserProfilePictureKey;

/// Category that makes CKCUser conform to the CKCRecord protocol
@interface CKCUser (CKCRecord) <CKCRecord>

@end