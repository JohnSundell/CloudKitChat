#import <Foundation/Foundation.h>

@protocol CKCViewModel;

/// Delegate protocol for CloudKitChat view models
@protocol CKCViewModelDelegate <NSObject>

/// Sent to the view model's delegate when the view model was loaded
- (void)viewModelDidLoad:(id<CKCViewModel>)viewModel;

@end

/// Protocol that all view models of CloudKitChat conforms to
@protocol CKCViewModel <NSObject>

/// The view model's delegate (See <CKCViewModelDelegate>)
@property (nonatomic, weak) id<CKCViewModelDelegate> delegate;

/// Load the view model's data (The view model should send -viewModelDidLoad: to its delegate when done)
- (void)loadData;

@end