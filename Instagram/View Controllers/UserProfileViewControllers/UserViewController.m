//
//  UserViewController.m
//  Instagram
//
//  Created by Xurxo Riesco on 7/7/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "UserViewController.h"
#import "User.h"
#import "ProfileCell.h"
#import "CommentsViewController.h"
@import Parse;


@interface UserViewController () <UICollectionViewDelegate, UICollectionViewDataSource, ProfileCellDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property int followerCount;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = self.collectionView.frame.size.width / postersPerLine;
    CGFloat itemHeight = itemWidth * 0.9;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    self.navigationItem.title = self.user[@"username"];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor],
       NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:17]}];
    self.usernameLabel.text = self.user[@"username"];
    self.photoImageView.file = self.user[@"profilePic"];
    self.photoImageView.layer.cornerRadius = 48;
    self.photoImageView.layer.masksToBounds = YES;
    [self fetchFollowingStatus];
    [self.photoImageView loadInBackground];
    [self fecthPost];
}

#pragma mark - Network request
- (void)fecthPost {
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery whereKey:@"author" equalTo:self.user];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            NSLog(@"%@", posts);
            self.posts = [posts mutableCopy];
            self.postLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.posts.count];
            [self.collectionView reloadData];
        }
    }];
}
-(void)fetchFollowingStatus
{
    PFQuery *queryUsers = [PFUser query];
    queryUsers.limit = 20;
    [queryUsers findObjectsInBackgroundWithBlock:^(NSArray* users, NSError * _Nullable error) {
        NSLog(@"HereWeAre");
        NSLog(@"%@", users);
        for(PFUser *user in users)
        {
            NSLog(@"HereWeAreAGAAAIN");
            NSLog(@"%@", user);
            PFRelation *relation = [user relationForKey:@"Following"];
            PFQuery *query = [relation query];
            query.limit = 20;
            BOOL isItMe = NO;
            if([user.username isEqual:([PFUser currentUser].username)]){
                isItMe = YES;
            }
            [query findObjectsInBackgroundWithBlock:^(NSArray<User*>* _Nullable following, NSError * _Nullable error) {
                for(PFUser *user in following){
                    if([user.username isEqual:(self.user.username)]){
                        if(isItMe){
                            self.followButton.titleLabel.text = @"Unfollow";
                        }
                        self.followerCount += 1;
                    }
                }
                self.followersLabel.text = [NSString stringWithFormat:@"%d", self.followerCount];
                self.followingLabel.text = [NSString stringWithFormat:@"%ld", following.count];
            }];
        }
        NSLog(@"%d", self.followerCount);
    }];
}


#pragma mark - CollectionView Delegate
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ProfileCell *profileCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfileCell" forIndexPath: indexPath];
    Post *post = self.posts[indexPath.item];
    [profileCell loadPost:post];
    profileCell.delegate = self;
    return profileCell;
}

#pragma mark - ProfileCell Delegate
- (void)profileCell:(ProfileCell *)profileCell didTap:(Post *)post{
    self.post = post;
    NSLog(@"Hello");
    [self performSegueWithIdentifier:@"detailsSegue" sender:nil];
}

#pragma mark - Following
- (IBAction)onFollow:(id)sender{
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"Following"];
    PFQuery *query = [relation query];
    [query includeKey:@"author"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray<User*>* _Nullable following, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"%@", following);
            if(following.count >0){
                for(PFUser *user in following)
                {
                    NSLog(@"%@", user);
                    if([user[@"username"] isEqual:self.user.username]){
                        [self unfollow];
                    }else{
                        [self follow];
                    }
                }
            }else{
                [self follow];
            }
        }
    }];
}
-(void) unfollow{
    User *currenUser = [PFUser currentUser];
    PFRelation *relation = [currenUser relationForKey:@"Following"];
    [relation removeObject:self.user];
    [currenUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"Unfollowing %@", self.user.username);
            self.followerCount -=2;
            self.followersLabel.text = [NSString stringWithFormat:@"%d", self.followerCount];
            self.followButton.titleLabel.text = @"Follow";
        }
    }];
}
-(void)follow {
    User *currenUser = [PFUser currentUser];
    PFRelation *relation = [currenUser relationForKey:@"Following"];
    [relation addObject:self.user];
    [currenUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"Following %@", self.user.username);
            self.followerCount +=1;
            self.followersLabel.text = [NSString stringWithFormat:@"%d", self.followerCount];
            self.followButton.titleLabel.text = @"Unfollow";
        }
    }];
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CommentsViewController *commentsViewController = [segue destinationViewController];
    commentsViewController.post = self.post;
}
@end
