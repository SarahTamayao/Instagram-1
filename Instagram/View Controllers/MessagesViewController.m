//
//  MessagesViewController.m
//  Instagram
//
//  Created by Xurxo Riesco on 7/9/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "MessagesViewController.h"
#import "MessageThreadViewController.h"
#import "UserCell.h"

@interface MessagesViewController () < UserCellDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *users;
@property (strong, nonatomic) PFUser *user;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fetchUsers];
    // Do any additional setup after loading the view.
}
- (void)fetchUsers{
    PFQuery *queryUsers = [PFUser query];
    [queryUsers whereKey:@"username" notEqualTo:[PFUser currentUser].username];
    queryUsers.limit = 20;
    [queryUsers findObjectsInBackgroundWithBlock:^(NSArray<PFUser *>* users, NSError * _Nullable error) {
        self.users = users;
        [self.tableView reloadData];
    }];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PFUser *user = self.users[indexPath.row];
    UserCell *userCell = [ tableView dequeueReusableCellWithIdentifier:@"UserCell" ];
    userCell.delegate = self;
    [userCell loadUser:user];
    return userCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}
- (void) userCell:(UserCell *)userCell didTap:(PFUser *)user{
    self.user = user;
    [self performSegueWithIdentifier:@"threadSegue" sender:nil];
}
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MessageThreadViewController *messageThread = [segue destinationViewController];
    messageThread.user = self.user;
}

@end
