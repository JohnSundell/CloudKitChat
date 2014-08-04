#import "CKCMessage.h"

@implementation CKCMessage

@synthesize identifier = _identifier;

- (instancetype)initWithIdentifier:(NSString *)identifier text:(NSString *)text timestamp:(NSDate *)timestamp sentByUserIdentifier:(id)sentByUserIdentifier conversationIdentifier:(id)conversationIdentifier
{
    if (!(self = [super init])) {
        return nil;
    }
    
    _identifier = identifier;
    _text = text;
    _timestamp = timestamp;
    _sentByUserIdentifier = sentByUserIdentifier;
    _conversationIdentifier = conversationIdentifier;
    
    return self;
}

#pragma mark - CKCModel

+ (NSString *)type
{
    return @"message";
}

@end
