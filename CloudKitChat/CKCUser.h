#import "CKCModel.h"
#import "CKCImage.h"

/// Model class representing a user of CloudKitChat
@interface CKCUser : NSObject <CKCModel>

/// The name of the user
@property (nonatomic, copy, readonly) NSString *name;

/// The user's profile picture
@property (nonatomic, strong, readonly) CKCImage *profilePicture;

/// Initialize an instance of this class with the required data
- (instancetype)initWithIdentifier:(id)identifier
                              name:(NSString *)name
                    profilePicture:(CKCImage *)profilePicture NS_DESIGNATED_INITIALIZER;

@end
