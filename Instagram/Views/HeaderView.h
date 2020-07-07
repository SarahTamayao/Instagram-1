//
//  HeaderView.h
//  Instagram
//
//  Created by Xurxo Riesco on 7/6/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;
NS_ASSUME_NONNULL_BEGIN

@interface HeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet PFImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
