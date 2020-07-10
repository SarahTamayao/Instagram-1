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
#import "HeaderView.h"
#import "CommentsViewController.h"
#import "UserViewController.h"
#import "Stories.h"
#import "StoriesViewController.h"
#import "StoryCell.h"
@interface FeedViewController () < UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, PostCellDelegate, StoryCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) Post *post;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSArray *stories;
@property  (nonatomic, strong) NSNumber *startIndex;

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
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self fecthPost];
    [self fetchStories];
    [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(onTimer) userInfo:nil repeats:NO];
    [self.tableView registerNib:[UINib nibWithNibName:@"HeaderView" bundle:nil]  forHeaderFooterViewReuseIdentifier:@"HeaderView"];
}
- (void)onTimer {
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

#pragma mark - CollectionView Delegate
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.stories.count;
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    StoryCell *storyCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StoryCell" forIndexPath: indexPath];
    Stories *story = self.stories[indexPath.item];
    storyCell.startIndex = [NSNumber numberWithInt:(indexPath.item)];
    [storyCell loadStory:story];
    storyCell.delegate = self;
    return storyCell;
}

#pragma mark - TableView Delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Post *post = self.posts[indexPath.section];
    PostCell *postCell = [ tableView dequeueReusableCellWithIdentifier:@"PostCell" ];
    postCell.delegate = self;
    [postCell loadPost:post];
    return postCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.posts.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderView"];
    Post *post = self.posts[section] ;
    NSLog(@"%@", self.posts[section]);
    User *user = post[@"author"];
    NSLog (@"%@", user.username);
    header.titleLabel.text = user.username;
    header.profileView.file = user[@"profilePic"];
    [header.profileView loadInBackground];
    header.profileView.layer.cornerRadius = 15;
    header.profileView.layer.masksToBounds = YES;
    
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - StoryCell Delegate
- (void)storyCell:(StoryCell *)storyCell didTap:(Stories *)story withIndex:(NSNumber*)index{
    self.startIndex = index;
    [self performSegueWithIdentifier:@"storiesSegue" sender:nil];
}

