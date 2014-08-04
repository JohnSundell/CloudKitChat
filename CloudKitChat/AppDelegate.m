#import "AppDelegate.h"
#import "BuildSettings.h"
#import "CKCLoginViewController.h"

#ifdef CKC_USE_MOCKED_DATA
    #import "CKCMockModelLoader.h"
#else
    #import "CKCCloudKitModelLoader.h"
#endif

@interface AppDelegate ()
            

@end

@implementation AppDelegate
            
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
#ifdef CKC_USE_MOCKED_DATA
    id<CKCModelLoader> modelLoader = [CKCMockModelLoader new];
#else
    id<CKCModelLoader> modelLoader = [CKCCloudKitModelLoader new];
#endif
    
    UIViewController *loginVC = [[CKCLoginViewController alloc] initWithModelLoader:modelLoader];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
