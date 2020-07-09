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
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)loadComment:(Comment *)comment{
    self.comment = comment;
    self.commentLabel.text = comment[@"text"];
    User *user = comment[@"author"];
    self.userLabel.text = user.username;
}
@end
