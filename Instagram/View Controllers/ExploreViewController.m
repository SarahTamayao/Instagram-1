//
//  ExploreViewController.m
//  Instagram
//
//  Created by Xurxo Riesco on 7/8/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "ExploreViewController.h"
#import "ProfileCell.h"
#import "CommentsViewController.h"
#import "Post.h"

@interface ExploreViewController () < UICollectionViewDelegate, UICollectionViewDataSource, ProfileCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) Post *post;

@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = self.collectionView.frame.size.width / postersPerLine;
    CGFloat itemHeight = itemWidth * 0.9;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    [self fecthPost];
    // Do any additional setup after loading the view.
}
- (void)profileCell:(ProfileCell *)profileCell didTap:(Post *)post{
    self.post = post;
    NSLog(@"Hello");
    [self performSegueWithIdentifier:@"detailsSegue" sender:nil];
}
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
            [postQuery whereKey:@"author" notContainedIn:following];
            [postQuery includeKey:@"author"];
            postQuery.limit = 20;
            [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
                if (posts) {
                    NSLog(@"%@", posts);
                    self.posts = [posts mutableCopy];
                    [self.collectionView reloadData];
                }
                else {
                    // handle error
                }
            }];
            
        }
        else {
            // handle error
        }
    }];
}
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



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    CommentsViewController *commentsViewController = [segue destinationViewController];
    commentsViewController.post = self.post;
}


@end
