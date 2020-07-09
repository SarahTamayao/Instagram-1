//
//  StoriesViewController.h
//  Instagram
//
//  Created by Xurxo Riesco on 7/7/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stories.h"

NS_ASSUME_NONNULL_BEGIN

@interface StoriesViewController : UIPageViewController

@property (strong, nonatomic) NSArray *stories;
@property (strong, nonatomic) NSNumber *index;
@end

NS_ASSUME_NONNULL_END
