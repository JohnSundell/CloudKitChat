#import "CKCMessageTableViewCell.h"

@implementation CKCMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (!(self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier])) {
        return nil;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    switch (self.messageCellStyle) {
        case CKCMessageTableViewCellStyleLocalUser:
            self.textLabel.textColor = [UIColor blackColor];
            break;
        case CKCMessageTableViewCellStyleRemoteUser:
            self.textLabel.textColor = [UIColor blueColor];
            break;
    }
    
    self.detailTextLabel.textColor = self.textLabel.textColor;
}

@end
