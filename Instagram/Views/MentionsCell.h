//
//  MentionsCell.h
//  Instagram
//
//  Created by Xurxo Riesco on 7/8/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mention.h"
NS_ASSUME_NONNULL_BEGIN

@interface MentionsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *userView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet PFImageView *postView;

- (void)loadMention:(Mention *)mention;
@end

NS_ASSUME_NONNULL_END
