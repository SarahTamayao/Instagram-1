//
//  PostCell.h
//  Instagram
//
//  Created by Xurxo Riesco on 7/6/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "User.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@protocol PostCellDelegate;

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) IBOutlet PFImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) id<PostCellDelegate> delegate;
- (void)loadPost:(Post *) post;
- (void) refresh;
@end

@protocol PostCellDelegate
- (void)postCell:(PostCell *) postCell didTap: (Post *)post;
- (void)postCell:(PostCell *) postCell didLike: (Post *)post;
- (void)postCell:(PostCell *) postCell User: (Post *)post;
@end


NS_ASSUME_NONNULL_END
