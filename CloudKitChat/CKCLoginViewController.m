#import "CKCLoginViewController.h"
#import "CKCModelLoader.h"
#import "CKCViewControllerFactory.h"

@interface CKCLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong, readonly) id<CKCModelLoader> modelLoader;
@property (nonatomic, strong) UITextField *usernameTextField;

@end

@implementation CKCLoginViewController

- (instancetype)initWithModelLoader:(id<CKCModelLoader>)modelLoader
{
    if (!(self = [super init])) {
        return nil;
    }
    
    _modelLoader = modelLoader;
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    __weak typeof(self) _self = self;
    
    [self.modelLoader setupWithCompletionHandler:^(BOOL success) {
        [_self.modelLoader loadLocalUserWithCompletionHandler:^(CKCUser *localUser) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (localUser) {
                    [_self localUserLoggedIn:localUser];
                } else {
                    [_self showSignupView];
                }
            });
        }];
    }];
}

- (void)showSignupView
{
    CGRect usernameTextFieldFrame;
    usernameTextFieldFrame.size = CGSizeMake(CGRectGetWidth(self.view.frame) - 40, 44);
    usernameTextFieldFrame.origin = CGPointMake(20, 100);
    
    self.usernameTextField = [[UITextField alloc] initWithFrame:usernameTextFieldFrame];
    self.usernameTextField.delegate = self;
    self.usernameTextField.placeholder = @"Enter a username";
    self.usernameTextField.tintColor = [UIColor blueColor];
    self.usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.usernameTextField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:self.usernameTextField];
    
    CGRect signupButtonFrame;
    signupButtonFrame.size = usernameTextFieldFrame.size;
    signupButtonFrame.origin.x = CGRectGetMinX(usernameTextFieldFrame);
    signupButtonFrame.origin.y = CGRectGetMaxY(usernameTextFieldFrame) + 50;
    
    UIButton *signupButton = [[UIButton alloc] initWithFrame:signupButtonFrame];
    [signupButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [signupButton setTitle:@"Signup" forState:UIControlStateNormal];
    [signupButton addTarget:self action:@selector(signupButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signupButton];
}

- (void)signupButtonPressed
{
    [self.modelLoader saveLocalUserWithName:self.usernameTextField.text
                             profilePicture:nil
                          completionHandler:^(CKCUser *localUser) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  if (localUser) {
                                      [self localUserLoggedIn:localUser];
                                  } else {
                                      // Smart error handling
                                  }
                              });
                          }];
}

- (void)localUserLoggedIn:(CKCUser *)localUser
{
    CKCViewControllerFactory *viewControllerFactory = [[CKCViewControllerFactory alloc] initWithLocalUser:localUser modelLoader:self.modelLoader];
    UIViewController *conversationsListVC = [viewControllerFactory conversationsListViewController];
    [self.navigationController setViewControllers:@[conversationsListVC] animated:NO];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
