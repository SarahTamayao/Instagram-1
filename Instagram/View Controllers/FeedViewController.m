//
//  FeedViewController.m
//  Instagram
//
//  Created by Xurxo Riesco on 7/5/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "FeedViewController.h"
#import <Parse/Parse.h>
#import "PostCell.h"
#import "Post.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
@interface FeedViewController () < UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *posts;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor],
       NSFontAttributeName:[UIFont fontWithName:@"Billabong" size:32]}];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fecthPost];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"HeaderView"];
    //[self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HeaderViewIdentifier];
    // Do any additional setup after loading the view.
}
- (void)fecthPost {
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.posts = [posts mutableCopy];
            self.dataSkip = 20;
            [self.tableView reloadData];
        }
        else {
            // handle error
        }
    }];
}
- (void)fecthMorePost {
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery setSkip:self.dataSkip];
    postQuery.limit = 20;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            if (posts.count > 0) {
                int prevNumPosts = self.posts.count;
                self.posts = [self.posts arrayByAddingObjectsFromArray:posts];
                NSMutableArray *newIndexPaths = [NSMutableArray array];
                for (int i = prevNumPosts; i < self.posts.count; i++) {
                    [newIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
                self.dataSkip += 20;
            }
            self.isMoreDataLoading = false;
            [self.tableView reloadData];
        }
        else {
            // handle error
        }
    }];
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Post *post = self.posts[indexPath.row];
    PostCell *postCell = [ tableView dequeueReusableCellWithIdentifier:@"PostCell" ];
    //NSLog(@"%@", post);
    [postCell loadPost:post];
    return postCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.posts.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderView"];
    Post *post = self.posts[section] ;
    PFUser *user = post[@"author"];
    NSLog (@"%@", user.username);
    header.textLabel.text = user.username;
    return header;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self fecthPost];
    [refreshControl endRefreshing];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            NSLog(@"More data");
            NSLog(@"%d",self.dataSkip);
            [self fecthMorePost];
            
        }
    }
}
- (IBAction)onLogOut:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
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
