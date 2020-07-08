//
//  CommentsViewController.m
//  Instagram
//
//  Created by Xurxo Riesco on 7/7/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "CommentsViewController.h"
#import "Comment.h"
#import "CommentCell.h"
#import "DateTools.h"
#import "UserViewController.h"
@import Parse;


@interface CommentsViewController ()  < UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet PFImageView *postView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *commentField;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic) NSMutableArray *comments;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) PFUser *user;
@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.postView.file = self.post[@"image"];
    [self.postView loadInBackground];
    PFUser *user = self.post[@"author"];
    self.usernameLabel.text = user.username;
    self.user = user;
    self.captionLabel.text = self.post[@"caption"];
    self.commentField.delegate = self;
    [self fetchComments];
    NSDate *date = self.post[@"created_At"];
    NSLog(@"%@", date);
    NSDate *timeAgo = [NSDate dateWithTimeInterval:0 sinceDate:date];
    self.dateLabel.text = timeAgo.timeAgoSinceNow;
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.usernameLabel addGestureRecognizer:profileTapGestureRecognizer];
    [self.usernameLabel setUserInteractionEnabled:YES];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.commentField resignFirstResponder];
    return YES;
}
#pragma mark - Network
- (void)fetchComments {
    PFRelation *relation = [self.post relationForKey:@"Comment"];
    PFQuery *query = [relation query];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray* _Nullable comments, NSError * _Nullable error) {
        if (comments) {
            self.comments = [comments mutableCopy];
            NSLog(@"%@", self.comments);
            [self.tableView reloadData];
        }
    }];
}
- (IBAction)onPost:(id)sender {
    Comment *newComment = [Comment new];
    newComment.author = [PFUser currentUser];
    newComment.text = self.commentField.text;
    [newComment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            PFRelation *relation = [self.post relationForKey:@"Comment"];
            [relation addObject:newComment];
            [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(succeeded){
                    [self fetchComments];
                }
            }];
        }
    }];
    
}
#pragma mark - TableView
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Comment *comment = self.comments[indexPath.row];
    CommentCell *commentCell = [ tableView dequeueReusableCellWithIdentifier:@"CommentCell" ];
    [commentCell loadComment:comment];
    return commentCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}
- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    [self performSegueWithIdentifier:@"profileSegue" sender:nil];
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UserViewController *userViewController = [segue destinationViewController];
    userViewController.user = self.user;
}


@end
