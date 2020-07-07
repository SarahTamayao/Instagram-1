//
//  UserViewController.h
//  Instagram
//
//  Created by Xurxo Riesco on 7/7/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserViewController : UIViewController
@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) PFUser *user;

@end

NS_ASSUME_NONNULL_END
