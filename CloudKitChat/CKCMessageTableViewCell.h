#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CKCMessageTableViewCellStyle) {
    CKCMessageTableViewCellStyleLocalUser,
    CKCMessageTableViewCellStyleRemoteUser
};

@interface CKCMessageTableViewCell : UITableViewCell

@property (nonatomic) CKCMessageTableViewCellStyle messageCellStyle;

@end
