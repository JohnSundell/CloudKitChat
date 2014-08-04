#import "CKCMockModelLoader.h"
#import "CKCUser.h"
#import "CKCConversation.h"
#import "CKCMessage.h"

@implementation CKCMockModelLoader

- (void)setupWithCompletionHandler:(void (^)(BOOL))completionHandler
{
    completionHandler(YES);
}

- (void)loadLocalUserWithCompletionHandler:(void (^)(CKCUser *))completionHandler
{
    CKCUser *user = [[CKCUser alloc] initWithIdentifier:@"localUser" name:@"John" profilePicture:nil];
    completionHandler(user);
}

- (void)saveLocalUserWithName:(NSString *)name profilePicture:(UIImage *)profilePicture completionHandler:(void (^)(CKCUser *))completionHandler
{
    CKCUser *user = [[CKCUser alloc] initWithIdentifier:@"localUser" name:@"John" profilePicture:nil];
    completionHandler(user);
}

- (void)loadConversationsForLocalUser:(CKCUser *)localUser completionHandler:(void (^)(NSArray *))completionHandler
{
    NSMutableArray *conversations = [NSMutableArray new];
    
    NSArray *names = @[@"Jonathan", @"Paul", @"Anna", @"Emma"];
    
    NSArray *messageTexts = @[@"Hi, how are you?", @"I'm good, and you?", @"Really good! Nice weather huh?", @"Yeah, totally!"];
    NSMutableArray *messages = [NSMutableArray new];
    
    for (NSUInteger i = 0; i < 4; i++) {
        CKCMessage *message = [[CKCMessage alloc] initWithIdentifier:nil
                                                                text:[messageTexts objectAtIndex:i]
                                                           timestamp:[NSDate date]
                                                sentByUserIdentifier:(i % 2) ? localUser.identifier : nil
                                              conversationIdentifier:nil];
        
        [messages addObject:message];
    }
    
    for (NSUInteger i = 0; i < 4; i++) {
        NSString *identifier = [NSString stringWithFormat:@"%u", i];
        CKCUser *remoteUser = [[CKCUser alloc] initWithIdentifier:nil
                                                             name:[names objectAtIndex:i]
                                                   profilePicture:nil];
        CKCConversation *conversation = [[CKCConversation alloc] initWithIdentifier:identifier
                                                                          localUser:localUser
                                                                         remoteUser:remoteUser
                                                                           messages:messages];
        
        [conversations addObject:conversation];
    }
    
    completionHandler(conversations);
}

- (void)loadMessagesForConversation:(CKCConversation *)conversation completionHandler:(void (^)(NSArray *))completionHandler
{
    completionHandler(nil);
}

- (void)saveMessage:(CKCMessage *)message completionHandler:(void (^)(BOOL))completionHandler
{
    completionHandler(YES);
}

- (void)loadUsersMatchingSearchString:(NSString *)searchString completionHandler:(void (^)(NSArray *))completionHandler
{
    NSArray *names = @[@"Robert", @"Caroline", @"Amanda", @"Jordan", @"Michael"];
    NSMutableArray *allUsers = [NSMutableArray new];
    
    for (NSString *name in names) {
        CKCUser *user = [[CKCUser alloc] initWithIdentifier:nil name:name profilePicture:nil];
        [allUsers addObject:user];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", searchString];
    
    completionHandler([allUsers filteredArrayUsingPredicate:predicate]);
}

@end
