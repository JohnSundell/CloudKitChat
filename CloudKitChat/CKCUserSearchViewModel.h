#import "CKCViewModel.h"

@class CKCUser;
@protocol CKCModelLoader;

/// View model for the User Search view
@interface CKCUserSearchViewModel : NSObject <CKCViewModel>

/// The number of results that this view model contains
@property (nonatomic, readonly) NSUInteger numberOfResults;

/// Initialize an instance of this class with the required data
- (instancetype)initWithLocalUser:(CKCUser *)localUser modelLoader:(id<CKCModelLoader>)modelLoader;

/// Update the view model for a new search string
- (void)updateForSearchString:(NSString *)searchString;

/// Return the user at a specified index
- (CKCUser *)userAtIndex:(NSUInteger)index;

@end
