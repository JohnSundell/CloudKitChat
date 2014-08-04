#import "CKCRecords.h"
#import <CloudKit/CloudKit.h>

NSString * const CKCConversationUsersKey = @"users";

@implementation CKCConversation (CKCRecord)

- (CKRecord *)cloudKitRecord
{
    CKRecord *record = [[CKRecord alloc] initWithRecordType:[CKCConversation type]
                                                   recordID:self.identifier];
    
    CKReference *localUserReference = [[CKReference alloc] initWithRecordID:self.localUser.identifier action:CKReferenceActionDeleteSelf];
    CKReference *remoteUserReference = [[CKReference alloc] initWithRecordID:self.remoteUser.identifier action:CKReferenceActionDeleteSelf];
    
    [record setObject:@[localUserReference, remoteUserReference] forKey:CKCConversationUsersKey];
    
    return record;
}

@end

NSString * const CKCMessageConversationKey = @"conversation";
static NSString * const CKCMessageTextKey = @"text";
static NSString * const CKCMessageTimestampKey = @"timestamp";
static NSString * const CKCMessageSentByKey = @"sentBy";

@implementation CKCMessage (CKCRecord)

- (instancetype)initWithCloudKitRecord:(CKRecord *)cloudKitRecord
{
    NSString *text = [cloudKitRecord objectForKey:CKCMessageTextKey];
    NSDate *timestamp = [cloudKitRecord objectForKey:CKCMessageTimestampKey];
    
    CKReference *sentByReference = [cloudKitRecord objectForKey:CKCMessageSentByKey];
    CKRecordID *sentByUserIdentifier = sentByReference.recordID;
    
    CKReference *conversationReference = [cloudKitRecord objectForKey:CKCMessageConversationKey];
    CKRecordID *conversationIdentifier = conversationReference.recordID;
    
    return [self initWithIdentifier:cloudKitRecord.recordID
                               text:text
                          timestamp:timestamp
               sentByUserIdentifier:sentByUserIdentifier
             conversationIdentifier:conversationIdentifier];
}

- (CKRecord *)cloudKitRecord
{
    CKRecord *record = [[CKRecord alloc] initWithRecordType:[CKCMessage type]];
    [record setObject:self.text forKey:CKCMessageTextKey];
    [record setObject:self.timestamp forKey:CKCMessageTimestampKey];
    
    CKReference *sentByReference = [[CKReference alloc] initWithRecordID:self.sentByUserIdentifier action:CKReferenceActionDeleteSelf];
    [record setObject:sentByReference forKey:CKCMessageSentByKey];
    
    CKReference *conversationReference = [[CKReference alloc] initWithRecordID:self.conversationIdentifier action:CKReferenceActionDeleteSelf];
    [record setObject:conversationReference forKey:CKCMessageConversationKey];
    
    return record;
}

@end

NSString * const CKCUserNameKey = @"name";
NSString * const CKCUserProfilePictureKey = @"profilePicture";

@implementation CKCUser (CKCRecord)

- (instancetype)initWithCloudKitRecord:(CKRecord *)cloudKitRecord
{
    NSString *name = [cloudKitRecord objectForKey:CKCUserNameKey];
    
    return [self initWithIdentifier:cloudKitRecord.recordID name:name profilePicture:nil];
}

- (CKRecord *)cloudKitRecord
{
    CKRecord *record;
    
    if (self.identifier) {
        record = [[CKRecord alloc] initWithRecordType:[CKCUser type]
                                             recordID:self.identifier];
    } else {
        record = [[CKRecord alloc] initWithRecordType:[CKCUser type]];
    }
    
    [record setObject:self.name forKey:CKCUserNameKey];
    
    return record;
}

@end