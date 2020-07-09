//
//  StoryCell.m
//  Instagram
//
//  Created by Xurxo Riesco on 7/8/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "StoryCell.h"

@implementation StoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *storiesTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapStory:)];
    [self.postView addGestureRecognizer:storiesTapGestureRecognizer];
    [self.postView setUserInteractionEnabled:YES];
}
- (void)loadStory:(Stories *)story{
    self.story = story;
    self.postView.file = story[@"image"];
    PFUser *user = story[@"author"];
    self.userLabel.text = user.username;
    self.postView.layer.cornerRadius = 25;
    self.postView.layer.masksToBounds = YES;
    [self.postView loadInBackground];
}
#pragma mark - Delegate
- (void) didTapStory:(UITapGestureRecognizer *)sender{
    [self.delegate storyCell:self didTap:self.story withIndex:self.startIndex];
}
@end
