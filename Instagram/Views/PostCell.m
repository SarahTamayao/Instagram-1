//
//  PostCell.m
//  Instagram
//
//  Created by Xurxo Riesco on 7/6/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "PostCell.h"
#import "Post.h"
#import "DateTools.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.commentButton addGestureRecognizer:profileTapGestureRecognizer];
    [self.commentButton setUserInteractionEnabled:YES];
    UITapGestureRecognizer *likeTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didLike:)];
    likeTapGestureRecognizer.numberOfTapsRequired = 2;
    [self.photoImageView addGestureRecognizer:likeTapGestureRecognizer];
    [self.photoImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *userTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUser:)];
    userTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.authorLabel addGestureRecognizer:userTapGestureRecognizer];
    [self.authorLabel setUserInteractionEnabled:YES];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)loadPost:(Post *)post{
    self.post = post;
    self.photoImageView.file = post[@"image"];
    [self.photoImageView loadInBackground];
    PFUser *user = post[@"author"];
    self.authorLabel.text = user.username;
    self.descriptionLabel.text = post[@"caption"];
    self.likeCountLabel.text = [NSString stringWithFormat:@" Liked by %@", post[@"likeCount"]];
    //NSString *createdAtOriginalString = post[@"createdAt"];
    //NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    NSDate *date = post[@"created_At"];
    NSLog(@"%@", date);
    NSDate *timeAgo = [NSDate dateWithTimeInterval:0 sinceDate:date];
    self.dateLabel.text = timeAgo.timeAgoSinceNow;
    PFRelation *relation = [self.post relationForKey:@"Liked_By"];
    PFQuery *query = [relation query];
    [query includeKey:@"author"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray* _Nullable likedBy, NSError * _Nullable error) {
        if (!error) {
            if(likedBy.count >0){
                for(NSDictionary *like in likedBy)
                {
                    if([like[@"username"] isEqual:[PFUser currentUser].username]){
                        self.likeButton.selected = YES;
                    }
                }
            }
        }
    }];
}
- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    [self.delegate postCell:self didTap:self.post];
}
- (void) didLike:(UITapGestureRecognizer *)sender{
    [self.delegate postCell:self didLike:self.post];
}
- (void) didTapUser:(UITapGestureRecognizer *)sender{
    [self.delegate postCell:self User:self.post];
}
- (void) refresh{
    self.likeCountLabel.text = [NSString stringWithFormat:@" Liked by %@", self.post[@"likeCount"]];
}



@end
