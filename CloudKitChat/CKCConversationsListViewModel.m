#import "CKCConversationsListViewModel.h"
#import "CKCConversation.h"
#import "CKCUser.h"
#import "CKCMessage.h"
#import "CKCModelLoader.h"

@interface CKCConversationsListViewModel ()

@property (nonatomic, strong) CKCUser *localUser;
@property (nonatomic, strong) id<CKCModelLoader> modelLoader;
@property (nonatomic, strong) NSMutableArray *conversations;

@end

@implementation CKCConversationsListViewModel

- (instancetype)initWithLocalUser:(CKCUser *)localUser modelLoader:(id<CKCModelLoader>)modelLoader
{
    if (!(self = [super init])) {
        return nil;
    }
    
    _localUser = localUser;
    _modelLoader = modelLoader;
    
    return self;
}

#pragma mark - CKCViewModel

@synthesize delegate = _delegate;

- (void)loadData
{
    __weak typeof(self) _self = self;
    
    [self.modelLoader loadConversationsForLocalUser:self.localUser completionHandler:^(NSArray *conversations) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (conversations) {
                _self.conversations = [conversations mutableCopy];
                [_self.delegate viewModelDidLoad:_self];
            } else {
                // Smart error handling
            }
        });
    }];
}

#pragma mark - CKCConversationsListViewModel

- (NSUInteger)numberOfConversations
{
    return self.conversations.count;
}

- (CKCConversation *)conversationAtIndex:(NSUInteger)index
{
    return [self.conversations objectAtIndex:index];
}

- (void)addConversationWithUser:(CKCUser *)user completionHandler:(void (^)(CKCConversation *))completionHandler
{
    CKCConversation *conversation = [[CKCConversation alloc] initWithIdentifier:nil
                                                                      localUser:self.localUser
                                                                     remoteUser:user
                                                                       messages:nil];
    
    [self.modelLoader saveConversation:conversation completionHandler:completionHandler];
}

- (void)deleteConversationAtIndex:(NSUInteger)index completionHandler:(void (^)(BOOL))completionHandler
{
    [self.conversations removeObjectAtIndex:index];
    completionHandler(YES);
}

@end
