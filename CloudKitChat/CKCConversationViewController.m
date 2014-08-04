#import "CKCConversationViewController.h"
#import "CKCConversationViewModel.h"
#import "CKCConversation.h"
#import "CKCMessage.h"
#import "CKCUser.h"
#import "CKCMessageTableViewCell.h"

@interface CKCConversationViewController () <UITextFieldDelegate>

@property (nonatomic, strong) CKCConversationViewModel *viewModel;

@end

@implementation CKCConversationViewController

- (instancetype)initWithViewModel:(CKCConversationViewModel *)viewModel
{
    if (!(self = [super initWithViewControllerFactory:nil])) {
        return nil;
    }
    
    _viewModel = viewModel;
    _viewModel.delegate = self;
    
    self.title = viewModel.conversation.userInterfaceTitle;
    
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *messageBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 80)];
    messageBar.tintColor = [UIColor whiteColor];
    
    CGRect messageTextFieldFrame;
    messageTextFieldFrame.size = CGSizeMake(CGRectGetWidth(messageBar.frame) - 40, 44);
    messageTextFieldFrame.origin.x = floorf((CGRectGetWidth(messageBar.frame) - CGRectGetWidth(messageTextFieldFrame)) / 2);
    messageTextFieldFrame.origin.y = floorf((CGRectGetHeight(messageBar.frame) - CGRectGetHeight(messageTextFieldFrame)) / 2);
    
    UITextField *messageTextField = [[UITextField alloc] initWithFrame:messageTextFieldFrame];
    messageTextField.delegate = self;
    messageTextField.tintColor = [UIColor blueColor];
    messageTextField.borderStyle = UITextBorderStyleRoundedRect;
    messageTextField.returnKeyType = UIReturnKeySend;
    [messageBar addSubview:messageTextField];
    
    self.tableView.tableFooterView = messageBar;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDataForViewModel:self.viewModel];
}

#pragma mark - CKCTableViewController

- (Class)cellClass
{
    return [CKCMessageTableViewCell class];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.conversation.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKCMessage *message = [self.viewModel messageAtIndex:indexPath.row];
    
    CKCMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CKCTableViewControllerCellIdentifier];
    cell.textLabel.text = [self.viewModel senderForMessageAtIndex:indexPath.row].name;
    cell.detailTextLabel.text = message.text;
    
    if ([self.viewModel senderIsLocalUserForMessageAtIndex:indexPath.row]) {
        cell.messageCellStyle = CKCMessageTableViewCellStyleLocalUser;
    } else {
        cell.messageCellStyle = CKCMessageTableViewCellStyleRemoteUser;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.viewModel sendMessageWithText:textField.text completionHandler:^(BOOL success) {
        if (success) {
            NSIndexPath *messageIndexPath = [NSIndexPath indexPathForRow:self.viewModel.conversation.messages.count - 1
                                                               inSection:0];
            
            [self.tableView insertRowsAtIndexPaths:@[messageIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [textField resignFirstResponder];
            textField.text = @"";
        }
    }];
    
    return YES;
}

@end
