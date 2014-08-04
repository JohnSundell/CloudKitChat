#import "CKCUser.h"

@implementation CKCUser

@synthesize identifier = _identifier;

- (instancetype)initWithIdentifier:(NSString *)identifier name:(NSString *)name profilePicture:(UIImage *)profilePicture
{
    if (!(self = [super init])) {
        return nil;
    }
    
    _identifier = identifier;
    _name = name;
    _profilePicture = profilePicture;
    
    return self;
}

#pragma mark - CKCModel

+ (NSString *)type
{
    return @"user";
}

@end
