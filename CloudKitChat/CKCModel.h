#import <Foundation/Foundation.h>

/// Protocol that all CloudKitChat models must conform to
@protocol CKCModel <NSObject>

/// The identifier of the model
@property (nonatomic, copy, readonly) id identifier;

/// Return the type of the model
+ (NSString *)type;

@end