//
//  MentionsCell.m
//  Instagram
//
//  Created by Xurxo Riesco on 7/8/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "MentionsCell.h"

@implementation MentionsCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)loadMention:(Mention *)mention{
    self.userLabel.text = [NSString stringWithFormat:@"%@ likes your post",mention.user.username];
    self.userView.layer.cornerRadius = 21;
    self.userView.layer.masksToBounds = YES;
    self.userView.file = mention.user[@"profilePic"];
    [self.userView loadInBackground];
    self.postView.file = mention.post[@"image"];
    [self.postView loadInBackground];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
