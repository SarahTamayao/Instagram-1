//
//  MessageThreadViewController.h
//  Instagram
//
//  Created by Xurxo Riesco on 7/9/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Message.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface MessageThreadViewController : UIViewController
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Message *message;

@end

NS_ASSUME_NONNULL_END
