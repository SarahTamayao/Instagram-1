//
//  MentionsViewController.m
//  Instagram
//
//  Created by Xurxo Riesco on 7/8/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "MentionsViewController.h"
#import "Mention.h"
#import "MentionsCell.h"
@interface MentionsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *mentions;
@property NSInteger interactions;
@end

@implementation MentionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.mentions = [[NSMutableArray alloc] init];
    [self getMentions];
}
#pragma mark - Network
- (void)getMentions {
        PFQuery *postQuery = [Post query];
        [postQuery orderByDescending:@"createdAt"];
        [postQuery whereKey:@"author" equalTo:[PFUser currentUser]];
        [postQuery includeKey:@"author"];
        postQuery.limit = 20;
        [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
            if (posts) {
                NSLog(@"Posts: %@", posts);
                for(Post *post in posts){
                    PFRelation *relation = [post relationForKey:@"Liked_By"];
                    PFQuery *query = [relation query];
                    [query includeKey:@"author"];
                    query.limit = 20;
                    [query findObjectsInBackgroundWithBlock:^(NSArray* _Nullable likedBy, NSError * _Nullable error) {
                        NSLog(@"LikedBy: %@", likedBy);
                        for(PFUser *user in likedBy)
                        {
                            NSLog(@"USER LIKING: %@", user);
                            Mention *mention = [Mention new];
                            mention.post = post;
                            mention.user = user;
                            self.interactions +=1;
                            [self.mentions addObject:mention];
                        }
                        NSLog(@"INTERACTIONS %d", self.interactions);
                        NSLog(@"Mentions: %@", self.mentions);
                        [self.tableView reloadData];
                    }];
                }
            }
        }];
}
#pragma mark - TableView
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Mention *mention = self.mentions[indexPath.row];
    NSLog(@"Username to mention: %@", mention.user.username);
    MentionsCell *mentionCell = [ tableView dequeueReusableCellWithIdentifier:@"MentionsCell" ];
    [mentionCell loadMention:mention];
    return mentionCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Table View Rows %d", self.interactions);
    return self.interactions;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
