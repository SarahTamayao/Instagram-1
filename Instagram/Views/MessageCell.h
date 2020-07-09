//
//  MessageCell.h
//  Instagram
//
//  Created by Xurxo Riesco on 7/9/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bubbleView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *ownBubbleView;
@property (weak, nonatomic) IBOutlet UILabel *ownMessageLabel;
- (void)loadMessage:(Message *)message;
- (void)loadOwnMessage:(Message *)message;
@end

NS_ASSUME_NONNULL_END