#pragma mark - PostCell Delegate
- (void)postCell:(PostCell *)postCell didTap:(Post *)post{
    self.post = post;
    [self performSegueWithIdentifier:@"commentsSegue" sender:nil];
}
- (void)postCell:(PostCell *)postCell User:(Post *)post{
    self.user = post[@"author"];
    [self performSegueWithIdentifier:@"userSegue" sender:nil];
}
- (void)postCell:(PostCell *)postCell didLike:(Post *)post{
    self.post = post;
    NSLog(@"%@", postCell);
    PFRelation *relation = [self.post relationForKey:@"Liked_By"];
    PFQuery *query = [relation query];
    [query includeKey:@"author"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray* _Nullable likedBy, NSError * _Nullable error) {
        if (!error) {
            bool unliked;
            if(likedBy.count >0){
                for(PFUser *like in likedBy)
                {
                    if([like[@"username"] isEqual:[PFUser currentUser].username]){
                        [self unlikePostCell:postCell];
                        unliked = true;
                        break;
                    }
                }if(!unliked){
                    [self likePostCell:postCell];
                }
            }else{
                [self likePostCell:postCell];
            }
        }
    }];
}
- (void)likePostCell:(PostCell *)postCell {
    NSLog(@"ELSE INSIDE IF");
    User *user = [PFUser currentUser];
    PFRelation *relation = [self.post relationForKey:@"Liked_By"];
    NSNumber *likes = [NSNumber numberWithInt:([self.post[@"likeCount"] intValue] + 1)];
    NSLog(@"likes: %@", likes);
    self.post[@"likeCount"] = likes;
    [relation addObject:user];
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded)
        {
            NSLog(@"Post liked");
            postCell.likeButton.selected = YES;
            [postCell refresh];
        }
    }];
}
- (void)unlikePostCell:(PostCell *)postCell{
    User *user = [PFUser currentUser];
    PFRelation *relation = [self.post relationForKey:@"Liked_By"];
    NSNumber *likes = [NSNumber numberWithInt:([self.post[@"likeCount"] intValue] - 1)];
    NSLog(@"likes: %@", likes);
    self.post[@"likeCount"] = likes;
    [relation removeObject:user];
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded)
        {
            NSLog(@"Post unliked");
            postCell.likeButton.selected = NO;
            [postCell refresh];
        }
    }];
    
}
#pragma mark - Network
- (void)fecthPost {
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"Following"];
    PFQuery *query = [relation query];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray<PFUser *> * _Nullable following, NSError * _Nullable error) {
        if (following) {
            NSLog(@"%@", following);
            PFQuery *postQuery = [Post query];
            [postQuery orderByDescending:@"createdAt"];
            [postQuery whereKey:@"author" containedIn:following];
            [postQuery includeKey:@"author"];
            postQuery.limit = 20;
            [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
                if (posts) {
                    NSLog(@"%@", posts);
                    self.posts = [posts mutableCopy];
                    self.dataSkip = posts.count;
                    [self.tableView reloadData];
                }
            }];
            
        }
    }];
}
- (void)fecthMorePost {
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"Following"];
    PFQuery *query = [relation query];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray<PFUser *> * _Nullable following, NSError * _Nullable error) {
        if (following) {
            NSLog(@"%@", following);
            PFQuery *postQuery = [Post query];
            [postQuery orderByDescending:@"createdAt"];
            [postQuery whereKey:@"author" containedIn:following];
            [postQuery includeKey:@"author"];
            postQuery.limit = 20;
            [postQuery setSkip:self.dataSkip];
            [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
                if (posts) {
                    if (posts.count > 0) {
                        int prevNumPosts = self.posts.count;
                        self.posts = [self.posts arrayByAddingObjectsFromArray:posts];
                        NSMutableArray *newIndexPaths = [NSMutableArray array];
                        for (int i = prevNumPosts; i < self.posts.count; i++) {
                            [newIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                        }
                        self.dataSkip += posts.count;
                    }
                    self.isMoreDataLoading = false;
                    [self.tableView reloadData];
                }
            }];
            
        }
    }];
}
- (void)fetchStories {
    PFQuery *storyQuery = [Stories query];
    [storyQuery orderByDescending:@"createdAt"];
    [storyQuery includeKey:@"author"];
    storyQuery.limit = 20;
    [storyQuery findObjectsInBackgroundWithBlock:^(NSArray<Stories *> * _Nullable stories, NSError * _Nullable error) {
        if (stories) {
            NSLog(@"%@", stories);
            self.stories = stories;
            [self.collectionView reloadData];
        }
    }];
}
#pragma mark - RefreshControl
- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self fecthPost];
    [refreshControl endRefreshing];
}
#pragma mark - InfiniteScrolling
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            NSLog(@"More data");
            NSLog(@"%d",self.dataSkip);
            [self fecthMorePost];
        }
    }
}
#pragma mark - LogOut
- (IBAction)onLogOut:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
    }];
}

#pragma mark - Story Logic/ UIImagePickerDelegate
- (IBAction)onStory:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    [Stories postUserStories:editedImage withCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"POSTED");
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqual:@"userSegue"])
    {
        UserViewController *userViewController = [segue destinationViewController];
        userViewController.user = self.user;
    }else if ([segue.identifier isEqual:@"storiesSegue"]){
        StoriesViewController *storiesViewController = [segue destinationViewController];
        storiesViewController.index = self.startIndex;
        storiesViewController.stories = self.stories;
    }else if ([segue.identifier isEqual:@"commentsSegue"]){
        CommentsViewController *commentsViewController = [segue destinationViewController];
        commentsViewController.post = self.post;
    }else{
    }
}

@end
