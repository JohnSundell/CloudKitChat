#import <UIKit/UIKit.h>

@protocol CKCModelLoader;

@interface CKCLoginViewController : UIViewController

- (instancetype)initWithModelLoader:(id<CKCModelLoader>)modelLoader;

@end
