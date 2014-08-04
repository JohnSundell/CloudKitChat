#import "CKCConversation.h"
#import "CKCUser.h"
#import "CKCMessage.h"

@interface CKCConversation ()

@property (nonatomic, strong, readwrite) NSDate *lastActivityTimestamp;
@property (nonatomic, strong) NSMutableArray *mutableMessages;

@end

@implementation CKCConversation

@synthesize identifier = _identifier;

- (instancetype)initWithIdentifier:(NSString *)identifier localUser:(CKCUser *)localUser remoteUser:(CKCUser *)remoteUser messages:(NSArray *)messages
{
    if (!(self = [super init])) {
        return nil;
    }
    
    _identifier = identifier;
    _localUser = localUser;
    _remoteUser = remoteUser;
    
    if (messages.count > 0) {
        _mutableMessages = [messages mutableCopy];
        
        CKCMessage *lastMessage = [messages lastObject];
        _lastActivityTimestamp = lastMessage.timestamp;
    } else {
        _mutableMessages = [NSMutableArray new];
        _lastActivityTimestamp = [NSDate date];
    }
    
    return self;
}

- (NSArray *)messages
{
    return [self.mutableMessages copy];
}

- (CKCMessage *)messageAtIndex:(NSUInteger)index
{
    return [self.messages objectAtIndex:index];
}

- (void)addMessage:(CKCMessage *)message
{
    [self.mutableMessages addObject:message];
    self.lastActivityTimestamp = [NSDate date];
}

#pragma mark - CKCModel

+ (NSString *)type
{
    return @"conversation";
}

@end

@implementation CKCConversation (UserInterfaceRepresentation)

- (CKCImage *)userInterfaceImage
{
    return self.remoteUser.profilePicture;
}

- (NSString *)userInterfaceTitle
{
    return self.remoteUser.name;
}

@end
