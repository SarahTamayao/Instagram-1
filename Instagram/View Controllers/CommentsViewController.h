//
//  CommentsViewController.h
//  Instagram
//
//  Created by Xurxo Riesco on 7/7/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommentsViewController : UIViewController
@property (strong, nonatomic) Post *post;

@end

NS_ASSUME_NONNULL_END
