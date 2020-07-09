//
//  StoryViewController.h
//  Instagram
//
//  Created by Xurxo Riesco on 7/7/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;
#import "Stories.h"

NS_ASSUME_NONNULL_BEGIN
@interface StoryViewController : UIViewController

@property (weak, nonatomic) IBOutlet PFImageView *storyView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property NSUInteger index;
@property (nonatomic, strong) Stories *story;
@end

NS_ASSUME_NONNULL_END
