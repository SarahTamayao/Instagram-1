//
//  StoryCell.h
//  Instagram
//
//  Created by Xurxo Riesco on 7/8/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stories.h"
@import Parse;
NS_ASSUME_NONNULL_BEGIN
@protocol StoryCellDelegate;

@interface StoryCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *postView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (strong, nonatomic) Stories *story;
@property  (strong, nonatomic) NSNumber *startIndex;

- (void)loadStory:(Stories *)story;
@property (nonatomic, weak) id<StoryCellDelegate> delegate;

@end
@protocol StoryCellDelegate
- (void)storyCell:(StoryCell *) storyCell didTap: (Stories *)story withIndex: (NSNumber*) index;
@end

NS_ASSUME_NONNULL_END
