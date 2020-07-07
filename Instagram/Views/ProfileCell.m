//
//  ProfileCell.m
//  Instagram
//
//  Created by Xurxo Riesco on 7/7/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "ProfileCell.h"

@implementation ProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.postView addGestureRecognizer:profileTapGestureRecognizer];
    [self.postView setUserInteractionEnabled:YES];
    // Initialization code
}

- (void)loadPost:(Post *)post{
    self.post = post;
    self.postView.file = post[@"image"];
    [self.postView loadInBackground];
}
- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    [self.delegate profileCell:self didTap:self.post];
}

@end
