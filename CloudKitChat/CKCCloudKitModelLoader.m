#import "CKCCloudKitModelLoader.h"

#import <CloudKit/CloudKit.h>

#import "CKCRecords.h"

static NSString * const CKCLocalUserRecordIDKey = @"localUserRecordID";

@interface CKCCloudKitModelLoader ()

@property (nonatomic, strong) CKDatabase *publicDatabase;
@property (nonatomic, strong) CKDatabase *privateDatabase;

@end

@implementation CKCCloudKitModelLoader

- (instancetype)init
{
    if (!(self = [super init])) {
        return nil;
    }
    
    CKContainer *container = [CKContainer defaultContainer];
    
    _publicDatabase = [container publicCloudDatabase];
    _privateDatabase = [container privateCloudDatabase];
    
    return self;
}

#pragma mark - CKCModelLoader

- (void)setupWithCompletionHandler:(void (^)(BOOL))completionHandler
{
    // Check if iCloud is available for this user
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError *error) {
        if (error) {
            // Smart error handling
            completionHandler(NO);
            return;
        }
        
        switch (accountStatus) {
            case CKAccountStatusCouldNotDetermine:
            case CKAccountStatusNoAccount:
            case CKAccountStatusRestricted:
                // Smart error handling
                completionHandler(NO);
                break;
            case CKAccountStatusAvailable:
                completionHandler(YES);
                break;
        }
    }];
}

- (void)loadLocalUserWithCompletionHandler:(void (^)(CKCUser *))completionHandler
{
    NSData *localUserRecordData = [[NSUserDefaults standardUserDefaults] objectForKey:CKCLocalUserRecordIDKey];
    
    if (!localUserRecordData) {
        completionHandler(nil);
        return;
    }
    
    CKRecordID *localUserRecordID = [NSKeyedUnarchiver unarchiveObjectWithData:localUserRecordData];
    
    [self.publicDatabase fetchRecordWithID:localUserRecordID completionHandler:^(CKRecord *record, NSError *error) {
        if (error) {
            // Smart error handling
            completionHandler(nil);
            return;
        }
        
        CKCUser *localUser = [[CKCUser alloc] initWithCloudKitRecord:record];
        completionHandler(localUser);
    }];
}

- (void)saveLocalUserWithName:(NSString *)name profilePicture:(UIImage *)profilePicture completionHandler:(void (^)(CKCUser *))completionHandler
{
    CKCUser *user = [[CKCUser alloc] initWithIdentifier:nil name:name profilePicture:profilePicture];
    CKRecord *record = [user cloudKitRecord];
    
    [self.publicDatabase saveRecord:record completionHandler:^(CKRecord *record, NSError *error) {
        if (error) {
            // Smart error handling
            completionHandler(nil);
            return;
        }
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:record.recordID] forKey:CKCLocalUserRecordIDKey];
        [defaults synchronize];
        
        CKCUser *createdUser = [[CKCUser alloc] initWithCloudKitRecord:record];
        completionHandler(createdUser);
    }];
}

- (void)loadConversationsForLocalUser:(CKCUser *)localUser completionHandler:(void (^)(NSArray *))completionHandler
{
    NSString *predicateFormat = [CKCConversationUsersKey stringByAppendingString:@" CONTAINS %@"];
    CKReference *localUserReference = [[CKReference alloc] initWithRecordID:localUser.identifier action:CKReferenceActionDeleteSelf];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, localUserReference];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:[CKCConversation type] predicate:predicate];
    
    __weak typeof(self) _self = self;
    
    [self.publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        NSMutableArray *remoteUserRecordIDs = [NSMutableArray new];
        
        // Gather all remote user record IDs from reference to be able to perform lookup
        for (CKRecord *record in results) {
            for (CKReference *reference in [record objectForKey:CKCConversationUsersKey]) {
                if (![reference.recordID isEqual:localUser.identifier]) {
                    [remoteUserRecordIDs addObject:reference.recordID];
                }
            }
        }
        
        CKFetchRecordsOperation *operation = [[CKFetchRecordsOperation alloc] initWithRecordIDs:remoteUserRecordIDs];
        operation.fetchRecordsCompletionBlock = ^(NSDictionary *recordsByRecordID, NSError *error) {
            NSMutableArray *conversations = [NSMutableArray new];
            
            for (CKRecordID *recordID in recordsByRecordID.allKeys) {
                NSUInteger resultsIndex = [remoteUserRecordIDs indexOfObject:recordID];
                CKRecord *conversationRecord = [results objectAtIndex:resultsIndex];
                CKRecord *remoteUserRecord = [recordsByRecordID objectForKey:recordID];
                CKCUser *remoteUser = [[CKCUser alloc] initWithCloudKitRecord:remoteUserRecord];
                CKCConversation *conversation = [[CKCConversation alloc] initWithIdentifier:conversationRecord.recordID
                                                                                  localUser:localUser
                                                                                 remoteUser:remoteUser
                                                                                   messages:nil];
                
                [conversations addObject:conversation];
            }
            
            completionHandler(conversations);
        };
        
        [_self.publicDatabase addOperation:operation];
    }];
}

- (void)loadMessagesForConversation:(CKCConversation *)conversation completionHandler:(void (^)(NSArray *))completionHandler
{
    NSString *predicateFormat = [CKCMessageConversationKey stringByAppendingString:@" = %@"];
    CKReference *conversationReference = [[CKReference alloc] initWithRecordID:conversation.identifier action:CKReferenceActionDeleteSelf];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, conversationReference];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:[CKCMessage type] predicate:predicate];
    
    [self.publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        NSMutableArray *messages = [NSMutableArray new];
        
        for (CKRecord *record in results) {
            CKCMessage *message = [[CKCMessage alloc] initWithCloudKitRecord:record];
            [messages addObject:message];
        }
        
        completionHandler(messages);
    }];
}

- (void)saveMessage:(CKCMessage *)message completionHandler:(void (^)(BOOL))completionHandler
{
    CKRecord *record = [message cloudKitRecord];
    
    [self.publicDatabase saveRecord:record completionHandler:^(CKRecord *record, NSError *error) {
        completionHandler(!error);
    }];
}

- (void)loadUsersMatchingSearchString:(NSString *)searchString completionHandler:(void (^)(NSArray *))completionHandler
{
    NSString *predicateFormat = [CKCUserNameKey stringByAppendingString:@" = %@"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchString];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:[CKCUser type] predicate:predicate];
    
    [self.publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        NSMutableArray *users = [NSMutableArray new];
        
        for (CKRecord *record in results) {
            CKCUser *user = [[CKCUser alloc] initWithCloudKitRecord:record];
            [users addObject:user];
        }
        
        completionHandler(users);
    }];
}

@end
