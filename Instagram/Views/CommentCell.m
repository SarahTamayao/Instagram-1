//
//  CommentCell.m
//  Instagram
//
//  Created by Xurxo Riesco on 7/7/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "CommentCell.h"
#import "User.h"

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)loadComment:(Comment *)comment{
    self.comment = comment;
    self.commentLabel.text = comment[@"text"];
    NSLog(@"TEXT %@", comment[@"text"]);
    User *user = comment[@"author"];
    NSLog(@"%@", user.username);
    self.userLabel.text = user.username;
}

@end
