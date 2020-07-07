//
//  ProfileCell.h
//  Instagram
//
//  Created by Xurxo Riesco on 7/7/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@protocol ProfileCellDelegate;

@interface ProfileCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *postView;
@property (strong, nonatomic) Post *post;
@property (nonatomic, weak) id<ProfileCellDelegate> delegate;
- (void)loadPost:(Post *)post;


@end
@protocol ProfileCellDelegate
- (void)profileCell:(ProfileCell *) profileCell didTap: (Post *)post;
@end


NS_ASSUME_NONNULL_END
