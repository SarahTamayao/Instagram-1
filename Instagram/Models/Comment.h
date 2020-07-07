//
//  Comment.h
//  Instagram
//
//  Created by Xurxo Riesco on 7/6/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <Parse/Parse.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface Comment : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) PFUser *author;

@end

NS_ASSUME_NONNULL_END
