//
//  UserCell.m
//  Instagram
//
//  Created by Xurxo Riesco on 7/9/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUser:)];
    [self.profileView addGestureRecognizer:profileTapGestureRecognizer];
    [self.profileView setUserInteractionEnabled:YES];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)loadUser:(PFUser *)user{
    self.user = user;
    self.usernameLabel.text = user.username;
    self.profileView.file = user[@"profilePic"];
    self.profileView.layer.cornerRadius = 31;
    self.profileView.layer.masksToBounds = YES;
    [self.profileView loadInBackground];
}
- (void) didTapUser:(UITapGestureRecognizer *)sender{
    [self.delegate userCell:self didTap:self.user];
}

@end
