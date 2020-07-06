//
//  PostCell.h
//  Instagram
//
//  Created by Xurxo Riesco on 7/6/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@import Parse;
NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) IBOutlet PFImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;

- (void)loadPost:(Post *) post;
@end

NS_ASSUME_NONNULL_END
