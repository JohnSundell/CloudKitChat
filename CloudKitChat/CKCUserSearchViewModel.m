#import "CKCUserSearchViewModel.h"
#import "CKCModelLoader.h"

@interface CKCUserSearchViewModel ()

@property (nonatomic, strong) CKCUser *localUser;
@property (nonatomic, strong) id<CKCModelLoader> modelLoader;
@property (nonatomic, strong) NSArray *usersMatchingSearchString;

@end

@implementation CKCUserSearchViewModel

@synthesize delegate = _delegate;

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

- (void)loadData
{
    // No initial data to load for this view model
}

#pragma mark - CKCUserSearchViewModel

- (void)updateForSearchString:(NSString *)searchString
{
    if (searchString.length == 0) {
        return;
    }
    
    __weak typeof(self) _self = self;
    
    [self.modelLoader loadUsersMatchingSearchString:searchString completionHandler:^(NSArray *users) {
       dispatch_async(dispatch_get_main_queue(), ^{
           if (users) {
               _self.usersMatchingSearchString = users;
               [_self.delegate viewModelDidLoad:_self];
           } else {
               // Smart error handling
           }
       });
    }];
}

- (NSUInteger)numberOfResults
{
    return self.usersMatchingSearchString.count;
}

- (CKCUser *)userAtIndex:(NSUInteger)index
{
    return [self.usersMatchingSearchString objectAtIndex:index];
}

@end
