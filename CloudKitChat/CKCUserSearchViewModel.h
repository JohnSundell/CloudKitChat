#import "CKCViewModel.h"

@class CKCUser;
@protocol CKCModelLoader;

@interface CKCUserSearchViewModel : NSObject <CKCViewModel>

@property (nonatomic, readonly) NSUInteger numberOfResults;

- (instancetype)initWithLocalUser:(CKCUser *)localUser modelLoader:(id<CKCModelLoader>)modelLoader;
- (void)updateForSearchString:(NSString *)searchString;
- (CKCUser *)userAtIndex:(NSUInteger)index;

@end
