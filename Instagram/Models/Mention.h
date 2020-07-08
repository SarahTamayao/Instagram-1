//
//  Mention.h
//  Instagram
//
//  Created by Xurxo Riesco on 7/8/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface Mention : NSObject
@property (nonatomic, strong) Post *post;
@property (nonatomic, strong) PFUser *user;
@end

NS_ASSUME_NONNULL_END
