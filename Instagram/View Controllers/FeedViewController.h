//
//  FeedViewController.h
//  Instagram
//
//  Created by Xurxo Riesco on 7/5/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedViewController : UIViewController
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (assign, nonatomic) int dataSkip;

@end

NS_ASSUME_NONNULL_END
