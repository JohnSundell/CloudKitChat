#import "CKCConversationViewModel.h"
#import "CKCConversation.h"
#import "CKCMessage.h"
#import "CKCModelLoader.h"
#import "CKCUser.h"

@interface CKCConversationViewModel()

@property (nonatomic, strong) id<CKCModelLoader> modelLoader;

@end

@implementation CKCConversationViewModel

@synthesize delegate = _delegate;

#pragma mark - CKCConversationViewModel

- (instancetype)initWithConversation:(CKCConversation *)conversation modelLoader:(id<CKCModelLoader>)modelLoader
{
    if (!(self = [super init])) {
        return nil;
    }
    
    _conversation = conversation;
    _modelLoader = modelLoader;
    
    return self;
}

- (CKCMessage *)messageAtIndex:(NSUInteger)index
{
    return [self.conversation.messages objectAtIndex:index];
}

- (CKCUser *)senderForMessageAtIndex:(NSUInteger)index
{
    if ([self senderIsLocalUserForMessageAtIndex:index]) {
        return self.conversation.localUser;
    }
    
    return self.conversation.remoteUser;
}

- (BOOL)senderIsLocalUserForMessageAtIndex:(NSUInteger)index
{
    return [[self messageAtIndex:index].sentByUserIdentifier isEqual:self.conversation.localUser.identifier];
}

- (void)sendMessageWithText:(NSString *)text completionHandler:(void (^)(BOOL))completionHandler
{
    CKCMessage *message = [[CKCMessage alloc] initWithIdentifier:nil
                                                            text:text
                                                       timestamp:[NSDate date]
                                            sentByUserIdentifier:self.conversation.localUser.identifier
                                          conversationIdentifier:self.conversation.identifier];
    
    __weak typeof(self) _self = self;
    
    [self.modelLoader saveMessage:message completionHandler:^(BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                [_self.conversation addMessage:message];
            }
            
            completionHandler(success);
        });
    }];
}

#pragma mark - CKCViewModel

- (void)loadData
{
    __weak typeof(self) _self = self;
    
    [self.modelLoader loadMessagesForConversation:self.conversation completionHandler:^(NSArray *messages) {
       dispatch_async(dispatch_get_main_queue(), ^{
           for (CKCMessage *message in messages) {
               [_self.conversation addMessage:message];
           }
           
           [_self.delegate viewModelDidLoad:_self];
       });
    }];
}

@end
